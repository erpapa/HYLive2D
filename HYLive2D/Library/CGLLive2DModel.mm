//
//  CGLLive2DModel.m
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "CGLLive2DModel.h"
#import "Live2D.h"
#import "Live2DModelIPhoneES2.h"
#import "DrawParam_OpenGLES2.h"
#import "ModelImpl.h"
#import "ModelContext.h"
#import "CGLDrawParam.h"
#import "CGLModelContext.h"

NSString * const kCGLLive2DVersion = @"version";
NSString * const kCGLLive2DModel = @"model";
NSString * const kCGLLive2DTextures = @"textures";
NSString * const kCGLLive2DMotions = @"motions";
NSString * const kCGLLive2DPhysics = @"physics";
NSString * const kCGLLive2DPose = @"pose";
NSString * const kCGLLive2DProjectSettings = @"project_settings";
NSString * const kCGLLive2DName = @"name";

@interface CGLLive2DModel ()
{
    live2d::Live2DModelIPhoneES2 *_live2DModel;
}
@end


@implementation CGLLive2DModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _drawParam = [[CGLDrawParam alloc] init];
        _modelContext = [[CGLModelContext alloc] init];
    }
    return self;
}

- (instancetype)initWithContext:(EAGLContext *)context
{
    self = [self init];
    if (self) {
        _context = context;
    }
    return self;
}

- (void)dealloc
{
    // 释放模型
    if (_live2DModel) {
        delete _live2DModel;
    }
    // dispose
    live2d::Live2D::dispose();
    // 置空
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)loadModelWithJsonPath:(NSString *)jsonPath;
{
    NSString *directoryPath = [jsonPath stringByDeletingLastPathComponent];
    NSData* jsonData = [NSData dataWithContentsOfFile:jsonPath];
    if (jsonData == nil) {
        return;
    }
    if ([EAGLContext currentContext] != self.context) {
        [EAGLContext setCurrentContext:self.context];
    }
    live2d::Live2D::init();
    
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSString *model = [dict objectForKey:kCGLLive2DModel];
    if (model.length) {
        NSString *modelFilePath = [directoryPath stringByAppendingPathComponent:[dict objectForKey:kCGLLive2DModel]];
        _live2DModel = live2d::Live2DModelIPhoneES2::loadModel([modelFilePath UTF8String]);
    }
    NSArray *textures = [dict objectForKey:kCGLLive2DTextures];
    NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES] ,GLKTextureLoaderApplyPremultiplication, [NSNumber numberWithBool:YES] ,GLKTextureLoaderGenerateMipmaps, nil];
    for (int index = 0; index < textures.count; index++) {
        NSString *textureFilePath = [directoryPath stringByAppendingPathComponent:textures[index]];
        GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:textureFilePath options:option error:nil];
        int glTexNo = [textureInfo name];
        _live2DModel->setTexture(index, glTexNo) ;
    }
}

- (void)update
{
    _live2DModel->update();
}
- (void)draw
{
    _live2DModel->draw();
}
- (void)setTextureNo:(int)textureNo openGLTextureNo:(GLuint)openGLTextureNo
{
    _live2DModel->setTexture(textureNo,openGLTextureNo);
}

// 生成纹理
- (int)generateModelTextureNo
{
    return _live2DModel->generateModelTextureNo();
}
// 释放纹理
- (void)releaseModelTextureNo:(int)textureNo
{
    _live2DModel->releaseModelTextureNo(textureNo);
}
// 获取宽
- (float)getCanvasWidth
{
    return _live2DModel->getCanvasWidth();
}
// 获取高
- (float)getCanvasHeight
{
    return _live2DModel->getCanvasHeight();
}

- (CGLDrawParam *)getDrawParam
{
    live2d::DrawParam *param = _live2DModel->getDrawParam();
    [_drawParam setDrawParam:param];
    return _drawParam;
}

- (CGLModelContext *)getModelContext
{
    live2d::ModelContext *context = _live2DModel->getModelContext();
    [_modelContext setModelContext:context];
    return _modelContext;
}

- (void *)getModelImpl
{
    return _live2DModel->getModelImpl();
}
- (void)setModelImpl:(void *)m
{
    _live2DModel->setModelImpl((live2d::ModelImpl *)m);
}

- (void)loadParam
{
    _live2DModel->loadParam();
}
- (void)saveParam
{
    _live2DModel->saveParam();
}

// 获取参数
- (int)getParamIndexWithID:(NSString *)paramID
{
    return _live2DModel->getParamIndex(paramID.UTF8String);
}
- (float)getParamFloatWithID:(NSString *)paramID
{
    return _live2DModel->getParamFloat(paramID.UTF8String);
}
// 设置参数
- (void)setParamWithID:(NSString *)paramID value:(float)value weight:(float)weight
{
    _live2DModel->setParamFloat(paramID.UTF8String,value,weight);
}
- (void)addToParamWithID:(NSString *)paramID value:(float)value weight:(float)weight
{
    _live2DModel->addToParamFloat(paramID.UTF8String,value,weight);
}
- (void)multParamWithID:(NSString *)paramID value:(float)value weight:(float)weight
{
    _live2DModel->multParamFloat(paramID.UTF8String,value,weight);
}

// 获取参数
- (float)getParamFloatWithIndex:(int)paramIndex
{
    return _live2DModel->getParamFloat(paramIndex);
}
// 设置参数
- (void)setParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight
{
    _live2DModel->setParamFloat(paramIndex,value,weight);
}
- (void)addToParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight
{
    _live2DModel->addToParamFloat(paramIndex,value,weight);
}
- (void)multParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight
{
    _live2DModel->multParamFloat(paramIndex,value,weight);
}

// 透明度
- (float)getPartsOpacityWithID:(NSString *)partsID
{
    return _live2DModel->getPartsOpacity(partsID.UTF8String);
}
- (void)setPartsID:(NSString *)partsID opacity:(float)opacity
{
    _live2DModel->setPartsOpacity(partsID.UTF8String, opacity);
}

- (float)getPartsOpacityWithIndex:(int)partsIndex
{
    return _live2DModel->getPartsOpacity(partsIndex);
}
- (void)setPartsIndex:(int)partsIndex opacity:(float)opacity
{
    _live2DModel->setPartsOpacity(partsIndex, opacity);
}

// 设置矩阵
- (void)setMatrix:(GLKMatrix4)matrix4
{
    _live2DModel->setMatrix(matrix4.m);
}

// alpha预乘
- (void)setPremultipliedAlpha:(BOOL)b
{
    _live2DModel->setPremultipliedAlpha(b);
}
- (BOOL)isPremultipliedAlpha
{
    return _live2DModel->isPremultipliedAlpha();
}

// 各向异性过滤
- (void)setAnisotropy:(int)n
{
    _live2DModel->setAnisotropy(n);
}
- (int)getAnisotropy
{
    return _live2DModel->getAnisotropy();
}

@end
