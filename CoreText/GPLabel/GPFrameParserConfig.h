//
//  GPFrameParserConfig.h
//  CoreText
//
//  Created by ggt on 2017/8/13.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GPFrameParserConfig : NSObject

#pragma mark - Property

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;


#pragma mark - Method

@end
