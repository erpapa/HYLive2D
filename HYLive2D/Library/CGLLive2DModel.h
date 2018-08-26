//
//  CGLLive2DModel.h
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/gltypes.h>
#import <GLKit/GLKit.h>

extern NSString * const kCGLLive2DVersion;
extern NSString * const kCGLLive2DModel;
extern NSString * const kCGLLive2DTextures;
extern NSString * const kCGLLive2DMotions;
extern NSString * const kCGLLive2DPhysics;
extern NSString * const kCGLLive2DPose;
extern NSString * const kCGLLive2DProjectSettings;
extern NSString * const kCGLLive2DName;

@class CGLDrawParam;
@class CGLModelContext;
@class CGLContextManager;
@interface CGLLive2DModel : NSObject
{
@private
    EAGLContext *_context;
    CGLDrawParam *_drawParam;
    CGLModelContext *_modelContext;
}

@property (nonatomic, strong, readonly) EAGLContext *context;
@property (nonatomic, strong, readonly) CGLDrawParam *drawParam;
@property (nonatomic, strong, readonly) CGLModelContext *modelContext;

- (instancetype)initWithContextManager:(CGLContextManager *)contextManager;
- (int)loadModelWithJsonPath:(NSString *)jsonPath;

- (void)update;
- (void)draw;
- (void)setTextureNo:(int)textureNo openGLTextureNo:(GLuint)openGLTextureNo;

// 生成纹理
- (int)generateModelTextureNo;
// 释放纹理
- (void)releaseModelTextureNo:(int)textureNo;
// 获取宽
- (float)getCanvasWidth;
// 获取高
- (float)getCanvasHeight;

- (void *)getModelImpl;
- (void)setModelImpl:(void *)m;
- (void)loadParam;
- (void)saveParam;

// 获取参数
- (int)getParamIndexWithID:(NSString *)paramID;
- (float)getParamFloatWithID:(NSString *)paramID;
// 设置参数
- (void)setParamWithID:(NSString *)paramID value:(float)value weight:(float)weight;
- (void)addToParamWithID:(NSString *)paramID value:(float)value weight:(float)weight;
- (void)multParamWithID:(NSString *)paramID value:(float)value weight:(float)weight;

// 获取参数
- (float)getParamFloatWithIndex:(int)paramIndex;
// 设置参数
- (void)setParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight;
- (void)addToParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight;
- (void)multParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight;

// 透明度
- (float)getPartsOpacityWithID:(NSString *)partsID;
- (void)setPartsID:(NSString *)partsID opacity:(float)opacity;

- (float)getPartsOpacityWithIndex:(int)partsIndex;
- (void)setPartsIndex:(int)partsIndex opacity:(float)opacity;

// 设置矩阵
- (void)setMatrix:(GLKMatrix4)matrix4;

// alpha预乘
- (void)setPremultipliedAlpha:(BOOL)b;
- (BOOL)isPremultipliedAlpha;

// 各向异性过滤
- (void)setAnisotropy:(int)n;
- (int)getAnisotropy;

@end
