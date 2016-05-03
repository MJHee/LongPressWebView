////
////  WebViewController.m
////  JS-OC
////
////  Created by MJHee on 16/4/20.
////  Copyright © 2016年 MJHee. All rights reserved.
////
//
//#import "WebViewController.h"
//#import <WebKit/WKFoundation.h>
//#import "WKWebView+WebViewAdditions.h"
//#import <WebKit/WebKit.h>
//
//@interface WebViewController () <WKNavigationDelegate, WKScriptMessageHandler, UIActionSheetDelegate>
///** 请求 */
//@property (strong, nonatomic) NSURLRequest *req;
///** 图片链接 */
//@property (strong, nonatomic) NSURL *imgURL;
///** 时间 */
//@property (strong, nonatomic) NSTimer *timer;
///** webView */
//@property (strong, nonatomic) WKWebView *webV;
///** 选中链接的链接 */
//@property (strong, nonatomic) NSString *selectedLinkURL;
///** 选中图片的链接 */
//@property (strong, nonatomic) NSString *selectedImageURL;
///** alterView */
//@property (strong, nonatomic) UIActionSheet *actionActionSheet;
//
//@end
//
//static NSString* const kTouchJavaScriptString=
//@"document.ontouchstart=function(event){\
//x=event.targetTouches[0].clientX;\
//y=event.targetTouches[0].clientY;\
//document.location=\"myweb:touch:start:\"+x+\":\"+y;};\
//document.ontouchmove=function(event){\
//x=event.targetTouches[0].clientX;\
//y=event.targetTouches[0].clientY;\
//document.location=\"myweb:touch:move:\"+x+\":\"+y;};\
//document.ontouchcancel=function(event){\
//document.location=\"myweb:touch:cancel\";};\
//document.ontouchend=function(event){\
//document.location=\"myweb:touch:end\";};";
//
//@implementation WebViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self setUI];
//}
//
//- (void)setUI{
//    
//    NSString *js = @"window.webkit.messageHandlers.observe.postMessage(document.body.innerText);" ;// 注意这里的observe字段是自己写的，不是固定的写法，参考第6行
//    WKUserScript *userS = [[WKUserScript alloc] init];
//    WKUserScript *script =  [userS initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];// 这里的 AtDocumentEnd 字段是指网页中的内容加载完毕后再插入 JS 脚本，你也可以选择 AtDocumentStart，在 document element 刚刚创建时就插入脚本，看具体需求
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    [[config userContentController] addUserScript:script];
//    [[config userContentController] addScriptMessageHandler:self name:@"observe"];// 对应第一行 JS 脚本中的observe字段
//    
//    
//    //初始化WKWebView
//    _webV = [[WKWebView alloc] initWithFrame:self.view.frame];
//    _webV.backgroundColor = [UIColor greenColor];
//    _webV.navigationDelegate = self;
//    
//    //添加长按手势
//    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPressRecognizer.allowableMovement = 20;
//    longPressRecognizer.minimumPressDuration = 1.0f;
//    [_webV addGestureRecognizer:longPressRecognizer];
//    
//    //加载网页
//    NSURL *Url =[NSURL URLWithString:@"http://www.baidu.com"];
//    _req = [NSURLRequest requestWithURL:Url];
//    [_webV loadRequest:_req];
//    
//    
//    [self.view addSubview:_webV];
//    
//    
//}
////#pragma mark - UIActionSheetDelegate
////-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
////    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open Link"]){
////        [_webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_selectedLinkURL]]];
////    }
////    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy Link"]){
////        [[UIPasteboard generalPasteboard] setString:_selectedLinkURL];
////    }
////    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy Image"]){
////        [[UIPasteboard generalPasteboard] setString:_selectedImageURL];
////    }
////    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save Image"]){
////        NSOperationQueue *queue = [NSOperationQueue new];
////        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
////                                                                                selector:@selector(saveImageURL:) object:_selectedImageURL];
////        [queue addOperation:operation];
////        //[operation release];
////    }
////}
////
////#pragma mark - 保存图片
////-(void)saveImageURL:(NSString*)url{
////    [self performSelectorOnMainThread:@selector(showStartSaveAlert)
////                           withObject:nil
////                        waitUntilDone:YES];
////    
////    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
////    
////    [self performSelectorOnMainThread:@selector(showFinishedSaveAlert)
////                           withObject:nil
////                        waitUntilDone:YES];
////}
////
////- (void)showStartSaveAlert
////{
////    
////}
////- (void)showFinishedSaveAlert
////{
////    
////}
////
////
////#pragma mark - WKScriptMessageHandler
////- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
////{
////    // 因为我们抓取到的是文本，这里把 message.body 强制转换为 NSString，如果你通过 JS 拿到的是其他信息，按需转换
////    
////    NSString *str = (NSString *)message.body;
////    NSLog(@"str=%@", str);
////}
////
////#pragma mark - 手势处理
////-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
////{
////    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
////        
////        CGPoint pt = [gestureRecognizer locationInView:self.webV];
////        
////        // convert point from view to HTML coordinate system
////        CGSize viewSize = [self.webV frame].size;
////        CGSize windowSize = [self.webV windowSize];
////        CGFloat f = windowSize.width / viewSize.width;
////        
////        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0) {
////            pt.x = pt.x * f;
////            pt.y = pt.y * f;
////        }else {
////            // On iOS 4 and previous, document.elementFromPoint is not taking
////            // offset into account, we have to handle it
////            CGPoint offset = [self.webV scrollOffset];
////            pt.x = pt.x * f + offset.x;
////            pt.y = pt.y * f + offset.y;
////        }
////        
////        [self openContextualMenuAt:pt];
////    }
////}
////- (void)openContextualMenuAt:(CGPoint)pt{
////    // Load the JavaScript code from the Resources and inject it into the web page
////    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Naving" ofType:@"bundle"]];
////    NSString *path = [bundle pathForResource:@"JSTools" ofType:@"js"];
////    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
////    [_webV stringByEvaluatingJavaScriptFromString:jsCode];
////    
////    // get the Tags at the touch location
////    NSString *tags = [_webV stringByEvaluatingJavaScriptFromString:
////                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
////    
////    NSString *tagsHREF = [_webV stringByEvaluatingJavaScriptFromString:
////                          [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
////    
////    NSString *tagsSRC = [_webV stringByEvaluatingJavaScriptFromString:
////                         [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
////    
////    NSLog(@"tags : %@",tags);
////    NSLog(@"href : %@",tagsHREF);
////    NSLog(@"src : %@",tagsSRC);
////    
////    if (!_actionActionSheet) {
////        _actionActionSheet = nil;
////    }
////    _actionActionSheet = [[UIActionSheet alloc] initWithTitle:nil
////                                                     delegate:self
////                                            cancelButtonTitle:nil
////                                       destructiveButtonTitle:nil
////                                            otherButtonTitles:nil];
////    
////    _selectedLinkURL = @"";
////    _selectedImageURL = @"";
////    
////    // If an image was touched, add image-related buttons.
////    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
////        _selectedImageURL = tagsSRC;
////        
////        if (_actionActionSheet.title == nil) {
////            _actionActionSheet.title = tagsSRC;
////        }
////        
////        [_actionActionSheet addButtonWithTitle:@"保存图片"];
////        [_actionActionSheet addButtonWithTitle:@"复制图片"];
////    }
////    // If a link is pressed add image buttons.
////    if ([tags rangeOfString:@",A,"].location != NSNotFound){
////        _selectedLinkURL = tagsHREF;
////        
////        _actionActionSheet.title = tagsHREF;
////        [_actionActionSheet addButtonWithTitle:@"打开链接"];
////        [_actionActionSheet addButtonWithTitle:@"复制链接"];
////    }
////    
////    if (_actionActionSheet.numberOfButtons > 0) {
////        [_actionActionSheet addButtonWithTitle:@"取消"];
////        _actionActionSheet.cancelButtonIndex = (_actionActionSheet.numberOfButtons-1);
////        
////        
////        [_actionActionSheet showInView:_webV];
////    }
////    
////}
////
////
////#pragma mark - WKNavigationDelegate
////- (void)webView:(WKWebView *)webView
////didFinishNavigation:(WKNavigation *)navigation{
////    [self.webV stringByEvaluatingJavaScriptFromString:kTouchJavaScriptString];
////}
////- (void)webView:(WKWebView *)webView
////didStartProvisionalNavigation:(WKNavigation *)navigation{
////    NSString *requestString = [[_req URL] absoluteString];
////    NSArray *components = [requestString componentsSeparatedByString:@":"];
////    
////    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"myweb"])
////    {
////        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"touch"])
////        {
////            //NSLog(@"you are touching!");
////            //NSTimeInterval delaytime = Delaytime;
////            if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"start"])
////            {
////                /*
////                 @需延时判断是否响应页面内的js...
////                 */
////                _gesState = GESTURE_STATE_START;
////                NSLog(@"touch start!");
////                
////                CGFloat ptX = [[components objectAtIndex:3] floatValue];
////                CGFloat ptY = [[components objectAtIndex:4] floatValue];
////                NSLog(@"touch point (%f, %f)", ptX, ptY);
////                
////                NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", ptX, ptY];
////                NSString * tagName = [self.webV stringByEvaluatingJavaScriptFromString:js];
////                _imgURL = nil;
////                if ([tagName isEqualToString:@"IMG"]) {
////                    _imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", ptX, ptY];
////                }
////                if (_imgURL) {
////                    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleLongTouch) userInfo:nil repeats:NO];
////                }
////            }
////            else if ([(NSString *)[components objectAtIndex:2] isEqualToString:@"move"])
////            {
////                //**如果touch动作是滑动，则取消hanleLongTouch动作**//
////                _gesState = GESTURE_STATE_MOVE;
////                NSLog(@"you are move");
////            }
////        }
////        else if ([(NSString*)[components objectAtIndex:2]isEqualToString:@"end"]) {
////            [_timer invalidate];
////            _timer = nil;
////            _gesState = GESTURE_STATE_END;
////            NSLog(@"touch end");
////        }
////        return NO;
////    }
////    return YES;
////}
////
////- (void)handleLongTouch {
////    //    NSLog(@"%@", _imgURL);
////    //    if (_imgURL && _gesState == GESTURE_STATE_START) {
////    //        UIActionSheet* sheet = ［UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
////    //        sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
////    //        [sheet showInView:[UIApplication sharedApplication].keyWindow];
////    //    }
////}
////
////- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
////    //    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
////    //        return;
////    //    }
////    //    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
////    //    if ([title isEqualToString:@"保存图片"]) {
////    //        if (_imgURL) {
////    //            NSLog(@"imgurl = %@", _imgURL);
////    //        }
////    //        NSString *urlToSave = [self.getWebView stringByEvaluatingJavaScriptFromString:_imgURL];
////    //        NSLog(@"image url=%@", urlToSave);
////    //
////    //        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlToSave］;
////    //                                                      UIImage* image = [UIImage imageWithData:data];
////    //
////    //                                                      //UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
////    //                                                      UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
////    //                                                      }
////    //                                                      }
////    //
////    //                                                      - (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
////    //        {
////    //            if (error){
////    //                NSLog(@"Error");
////    //                [self showAlert:SNS_IMAGE_HINT_SAVE_FAILE];
////    //            }else {
////    //                NSLog(@"OK");
////    //                [self showAlert:SNS_IMAGE_HINT_SAVE_SUCCE];
////    //            }
////    
////}
////
//
//
//@end
