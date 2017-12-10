//
//  ViewController.m
//  HYLive2D
//
//  Created by huyong on 2017/12/9.
//  Copyright © 2017年 erpapa. All rights reserved.
//

#import "ViewController.h"
#import "CGLLive2D.h"
#import "CGLLive2DView.h"
#import "CGLLive2DModel.h"
#import "CGLContextManager.h"

@interface ViewController ()

@property (nonatomic, strong) CGLContextManager *contextManager;
@property (nonatomic, strong) CGLLive2DView *live2DView;
@property (nonatomic, strong) CGLLive2DModel *live2DModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"version %@",[CGLLive2D live2DVersion]);
    NSLog(@"version number %ld",(long)[CGLLive2D live2DVersionNumber]);
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.contextManager = [[CGLContextManager alloc] init];
    
    // 模型
    self.live2DView = [[CGLLive2DView alloc] initWithFrame:self.view.bounds contextManager:self.contextManager];
    [self.view addSubview:self.live2DView];
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Haru" ofType:@"bundle"]];
    NSString *jsonPath = [bundle.bundlePath stringByAppendingPathComponent:@"Haru.model.json"];
    self.live2DModel = [[CGLLive2DModel alloc] initWithContext:self.live2DView.context];
    [self.live2DModel loadModelWithJsonPath:jsonPath];
    [self.live2DView reloadModel:self.live2DModel];

}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    self.live2DView.paused = !self.live2DView.paused;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
