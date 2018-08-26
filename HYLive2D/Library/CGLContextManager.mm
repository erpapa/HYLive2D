//
//  CGLContextManager.m
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "CGLContextManager.h"
#import "Live2D.h"

@interface CGLContextManager()

@property (nonatomic, strong, readwrite) EAGLSharegroup *sharedGroup;
@property (nonatomic, assign, readwrite) BOOL isLive2dInit;

@end

@implementation CGLContextManager

- (EAGLContext *)createContext
{
    @synchronized(self)
    {
        if (!self.sharedGroup)
        {
            EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
            self.sharedGroup = context.sharegroup;
            return context;
        }
        else
        {
            EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:self.sharedGroup];
            return context;
        }
    }
}

- (void)setupLiveContext
{
    if (self.isLive2dInit) {
        return;
    }
    live2d::Live2D::init();
}

- (void)disposeLiveContext
{
    if (!self.isLive2dInit) {
        return;
    }
    live2d::Live2D::dispose();
}

@end
