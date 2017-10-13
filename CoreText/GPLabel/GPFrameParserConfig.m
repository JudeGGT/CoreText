//
//  GPFrameParserConfig.m
//  CoreText
//
//  Created by ggt on 2017/8/13.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "GPFrameParserConfig.h"
#import <CoreText/CoreText.h>
#import "GPCoreTextData.h"

@interface GPFrameParserConfig ()



@end

@implementation GPFrameParserConfig

#pragma mark - Lifecycle

- (instancetype)init {
    
    if (self = [super init]) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor =  [UIColor colorWithRed:108/255.0f green:108/255.0f blue:108/255.0f alpha:1.0f];;
    }
    return self;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - Custom Accessors (Setter 方法)


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol


#pragma mark - 懒加载



@end
