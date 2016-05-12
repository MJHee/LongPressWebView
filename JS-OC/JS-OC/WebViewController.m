//
//  WebViewController.m
//  JS-OC
//
//  Created by MJHee on 16/4/20.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "WebViewController.h"
#import "UIWebView+WebViewAdditions.h"

@interface WebViewController()<UIActionSheetDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>
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

static NSString* const kTouchJavaScriptString=
@"document.ontouchstart=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
document.ontouchmove=function(event){\
x=event.targetTouches[0].clientX;\
y=event.targetTouches[0].clientY;\
document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
document.ontouchcancel=function(event){\
document.location=\"myweb:touch:cancel\";};\
document.ontouchend=function(event){\
document.location=\"myweb:touch:end\";};};";


@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

- (void)setUI{
    
    //初始化WKWebView
    _webV = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webV.backgroundColor = [UIColor greenColor];
    _webV.delegate = self;
    
    //添加长按手势
//    _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
//    _longPressRecognizer.minimumPressDuration = 1.0f;
//    
//    [_webV addGestureRecognizer:_longPressRecognizer];
    
    //加载网页
    NSURL *Url =[NSURL URLWithString:@"http://cdn.duitang.com/uploads/item/201601/27/20160127153237_CheEB.jpeg"];
    _req = [NSURLRequest requestWithURL:Url];
    [_webV loadRequest:_req];

    [self.view addSubview:_webV];
}


// 功能：UIWebView响应长按事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)_request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[_request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0]
                                   isEqualToString:@"myweb"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
        {
            //NSLog(@"you are touching!");
            //NSTimeInterval delaytime = Delaytime;
            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
            {
                /*
                 @需延时判断是否响应页面内的js...
                 */
                _gesState = GESTURE_STATE_START;
                NSLog(@"touch start!");
                
                float ptX = [[components objectAtIndex:3]floatValue];
                float ptY = [[components objectAtIndex:4]floatValue];
                NSLog(@"touch point (%f, %f)", ptX, ptY);
                
                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
                NSString * tagName = [self.webV stringByEvaluatingJavaScriptFromString:js];
                _imgURL = nil;
                if ([tagName isEqualToString:@"IMG"]) {
                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
                }
                if (_imgURL) {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
                }
                
            }
            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
            {
                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
                _gesState = GESTURE_STATE_MOVE;
                NSLog(@"you are move");
            }
        }
        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
            [_timer invalidate];
            _timer = nil;
            _gesState = GESTURE_STATE_END;
            NSLog(@"touch end");
        }
        return NO;
    }
    
    return YES;
}
// 网页加载完成时触发
#pragma mark UIWebDelegate implementation
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    // Black base color for background matches the native apps
    webView.backgroundColor = [UIColor blackColor];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
    
    // 当iOS版本大于7时，向下移动20dp
    
    
    // 防止内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    // 响应touch事件，以及获得点击的坐标位置，用于保存图片
    [webView stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
}


#pragma mark - 手势处理
// 功能：如果点击的是图片，并且按住的时间超过1s，执行handleLongTouch函数，处理图片的保存操作。
- (void)handleLongTouch {
    NSLog(@"%@", _imgURL);
    if (_imgURL && _gesState == GESTURE_STATE_START) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
        [sheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}
// 功能：保存图片到手机
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存到手机"]) {
        if (_imgURL) {
            NSLog(@"imgurl = %@", _imgURL);
        }
        NSString *urlToSave = [self.webV stringByEvaluatingJavaScriptFromString:_imgURL];
        NSLog(@"image url = %@", urlToSave);
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave]];
        UIImage* image = [UIImage imageWithData:data];
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        NSLog(@"UIImageWriteToSavedPhotosAlbum = %@", urlToSave);
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
// 功能：显示对话框
-(void)showAlert:(NSString *)msg {
    NSLog(@"showAlert = %@", msg);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil];
    [alert show];
}
// 功能：显示图片保存结果
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error){
        NSLog(@"Error");
        [self showAlert:@"保存失败!"];
    }else {
        NSLog(@"OK");
        [self showAlert:@"保存成功!"];
    }
}

@end
