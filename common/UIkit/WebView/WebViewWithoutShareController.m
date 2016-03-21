//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "WebViewWithoutShareController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>

@import WebKit;

static NSString *DefaultTitle = @"简繁家，让装修变简单";

@interface WebViewWithoutShareController () <WKNavigationDelegate>
@property (strong, nonatomic) ProgressWebView *webView;
@property (strong, nonatomic) NSString *url;

@end

@implementation WebViewWithoutShareController

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url {
    WebViewWithoutShareController *webview = [[WebViewWithoutShareController alloc] initWithUrl:url];
    [controller.navigationController pushViewController:webview animated:YES];
}

- (id)initWithUrl:(NSString *)url {
    if (self = [super init]) {
        _url = url;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self loadPage];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - load page
- (void)loadPage {
    self.webView = [[ProgressWebView alloc] initWithFrame:CGRectZero];
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_webView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kMApiUrl];
    NSString *urlString = [self.url containsString:@"http"] ? self.url : [NSString stringWithFormat:@"http://%@%@%@/%@", components.host, components.port ? @":" : @"", components.port ? components.port : @"", self.url];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = ![self.webView.title isEmpty] ? self.webView.title : DefaultTitle;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (error) {
        [self showError:error];
    }
}

#pragma mark - user action
- (void)onClickBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super onClickBack];
    }
}

#pragma mark - other
- (void)showError:(NSError *)error {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
