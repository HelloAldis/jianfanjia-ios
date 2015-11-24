//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AgreementViewController.h"
@import WebKit;

@interface AgreementViewController ()
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation AgreementViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self loadPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
}

#pragma mark - load page
- (void)loadPage {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    self.webView  = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkWebConfig];
//    self.webView.navigationDelegate = (id<WKNavigationDelegate>)self;
    [self.view addSubview:self.webView];
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kApiUrl];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@", components.host, @"tpl/user/agreement.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}
//
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes, minimum-scale=1.0');document.getElementsByTagName('head')[0].appendChild(meta);";
//    [webView evaluateJavaScript:javascript completionHandler:nil];
//}

@end
