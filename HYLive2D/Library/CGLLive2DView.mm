//
//  CGLLive2DView.m
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "CGLLive2DView.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/glext.h>
#import "UtSystem.h"
#import "CGLContextManager.h"
#import "CGLLive2DModel.h"

@interface CGLLive2DView () <GLKViewDelegate>

@property (nonatomic, strong, readwrite) CGLContextManager *contextManager;
@property (nonatomic, strong, readwrite) CGLLive2DModel *live2DModel;
@property (nonatomic, strong, readwrite) EAGLContext *context;
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation CGLLive2DView

- (instancetype)initWithFrame:(CGRect)frame contextManager:(CGLContextManager *)contextManager
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contextManager = contextManager;
        self.context = [self.contextManager createContext];
        self.glkView = [[GLKView alloc] initWithFrame:self.bounds context:self.context];
        self.glkView.delegate = self;
        self.glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
        self.glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        [self addSubview:self.glkView];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayGLKView:)];
        self.displayLink.frameInterval = 3;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.paused = NO;
    }
    return self;
}

- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    self.live2DModel = nil;
    
    // 清空context
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)reloadModel:(CGLLive2DModel *)live2DModel
{
    if (self.live2DModel == live2DModel) {
        return;
    }
    @synchronized(self)
    {
        self.paused = YES;
        self.live2DModel = live2DModel;
        self.paused = NO;
    }
}

- (void)displayGLKView:(id)sender
{
    [self.glkView display];
}

- (BOOL)isPaused
{
    return self.displayLink.paused;
}

- (void)setPaused:(BOOL)paused
{
    self.displayLink.paused = paused;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [EAGLContext setCurrentContext:self.context];
    
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    float scx = 2.0 / [self.live2DModel getCanvasWidth];
    float scy = -2.0 / [self.live2DModel getCanvasWidth] * (screenSize.width/screenSize.height);
    GLKMatrix4 matrix = GLKMatrix4Make(scx, 0, 0, 0,
                                       0, scy, 0, 0,
                                       0,   0, 1, 0,
                                       -1,  1, 0, 1);
    double t = (live2d::UtSystem::getUserTimeMSec()/1000.0) * 2 * M_PI ;
    [self.live2DModel setParamWithID:@"PARAM_ANGLE_X" value:(float)(30 * sin( t/3.0 )) weight:1.0];
    [self.live2DModel setMatrix:matrix];
    [self.live2DModel update];
    [self.live2DModel draw];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.glkView.frame = self.bounds;
}

@end
