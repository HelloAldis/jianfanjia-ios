//
//  WebViewDelegate.h
//  jianfanjia
//
//  Created by Karos on 16/7/25.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewDelegateHandler : NSObject

@property (nonatomic, weak) UIViewController *controller;

+ (instancetype)shared;

+ (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end
