//
//  CGLModelContext.h
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGLModelContext : NSObject

- (instancetype)initWithContext:(void *)modelContext;
- (void *)modelContext;

- (void)setupContext;
- (void)releaseContext;

- (void *)getMemoryParam;
- (int)getInitVersion;
- (BOOL)requireSetup;
- (BOOL)update;
- (void)preDraw:(void *)dp;
- (void)draw:(void *)dp;

@end
