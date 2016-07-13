//
//  BaseWebViewController.m
//  jianfanjia
//
//  Created by Karos on 16/7/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseWebViewController.h"

@implementation BaseWebViewController

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *url = navigationAction.request.URL.absoluteString;
    NSArray *urlElements = [url componentsSeparatedByString:@":"];
    NSString *urlSchemal = urlElements[0];
    NSString *urlParameter = urlElements[1];
    
    if ([urlSchemal isEqualToString:@"tel"]) {
        [self openNativeApp:@"telprompt://" parameter:urlParameter];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlSchemal isEqualToString:@"sms"]) {
        [self openNativeApp:@"sms://" parameter:urlParameter];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else if ([urlSchemal isEqualToString:@"mailto"]) {
        [self openNativeApp:@"mailto://" parameter:urlParameter];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)openNativeApp:(NSString *)urlScheme parameter:(NSString *)parameter {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", urlScheme, parameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
