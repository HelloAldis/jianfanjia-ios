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

@interface DecStrategyViewController () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;

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
}

#pragma mark - load page
- (void)loadPage {
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
    NSString *source = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // Create the user content controller and add the script to it
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];
    // Create the configuration with the user content controller
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    // Create the web view with the configuration
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    // Add the constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    
    NSInteger bottomDistance = 0;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-64-[_webView]-%@-|", @(bottomDistance)] options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
//    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kApiUrl];
//    NSString *urlString = [NSString stringWithFormat:@"http://%@%@%@/%@", components.host, components.port ? @":" : @"", components.port ? components.port : @"", @"http://devm.jianfanjia.com/view/article/"];
    
    NSString *urlString = @"http://devm.jianfanjia.com/view/article/";
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - user action
- (void)onClickShare {
    [[ShareManager shared] share:self topic:ShareTopicDecStrategy image:[UIImage imageNamed:@"about_logo"] title:@"装修攻略" description:self.webView.title targetLink:self.webView.URL.absoluteString delegate:self];
}

@end
