//
//  GPCoreTextData.h
//  CoreText
//
//  Created by ggt on 2017/8/13.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface GPCoreTextData : NSObject

#pragma mark - Property

@property (assign, nonatomic) CTFrameRef ctFrame;
@property (assign, nonatomic) CGFloat height;
@property (nonatomic, strong) NSArray *imageArray; /**< 图片数组 */


#pragma mark - Method

@end
