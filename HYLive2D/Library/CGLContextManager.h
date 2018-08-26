//
//  CGLContextManager.h
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>

@interface CGLContextManager : NSObject

@property (nonatomic, strong, readonly) EAGLSharegroup *sharedGroup;

- (EAGLContext *)createContext;

- (void)setupLiveContext;
- (void)disposeLiveContext;

@end
