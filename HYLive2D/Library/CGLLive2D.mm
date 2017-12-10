//
//  CGLLive2D.m
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "CGLLive2D.h"
#import "Live2D.h"

@implementation CGLLive2D

+ (NSString *)live2DVersion
{
    return [NSString stringWithUTF8String:live2d::Live2D::getVersionStr()];
}

+ (NSUInteger)live2DVersionNumber
{
    return live2d::Live2D::getVersionNo();
}

@end
