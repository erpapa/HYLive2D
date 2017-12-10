//
//  CGLModelContext.m
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "CGLModelContext.h"
#import "ModelContext.h"

@interface CGLModelContext ()
{
    live2d::ModelContext *_modelContext;
}

@end

@implementation CGLModelContext

- (void *)getModelContext
{
    return _modelContext;
}

- (void)setModelContext:(void *)modelContext
{
    _modelContext = (live2d::ModelContext *)modelContext;
}

@end
