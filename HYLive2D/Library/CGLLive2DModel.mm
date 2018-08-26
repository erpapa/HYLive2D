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
#import "CGLContextManager.h"

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
    GLKTextureLoader *_textureLoader;
}
@end


@implementation CGLLive2DModel

- (instancetype)initWithContextManager:(CGLContextManager *)contextManager
{
    self = [self init];
    if (self) {
        _context = [contextManager createContext];
        _textureLoader = [[GLKTextureLoader alloc] initWithSharegroup:contextManager.sharedGroup];
    }
    return self;
}

- (void)dealloc
{
    // 释放模型
    if (_live2DModel) {
        delete _live2DModel;
        _live2DModel = nullptr;
    }
    
    // 置空
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (int)loadModelWithJsonPath:(NSString *)jsonPath;
{
    NSString *directoryPath = [jsonPath stringByDeletingLastPathComponent];
    NSData* jsonData = [NSData dataWithContentsOfFile:jsonPath];
    if (jsonData == nil) {
        return -1;
    }
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSString *modelName = [jsonDict objectForKey:kCGLLive2DModel];
    NSArray *textures = [jsonDict objectForKey:kCGLLive2DTextures];
    if (modelName.length <= 0) {
        return -1;
    }
    
    if ([EAGLContext currentContext] != self.context) {
        [EAGLContext setCurrentContext:self.context];
    }
    if (_live2DModel) {
        delete _live2DModel;
    }
    // 加载模型
    NSString *modelFilePath = [directoryPath stringByAppendingPathComponent:modelName];
    _live2DModel = live2d::Live2DModelIPhoneES2::loadModel([modelFilePath UTF8String]);
    if (_live2DModel) {
        // _live2DModel->init();
        _drawParam = [[CGLDrawParam alloc] initWithParam:_live2DModel->getDrawParam()];
        _modelContext = [[CGLModelContext alloc] initWithContext:_live2DModel->getModelContext()];
    }

    // 异步加载纹理
    [self asyncLoadTextures:textures textureNo:0 directoryPath:directoryPath];
    return 0;
}

- (void)asyncLoadTextures:(NSArray *)textures textureNo:(int)textureNo directoryPath:(NSString *)directoryPath
{
    if (textureNo < 0 || textureNo >= textures.count) {
        [self update]; // 刷新参数
        return;
    }
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], GLKTextureLoaderApplyPremultiplication,
                             [NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps,
                             nil];
    NSString *textureName = [textures objectAtIndex:textureNo];
    NSString *textureFilePath = [directoryPath stringByAppendingPathComponent:textureName];
    [_textureLoader textureWithContentsOfFile:textureFilePath options:options queue:dispatch_get_main_queue() completionHandler:^(GLKTextureInfo * _Nullable textureInfo, NSError * _Nullable outError) {
        int glTextureNo = [textureInfo name];
        [self setTextureNo:textureNo openGLTextureNo:glTextureNo];
        [self asyncLoadTextures:textures textureNo:textureNo+1 directoryPath:directoryPath];
    }];
}

- (void)update
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->update();
}

- (void)draw
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->draw();
}

- (void)setTextureNo:(int)textureNo openGLTextureNo:(GLuint)openGLTextureNo
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setTexture(textureNo,openGLTextureNo);
}

// 生成纹理
- (int)generateModelTextureNo
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->generateModelTextureNo();
}

// 释放纹理
- (void)releaseModelTextureNo:(int)textureNo
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->releaseModelTextureNo(textureNo);
}

// 获取宽
- (float)getCanvasWidth
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getCanvasWidth();
}

// 获取高
- (float)getCanvasHeight
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getCanvasHeight();
}

- (void *)getModelImpl
{
    if (!_live2DModel) {
        return nullptr;
    }
    return _live2DModel->getModelImpl();
}

- (void)setModelImpl:(void *)m
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setModelImpl((live2d::ModelImpl *)m);
    _live2DModel->init();
}

- (void)loadParam
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->loadParam();
}

- (void)saveParam
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->saveParam();
}

// 获取参数
- (int)getParamIndexWithID:(NSString *)paramID
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getParamIndex(paramID.UTF8String);
}

- (float)getParamFloatWithID:(NSString *)paramID
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getParamFloat(paramID.UTF8String);
}

// 设置参数
- (void)setParamWithID:(NSString *)paramID value:(float)value weight:(float)weight
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setParamFloat(paramID.UTF8String,value,weight);
}

- (void)addToParamWithID:(NSString *)paramID value:(float)value weight:(float)weight
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->addToParamFloat(paramID.UTF8String,value,weight);
}

- (void)multParamWithID:(NSString *)paramID value:(float)value weight:(float)weight
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->multParamFloat(paramID.UTF8String,value,weight);
}

// 获取参数
- (float)getParamFloatWithIndex:(int)paramIndex
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getParamFloat(paramIndex);
}

// 设置参数
- (void)setParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setParamFloat(paramIndex,value,weight);
}

- (void)addToParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->addToParamFloat(paramIndex,value,weight);
}

- (void)multParamWithIndex:(int)paramIndex value:(float)value weight:(float)weight
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->multParamFloat(paramIndex,value,weight);
}

// 透明度
- (float)getPartsOpacityWithID:(NSString *)partsID
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getPartsOpacity(partsID.UTF8String);
}

- (void)setPartsID:(NSString *)partsID opacity:(float)opacity
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setPartsOpacity(partsID.UTF8String, opacity);
}

- (float)getPartsOpacityWithIndex:(int)partsIndex
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getPartsOpacity(partsIndex);
}

- (void)setPartsIndex:(int)partsIndex opacity:(float)opacity
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setPartsOpacity(partsIndex, opacity);
}

// 设置矩阵
- (void)setMatrix:(GLKMatrix4)matrix4
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setMatrix(matrix4.m);
}

// alpha预乘
- (void)setPremultipliedAlpha:(BOOL)b
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setPremultipliedAlpha(b);
}

- (BOOL)isPremultipliedAlpha
{
    if (!_live2DModel) {
        return NO;
    }
    return _live2DModel->isPremultipliedAlpha();
}

// 各向异性过滤
- (void)setAnisotropy:(int)n
{
    if (!_live2DModel) {
        return;
    }
    _live2DModel->setAnisotropy(n);
}

- (int)getAnisotropy
{
    if (!_live2DModel) {
        return 0;
    }
    return _live2DModel->getAnisotropy();
}

@end
