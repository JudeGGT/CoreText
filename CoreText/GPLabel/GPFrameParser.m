//
//  GPFrameParser.m
//  CoreText
//
//  Created by ggt on 2017/8/13.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "GPFrameParser.h"
#import "GPFaceHandler.h"
#import "GPTextImageData.h"

@interface GPFrameParser ()



@end

@implementation GPFrameParser

#pragma mark - Lifecycle

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - Custom Accessors (Setter 方法)


#pragma mark - Public

+ (GPCoreTextData *)parseContent:(NSString *)content config:(GPFrameParserConfig*)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content
                                                                        attributes:attributes];
    return [self parseAttributedContent:contentString config:config];
}

+ (GPCoreTextData *)parseImageTextContent:(NSString *)content config:(GPFrameParserConfig *)config {
    
    NSMutableArray *imageArray = [NSMutableArray array];
    NSAttributedString *attributedString = [self imageWithContent:content config:config imageArray:imageArray];
    
    GPCoreTextData *data = [self parseAttributedContent:attributedString config:config];
    data.imageArray = imageArray;
    
    return data;
}

+ (GPCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(GPFrameParserConfig*)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    GPCoreTextData *data = [[GPCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (NSDictionary *)attributesWithConfig:(GPFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize; // 字体大小
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL); // 设置字体样式，字体大小
    CGFloat lineSpacing = config.lineSpace; // 设置行距
    const CFIndex kNumberOfSettings = 3; // 设置数组元素个数
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = { // 创建样式数组
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing }, // 行距调整
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing }, // 最大行距
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing } // 最小行距
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings); // 设置文本样式
    UIColor * textColor = config.textColor; // 字体颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor; // 设置字体颜色
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef; // 字体样式
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef; // 文本样式
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

#pragma mark - Private


+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(GPFrameParserConfig *)config
                                  height:(CGFloat)height {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (NSAttributedString *)imageWithContent:(NSString *)contentString config:(GPFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray {
    
    NSDictionary *dict = [self attributesWithConfig:config];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:contentString attributes:dict];
    // 先获取到表情所在的位置
    NSArray *resultArray = [[GPFaceHandler sharedGPFaceHandler] patternWithString:contentString];
    
    // 从后往前替换
    for (NSInteger i = resultArray.count - 1; i >= 0; i--) {
        
        NSTextCheckingResult *match = resultArray[i];
        NSArray *array = [GPFaceHandler sharedGPFaceHandler].faceArray;
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [contentString substringWithRange:range];
        for (NSDictionary *dict in array) {
            if ([dict[@"name"] isEqualToString:subStr]) {
                GPTextImageData *imageData = [[GPTextImageData alloc] init];
                // 获取图片名称
                imageData.imageName = [dict valueForKeyPath:@"image"];
                imageData.index = range.location;
                [imageArray addObject:imageData];
                break;
            }
        }
        
        // 利用空白字符代替图片，并且设置它的 CTRunDelegate 信息
        CTRunDelegateCallbacks callBacks;
        memset(&callBacks, 0, sizeof(CTRunDelegateCallbacks));
        callBacks.version = kCTRunDelegateVersion1;
        callBacks.getAscent = RunDelegateGetAscentCallback;
        callBacks.getDescent = RunDelegateGetDescentCallback;
        callBacks.getWidth = RunDelegateGetWidthCallback;
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callBacks, (__bridge void *)(dict));
        
        // 使用 OXFFFC 作为空白的占位符
        unichar objectReplacementChar = 0xFFFC;
        NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
        NSMutableAttributedString *spaceAttributedString = [[NSMutableAttributedString alloc] initWithString:content attributes:dict];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)spaceAttributedString, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
        // 替换
        [resultString replaceCharactersInRange:range withAttributedString:spaceAttributedString];
        
        CFRelease(delegate);
    }
    
    return resultString;
}


#pragma mark - Protocol

#pragma mark - CTRunDelegateCallbacks
void RunDelegateDeallocCallback(void * refCon)
{
    
}

CGFloat RunDelegateGetAscentCallback(void * refCon)
{
    NSDictionary *dictionary = (__bridge NSDictionary *)(refCon);
    UIFont *font = [dictionary valueForKeyPath:@"NSFont"];
    
    return font.lineHeight;
}

CGFloat RunDelegateGetDescentCallback(void * refCon)
{
    
    NSDictionary *dictionary = (__bridge NSDictionary *)(refCon);
    UIFont *font = [dictionary valueForKeyPath:@"NSFont"];

    return font.lineHeight * 4 / 20;
}

CGFloat RunDelegateGetWidthCallback(void * refCon)
{
    NSDictionary *dictionary = (__bridge NSDictionary *)(refCon);
    UIFont *font = [dictionary valueForKeyPath:@"NSFont"];
    
    return font.lineHeight;
}


#pragma mark - 懒加载



@end
