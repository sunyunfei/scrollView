//
//  ViewController.m
//  无限视觉轮播
//
//  Created by 孙云飞 on 2016/10/9.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "ViewController.h"
#import "CoreScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CoreScrollView *coreView = [[CoreScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:coreView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
