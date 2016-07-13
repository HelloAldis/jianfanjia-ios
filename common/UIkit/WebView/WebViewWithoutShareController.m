//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "WebViewWithoutShareController.h"


@implementation WebViewWithoutShareController

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url {
    WebViewWithoutShareController *webview = [[WebViewWithoutShareController alloc] initWithUrl:url];
    [controller.navigationController pushViewController:webview animated:YES];
}

- (id)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
        self.needShare = NO;
        self.canBack = YES;
    }
    
    return self;
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = ![self.webView.title isEmpty] ? self.webView.title : DefaultTitle;
}

@end
