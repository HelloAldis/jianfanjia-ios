//
//  BaseWebViewController.h
//  jianfanjia
//
//  Created by Karos on 16/7/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

static NSString *DefaultTitle = @"简繁家，让装修变简单";

@interface BaseWebViewController : BaseViewController <WKNavigationDelegate, WKScriptMessageHandler>

@property (strong, nonatomic) ProgressWebView *webView;

@property (assign, nonatomic) BOOL needShare;
@property (assign, nonatomic) BOOL canBack;

@property (strong, nonatomic) NSString *articleImgUrl;
@property (strong, nonatomic) NSString *articleDescription;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *topic;

- (void)initNav;

- (void)addConstraints;
- (void)onClickShare;

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

- (void)showError:(NSError *)error;

@end
