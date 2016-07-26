//
//  BaseWebViewController.m
//  jianfanjia
//
//  Created by Karos on 16/7/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseWebViewController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>
#import "WebViewDelegateHandler.h"

@import WebKit;

static NSString *MessageModel = @"jianfanjia";

@interface BaseWebViewController () <WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation BaseWebViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self loadPage];
}

#pragma mark - UI
- (void)initNav {
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.canBack) {
        [self initLeftBackInNav];
    }
    
    if (self.needShare) {
#ifdef ShareManager_h
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share_1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
        self.navigationItem.rightBarButtonItem.enabled = NO;
#endif
    }
}

#pragma mark - load page
- (void)loadPage {
    NSString *source = [NSString stringWithFormat:@"function sendMessageToNative(msg) {window.webkit.messageHandlers.%@.postMessage(msg);}", MessageModel];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];
    [userContentController addScriptMessageHandler:self name:MessageModel];
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    
    self.webView = [[ProgressWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    [self addConstraints];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kMApiUrl];
    NSString *urlString = [self.url containsString:@"http"] ? self.url : [NSString stringWithFormat:@"http://%@%@%@/%@", components.host, components.port ? @":" : @"", components.port ? components.port : @"", self.url];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)addConstraints {
    ProgressWebView *webV = self.webView;
    NSDictionary *views = NSDictionaryOfVariableBindings(webV);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[webV]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webV]|" options:0 metrics:nil views:views]];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [WebViewDelegateHandler shared].controller = self;
    [WebViewDelegateHandler webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = ![self.webView.title isEmpty] ? self.webView.title : DefaultTitle;
    [self.webView evaluateJavaScript:@"\
     var nodelist = document.getElementsByTagName('meta');\
     var description;\
     for(var i = 0; i < nodelist.length; i++) {\
     var node = nodelist[i];\
     if (node.getAttribute('name') == 'description') {\
     description = node.getAttribute('content');\
     }\
     }\
     var imglist = document.getElementsByTagName('img');\
     var imgurl;\
     if (imglist.length > 0) {\
     imgurl = imglist[0].src;\
     }\
     sendMessageToNative({'msgtype':'share', 'description':description, 'imgurl':imgurl});\
     "
                   completionHandler:^(id _Nullable value, NSError * _Nullable error) {
                       if (error) {
                           [self showError:error];
                       }
                   }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [self showError:error];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:MessageModel]) {
        NSDictionary *dic = message.body;
        NSString *msgtype = [dic objectForKey:@"msgtype"];
        NSString *description = [dic objectForKey:@"description"];
        NSString *imgUrl = [dic objectForKey:@"imgurl"];
        if ([@"share" isEqualToString:msgtype]) {
            self.articleImgUrl = imgUrl;
            self.articleDescription = description;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
}

#pragma mark - user action
- (void)onClickShare {
#ifdef ShareManager_h
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.articleImgUrl]]];
    [[ShareManager shared] share:self topic:self.topic image:image ? image : [UIImage imageNamed:@"about_logo"] title:![self.webView.title isEmpty] ? self.webView.title : DefaultTitle description:self.articleDescription ? self.articleDescription : @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。" targetLink:self.webView.URL.absoluteString delegate:self];
#endif
}


- (void)onClickBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super onClickBack];
    }
}

#pragma mark - other
- (void)showError:(NSError *)error {
    [AlertUtil show:self title:@"错误" doneBlock:^{
        
    }];
}

@end
