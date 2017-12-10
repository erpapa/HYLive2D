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

- (void *)getDrawParam
{
    return _drawParam;
}

- (void)setDrawParam:(void *)drawParam
{
    _drawParam = (live2d::DrawParam_OpenGLES2 *)drawParam;
}

- (void)setupDraw
{
    _drawParam->setupDraw();
}
- (void)cleanupDraw
{
    _drawParam->cleanupDraw();
}

- (void)drawTextureNo:(int)textureNo indexCount:(int)indexCount vertexCount:(int)vertexCount indexArray:(unsigned short *)indexArray vertexArray:(float *)vertexArray uvArray:(float *)uvArray opacity:(float)opacity colorCompositionType:(int)colorCompositionType
{
    _drawParam->drawTexture(textureNo,indexCount,vertexCount,indexArray,vertexArray,uvArray,opacity,colorCompositionType);
}

- (void)setTexture:(int)modelTextureNo textureNo:(GLuint)textureNo
{
    _drawParam->setTexture(modelTextureNo,textureNo);
}
- (void *)getTextures
{
    return _drawParam->getTextures();
}
- (int)generateModelTextureNo
{
    return _drawParam->generateModelTextureNo();
}
- (void)releaseModelTextureNo:(int)no
{
    _drawParam->releaseModelTextureNo(no);
}

- (BOOL)enabledTextureInfo:(int)no
{
    return _drawParam->enabledTextureInfo(no);
}

// 颜色
- (void)setBaseColor:(float)alpha red:(float)red green:(float)green blue:(float)blue
{
    _drawParam->setBaseColor(alpha,red,green,blue);
}
- (void)setTextureColor:(int)textureNo red:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
    _drawParam->setTextureColor(textureNo,red,green,blue,alpha);
}
- (void)setTextureScale:(int)textureNo scale:(float)scale
{
    _drawParam->setTextureScale(textureNo,scale);
}
- (void)setTextureInterpolate:(int)textureNo interpolate:(float)interpolate
{
    _drawParam->setTextureInterpolate(textureNo,interpolate);
}
- (void)setTextureBlendMode:(int)textureNo mode:(int)mode
{
    _drawParam->setTextureBlendMode(textureNo,mode);
}

// culling
- (void)setCulling:(BOOL)culling
{
    _drawParam->setCulling(culling);
}

// 矩阵
- (void)setMatrix:(GLKMatrix4)matrix4
{
    _drawParam->setMatrix(matrix4.m);
}
- (GLKMatrix4)getMatrix
{
    return GLKMatrix4MakeWithArray(_drawParam->getMatrix());
}

// alpha预乘
- (void)setPremultipliedAlpha:(BOOL)b
{
    _drawParam->setPremultipliedAlpha(b);
}
- (BOOL)isPremultipliedAlpha
{
    return _drawParam->isPremultipliedAlpha();
}

// 各向异性过滤
- (void)setAnisotropy:(int)n
{
    _drawParam->setAnisotropy(n);
}
- (int)getAnisotropy
{
    return _drawParam->getAnisotropy();
}

@end
