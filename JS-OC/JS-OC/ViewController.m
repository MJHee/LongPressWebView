//
//  ViewController.m
//  JS-OC
//
//  Created by MJHee on 16/4/20.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
- (void)setUI
{
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setTitle:@"展示webView" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(Push) forControlEvents:UIControlEventTouchUpInside];
    [pushBtn sizeToFit];
    pushBtn.center = self.view.center;
    
    [self.view addSubview:pushBtn];
}

#pragma mark - 按钮点击 
- (void)Push
{ 
    
    WebViewController *webVC = [[WebViewController alloc] init];
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}
@end
