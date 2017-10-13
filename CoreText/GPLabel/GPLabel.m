//
//  GPLabel.m
//  CoreText
//
//  Created by ggt on 2017/8/11.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "GPLabel.h"
#import <CoreText/CoreText.h>
#import "GPTextImageData.h"

@interface GPLabel ()

@end

@implementation GPLabel

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (self.coreTextData) {
        CTFrameDraw(self.coreTextData.ctFrame, context);
        
        for (GPTextImageData *imageData in self.coreTextData.imageArray) {
            UIImage *image = [UIImage imageNamed:imageData.imageName];
            if (image) {
                CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
            }
        }
    }
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - UI

- (void)setupUI {
    
    
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)

- (void)setCoreTextData:(GPCoreTextData *)coreTextData {
    
    _coreTextData = coreTextData;
}


#pragma mark - IBActions


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol


#pragma mark - 懒加载

@end
