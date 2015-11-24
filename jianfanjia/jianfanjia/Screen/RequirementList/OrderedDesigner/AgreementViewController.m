//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AgreementViewController.h"
#import <SafariServices/SafariServices.h>
@import WebKit;

@interface AgreementViewController () <WKNavigationDelegate>
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
    self.title = @"合同";
}

#pragma mark - load page
- (void)loadPage {
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
    [self.view addSubview:_webView];
    // Add the constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kApiUrl];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@", components.host, @"tpl/user/agreement.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

@end
