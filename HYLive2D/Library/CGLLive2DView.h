//
//  CGLLive2DView.h
//  HYLive2D
//
//  Created by huyong on 2017/12/10.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGLContextManager;
@class CGLLive2DModel;
@interface CGLLive2DView : UIView

@property (nonatomic, strong, readonly) CGLContextManager *contextManager;
@property (nonatomic, strong, readonly) CGLLive2DModel *live2DModel;
@property (nonatomic, strong, readonly) EAGLContext *context;
@property (nonatomic, assign, getter=isPaused) BOOL paused;

- (instancetype)initWithFrame:(CGRect)frame contextManager:(CGLContextManager *)contextManager;

- (void)reloadModel:(CGLLive2DModel *)live2DModel;

@end
