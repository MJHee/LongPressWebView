//
//  WebLongPressViewController.m
//  JS-OC
//
//  Created by MJHee on 16/5/10.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "WebLongPressViewController.h"
#import "UIWebView+WebViewAdditions.h"

@interface WebLongPressViewController ()<UIActionSheetDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>
/** 用于UIWebView保存图片 */
@property (strong, nonatomic) NSTimer *timer;
/** 保存图片状态 */
@property (nonatomic, assign) int gesState;
/** 图片链接 */
@property (strong, nonatomic) NSString *imgURL;
/** webView */
@property (strong, nonatomic) UIWebView *webV;
/** 请求 */
@property (strong, nonatomic) NSURLRequest *req;
/** 长按手势 */
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressRecognizer;

@end

@implementation WebLongPressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
