//
//  GPFrameParser.h
//  CoreText
//
//  Created by ggt on 2017/8/13.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCoreTextData.h"
#import "GPFrameParserConfig.h"

@interface GPFrameParser : NSObject

#pragma mark - Property


#pragma mark - Method
+ (NSDictionary *)attributesWithConfig:(GPFrameParserConfig *)config;

+ (GPCoreTextData *)parseContent:(NSString *)content config:(GPFrameParserConfig*)config;

+ (GPCoreTextData *)parseImageTextContent:(NSString *)content config:(GPFrameParserConfig *)config;

+ (GPCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(GPFrameParserConfig*)config;

@end
