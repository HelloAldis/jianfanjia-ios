//
//  WebViewDelegate.m
//  jianfanjia
//
//  Created by Karos on 16/7/25.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "WebViewDelegateHandler.h"
#import "WebViewController.h"

@import WebKit;

@interface WebViewDelegateHandler ()

@end

@implementation WebViewDelegateHandler

+ (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    WKFrameInfo *targetFrameInfo = navigationAction.targetFrame;
    if (targetFrameInfo == nil) {
        [WebViewController show:[WebViewDelegateHandler shared].controller withUrl:url shareTopic:@"Link"];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        NSArray *urlElements = [url componentsSeparatedByString:@":"];
        NSString *urlSchemal = urlElements[0];
        NSString *urlParameter = urlElements[1];
        
        if ([urlSchemal isEqualToString:@"tel"]) {
            [[self shared] openNativeApp:@"telprompt://" parameter:urlParameter];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else if ([urlSchemal isEqualToString:@"sms"]) {
            [[self shared]  openNativeApp:@"sms://" parameter:urlParameter];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else if ([urlSchemal isEqualToString:@"mailto"]) {
            [[self shared]  openNativeApp:@"mailto://" parameter:urlParameter];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - native call
- (void)openNativeApp:(NSString *)urlScheme parameter:(NSString *)parameter {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", urlScheme, parameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (instancetype)shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


@end
