//
//  Singleton.h
//  sineweibo
//
//  Created by JiangHong on 14/10/31.
//  Copyright (c) 2014年 JiangHong. All rights reserved.
//

#ifndef sineweibo_Singleton_h
#define sineweibo_Singleton_h

#define singleton_interface(className)\
+ (className *)shared##className;

#define singleton_implementation(className)\
static className *_account;\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _account = [super allocWithZone:zone];\
    });\
    return _account;\
}\
+ (id)shared##className\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _account = [[self alloc] init];\
    });\
    return _account;\
}

#endif
