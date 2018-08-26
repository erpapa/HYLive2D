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

- (instancetype)initWithContext:(void *)modelContext;
{
    self = [super init];
    if (self) {
        _modelContext = (live2d::ModelContext *)modelContext;
    }
    return self;
}

- (void)dealloc
{
    if (_modelContext) {
        _modelContext->release();
        delete _modelContext;
        _modelContext = nullptr;
    }
}

- (void *)modelContext
{
    return _modelContext;
}

- (void)setupContext
{
    if (!_modelContext) {
        return;
    }
    _modelContext->init();
}

- (void)releaseContext
{
    if (!_modelContext) {
        return;
    }
    _modelContext->release();
}

- (void *)getMemoryParam
{
    if (!_modelContext) {
        return nullptr;
    }
    return _modelContext->getMemoryParam();
}

- (int)getInitVersion
{
    if (!_modelContext) {
        return 0;
    }
    return _modelContext->getInitVersion();
}

- (BOOL)requireSetup
{
    if (!_modelContext) {
        return NO;
    }
    return _modelContext->requireSetup();
}

- (BOOL)update
{
    if (!_modelContext) {
        return NO;
    }
    return _modelContext->update();
}

- (void)preDraw:(void *)dp
{
    if (!_modelContext) {
        return;
    }
    live2d::DrawParam *param = (live2d::DrawParam *)dp;
    _modelContext->preDraw(*param);
}

- (void)draw:(void *)dp
{
    if (!_modelContext) {
        return;
    }
    live2d::DrawParam *param = (live2d::DrawParam *)dp;
    _modelContext->draw(*param);
}

@end
