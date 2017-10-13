//
//  GPTextImageData.h
//  CoreText
//
//  Created by ggt on 2017/8/13.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GPTextImageData : NSObject

#pragma mark - Property

@property (nonatomic, copy) NSString *imageName; /**< 图片名称 */
@property (nonatomic, assign) NSUInteger index; /**< 图片位置 */
@property (nonatomic, assign) CGRect imagePosition; /**< 图片的坐标 */


#pragma mark - Method

@end
