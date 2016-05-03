//
//  UIWebView+WebViewAdditions.m
//  JS-OC
//
//  Created by MJHee on 16/4/21.
//  Copyright © 2016年 MJHee. All rights reserved.
//

#import "UIWebView+WebViewAdditions.h"

@implementation UIWebView (WebViewAdditions)

- (CGSize)windowSize
{
    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset
{
    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}
@end
