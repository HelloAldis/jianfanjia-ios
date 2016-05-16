//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import <SafariServices/SafariServices.h>

@import WebKit;

static NSString *CustomerServiceLink = @"http://chat16.live800.com/live800/chatClient/chatbox.jsp?companyID=611886&configID=139921&jid=3699665419";
static CustomerServiceViewController *controller;
static BOOL isReload;

@interface CustomerServiceViewController () <WKNavigationDelegate>
@property (strong, nonatomic) ProgressWebView *webView;
@property (strong, nonatomic) NSURLRequest *request;

@end

@implementation CustomerServiceViewController

+ (id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[CustomerServiceViewController alloc] init];
    });
    
    return controller;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:CustomerServiceLink]];
    
    [self loadPage];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"在线客服";
}

#pragma mark - load page
- (void)loadPage {
    // Javascript that disables pinch-to-zoom by inserting the HTML viewport meta tag into <head>
    NSString *source = @"var meta = document.createElement('meta'); \
    meta.name = 'viewport'; \
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
    var head = document.getElementsByTagName('head')[0];\
    head.appendChild(meta);";
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    // Create the user content controller and add the script to it
    WKUserContentController *userContentController = [WKUserContentController new];
    [userContentController addUserScript:script];
    // Create the configuration with the user content controller
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    // Create the web view with the configuration
    self.webView = [[ProgressWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    // Add the constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    [_webView loadRequest:_request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (!isReload) {
        isReload = YES;
//        [_webView evaluateJavaScript:@"window.location.reload(true)" completionHandler:nil];
        [_webView reload];
    }
}

@end
