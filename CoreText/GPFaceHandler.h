//
//  GPFaceHandler.h
//  FacePic
//
//  Created by ggt on 2017/8/8.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface GPFaceHandler : NSObject

#pragma mark - Property

@property (nonatomic, strong) NSArray <NSDictionary *>*faceArray; /**< 表情数组 */
@property (nonatomic, assign) CGFloat attributedStringFont; /**< 字体大小 */


#pragma mark - Method

singleton_interface(GPFaceHandler)

/**
 匹配表情字符
 */
- (NSArray<NSTextCheckingResult *> *)patternWithString:(NSString *)string;

/**
 根据字符串生成相应的属性字符串
 */
- (NSMutableAttributedString *)attributeStringWithString:(NSString *)string;

/**
 根据正则匹配到的数组生成相应的属性字符串
 */
- (NSMutableAttributedString *)attributeStringWithArray:(NSArray<NSTextCheckingResult *> *)array string:(NSString *)string;

@end
