//
//  GPFaceHandler.m
//  FacePic
//
//  Created by ggt on 2017/8/8.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "GPFaceHandler.h"

@interface GPFaceHandler ()



@end

@implementation GPFaceHandler

#pragma mark - Lifecycle

singleton_implementation(GPFaceHandler)

- (instancetype)init {
    
    if (self = [super init]) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"plist"];
        self.faceArray = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - Custom Accessors (Setter 方法)


#pragma mark - Public

/**
 匹配表情字符
 */
- (NSArray<NSTextCheckingResult *> *)patternWithString:(NSString *)string {
    
    NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    return [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
}

/**
 根据字符串生成相应的属性字符串
 */
- (NSMutableAttributedString *)attributeStringWithString:(NSString *)string {
    
    NSArray *resultArray = [self patternWithString:string];

    return [self attributeStringWithArray:resultArray string:string];
}

/**
 根据正则匹配到的数组生成相应的属性字符串
 */
- (NSMutableAttributedString *)attributeStringWithArray:(NSArray<NSTextCheckingResult *> *)array string:(NSString *)string {
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:array.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in array) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [string substringWithRange:range];
        
        for (int i = 0; i < self.faceArray.count; i ++) {
            if ([self.faceArray[i][@"name"] isEqualToString:subStr]) {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                CGFloat y = -(self.attributedStringFont * 4 / 20);
                textAttachment.bounds = CGRectMake(0, y, self.attributedStringFont, self.attributedStringFont);
                
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:self.faceArray[i][@"image"]];
                
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    
    //从后往前替换
    for (NSInteger i = imageArray.count - 1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }

    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.attributedStringFont] range:NSMakeRange(0, attributeString.length)];
    
    return attributeString;
}


#pragma mark - Private


#pragma mark - Protocol


#pragma mark - 懒加载



@end
