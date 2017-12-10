//
//  CGLDrawParam.h
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/gltypes.h>
#import <GLKit/GLKit.h>

@interface CGLDrawParam : NSObject

- (void *)getDrawParam;
- (void)setDrawParam:(void *)drawParam;

- (void)setupDraw;
- (void)cleanupDraw;

- (void)drawTextureNo:(int)textureNo indexCount:(int)indexCount vertexCount:(int)vertexCount indexArray:(unsigned short *)indexArray vertexArray:(float *)vertexArray uvArray:(float *)uvArray opacity:(float)opacity colorCompositionType:(int)colorCompositionType;

- (void)setTexture:(int)modelTextureNo textureNo:(GLuint)textureNo;
- (void *)getTextures;
- (int)generateModelTextureNo;
- (void)releaseModelTextureNo:(int)no;
- (BOOL)enabledTextureInfo:(int)no;

// 颜色
- (void)setBaseColor:(float)alpha red:(float)red green:(float)green blue:(float)blue;
- (void)setTextureColor:(int)textureNo red:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
- (void)setTextureScale:(int)textureNo scale:(float)scale;
- (void)setTextureInterpolate:(int)textureNo interpolate:(float)interpolate;
- (void)setTextureBlendMode:(int)textureNo mode:(int)mode;

// culling
- (void)setCulling:(BOOL)culling;

// 矩阵
- (void)setMatrix:(GLKMatrix4)matrix4;
- (GLKMatrix4)getMatrix;

// alpha预乘
- (void)setPremultipliedAlpha:(BOOL)b;
- (BOOL)isPremultipliedAlpha;

// 各向异性过滤
- (void)setAnisotropy:(int)n;
- (int)getAnisotropy;

@end
