//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecStrategyViewController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>

@import WebKit;

static NSString *MessageModel = @"DecStrategy";

@interface DecStrategyViewController () <WKNavigationDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) ProgressWebView *webView;

@end

@implementation DecStrategyViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self loadPage];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"装修攻略";
    [self initLeftBackInNav];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share_1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - load page
- (void)loadPage {
    NSString *source = [NSString stringWithFormat:@"function sendMessageToNative(msg) {window.webkit.messageHandlers.%@.postMessage(msg);}", MessageModel];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    // Create the user content controller and add the script to it
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];
    [userContentController addScriptMessageHandler:self name:MessageModel];
    // Create the configuration with the user content controller
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    // Create the web view with the configuration
    self.webView = [[ProgressWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    // Add the constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_webView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kMApiUrl];
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@%@/%@", components.host, components.port ? @":" : @"", components.port ? components.port : @"", @"/view/article/"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:MessageModel]) {
        NSDictionary *dic = message.body;
        NSString *msgtype = [dic objectForKey:@"msgtype"];
        NSString *description = [dic objectForKey:@"description"];
        NSString *imgUrl = [dic objectForKey:@"imgurl"];
        if ([@"share" isEqualToString:msgtype]) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
            [[ShareManager shared] share:self topic:ShareTopicDecStrategy image:image ? image : [UIImage imageNamed:@"about_logo"] title:self.webView.title ? self.webView.title : @"装修攻略" description:description ? description : @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。" targetLink:self.webView.URL.absoluteString delegate:self];
        }
    }
}

#pragma mark - user action
- (void)onClickShare {
    [self.webView evaluateJavaScript:@"var nodelist = document.getElementsByTagName('meta'); var description; for(var i = 0; i < nodelist.length; i++) {var node = nodelist[i]; if(node.getAttribute('name') == 'description'){description = node.getAttribute('content');}}\
        var imgurl = document.getElementsByTagName('img')[0].src;\
     sendMessageToNative({'msgtype':'share', 'description':description, 'imgurl':imgurl});"
                   completionHandler:^(id _Nullable value, NSError * _Nullable error) {
    }];
}

- (void)onClickBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super onClickBack];
    }
}

@end
