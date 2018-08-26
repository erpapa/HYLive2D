//
//  CGLDrawParam.m
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "CGLDrawParam.h"
#import "Live2D.h"
#import "DrawParam_OpenGLES2.h"

@interface CGLDrawParam ()
{
    live2d::DrawParam_OpenGLES2 *_drawParam;
}

@end

@implementation CGLDrawParam

- (instancetype)initWithParam:(void *)drawParam;
{
    self = [super init];
    if (self) {
        _drawParam = (live2d::DrawParam_OpenGLES2 *)drawParam;
    }
    return self;
}

- (void)dealloc
{
    if (_drawParam) {
        delete _drawParam;
        _drawParam = nullptr;
    }
}

- (void *)drawParam
{
    return _drawParam;
}

- (void)setupDraw
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setupDraw();
}

- (void)cleanupDraw
{
    if (!_drawParam) {
        return;
    }
    _drawParam->cleanupDraw();
}

- (void)drawTextureNo:(int)textureNo indexCount:(int)indexCount vertexCount:(int)vertexCount indexArray:(unsigned short *)indexArray vertexArray:(float *)vertexArray uvArray:(float *)uvArray opacity:(float)opacity colorCompositionType:(int)colorCompositionType
{
    if (!_drawParam) {
        return;
    }
    _drawParam->drawTexture(textureNo,indexCount,vertexCount,indexArray,vertexArray,uvArray,opacity,colorCompositionType);
}

- (void)setTexture:(int)modelTextureNo textureNo:(GLuint)textureNo
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setTexture(modelTextureNo,textureNo);
}

- (void *)getTextures
{
    if (!_drawParam) {
        return NULL;
    }
    return _drawParam->getTextures();
}

- (int)generateModelTextureNo
{
    if (!_drawParam) {
        return 0;
    }
    return _drawParam->generateModelTextureNo();
}

- (void)releaseModelTextureNo:(int)no
{
    if (!_drawParam) {
        return;
    }
    _drawParam->releaseModelTextureNo(no);
}

- (BOOL)enabledTextureInfo:(int)no
{
    if (!_drawParam) {
        return NO;
    }
    return _drawParam->enabledTextureInfo(no);
}

// 颜色
- (void)setBaseColor:(float)alpha red:(float)red green:(float)green blue:(float)blue
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setBaseColor(alpha,red,green,blue);
}

- (void)setTextureColor:(int)textureNo red:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setTextureColor(textureNo,red,green,blue,alpha);
}

- (void)setTextureScale:(int)textureNo scale:(float)scale
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setTextureScale(textureNo,scale);
}

- (void)setTextureInterpolate:(int)textureNo interpolate:(float)interpolate
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setTextureInterpolate(textureNo,interpolate);
}

- (void)setTextureBlendMode:(int)textureNo mode:(int)mode
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setTextureBlendMode(textureNo,mode);
}

// culling
- (void)setCulling:(BOOL)culling
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setCulling(culling);
}

// 矩阵
- (void)setMatrix:(GLKMatrix4)matrix4
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setMatrix(matrix4.m);
}

- (GLKMatrix4)getMatrix
{
    if (!_drawParam) {
        return GLKMatrix4Identity;
    }
    return GLKMatrix4MakeWithArray(_drawParam->getMatrix());
}

// alpha预乘
- (void)setPremultipliedAlpha:(BOOL)b
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setPremultipliedAlpha(b);
}

- (BOOL)isPremultipliedAlpha
{
    if (!_drawParam) {
        return NO;
    }
    return _drawParam->isPremultipliedAlpha();
}

// 各向异性过滤
- (void)setAnisotropy:(int)n
{
    if (!_drawParam) {
        return;
    }
    _drawParam->setAnisotropy(n);
}

- (int)getAnisotropy
{
    if (!_drawParam) {
        return 0;
    }
    return _drawParam->getAnisotropy();
}

@end
