//
//  AgreementViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AgreementViewController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>
@import WebKit;

@interface AgreementViewController () <WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (strong, nonatomic) Requirement *requirement;

@end

@implementation AgreementViewController

- (id)initWithRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        _requirement = requirement;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self loadPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self printCookie];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self printCookie];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"施工合同";
    
    if (![self.requirement.work_type isEqualToString:kWorkTypeDesign]) {
        if ([kRequirementStatusConfiguredAgreementWithoutWorkSite isEqualToString:self.requirement.status]) {
            self.btnConfirm.enabled = YES;
            [self.btnConfirm setTitle:@"确认开工" forState:UIControlStateNormal];
            [self.btnConfirm setBackgroundColor:kFinishedColor];
        } else if ([kRequirementStatusPlanWasChoosedWithoutAgreement isEqualToString:self.requirement.status]) {
            self.btnConfirm.enabled = NO;
            [self.btnConfirm setTitle:@"等待设置开工时间" forState:UIControlStateNormal];
            [self.btnConfirm setBackgroundColor:kUntriggeredColor];
        } else if ([kRequirementStatusFinishedWorkSite isEqualToString:self.requirement.status]) {
            self.btnConfirm.enabled = NO;
            [self.btnConfirm setTitle:@"已完工" forState:UIControlStateNormal];
            [self.btnConfirm setBackgroundColor:kUntriggeredColor];
        } else {
            self.btnConfirm.enabled = NO;
            [self.btnConfirm setTitle:@"已开工" forState:UIControlStateNormal];
            [self.btnConfirm setBackgroundColor:kUntriggeredColor];
        }
    } else {
        self.btnConfirm.hidden = YES;
    }
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
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    // Add the constraints
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    
    NSInteger bottomDistance = ![self.requirement.work_type isEqualToString:kWorkTypeDesign] ? 50 : 0;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-64-[_webView]-%@-|", @(bottomDistance)] options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kApiUrl];
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@%@/%@", components.host, components.port ? @":" : @"", components.port ? components.port : @"", @"tpl/user/agreement.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - user action
- (IBAction)onClickConfirm:(id)sender {
    self.btnConfirm.enabled = NO;
    StartDecorationProcess *request = [[StartDecorationProcess alloc] init];
    request.requirementid = self.requirement._id;
    request.final_planid = self.requirement.final_planid;
    
    [API startDecoration:request success:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^{
        self.btnConfirm.enabled = YES;
    } networkError:^{
        self.btnConfirm.enabled = YES;
    }];
}

- (void)printCookie {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kApiUrl];
    NSString *urlString = [NSString stringWithFormat:@"http://%@%@%@", components.host, components.port ? @":" : @"", components.port ? components.port : @""];
    NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:urlString]];
    
    for (NSHTTPCookie *cookie in cookieStorage) {
        DDLogDebug(@"[===cookie property===] %@", cookie.properties);
    }
}

@end
