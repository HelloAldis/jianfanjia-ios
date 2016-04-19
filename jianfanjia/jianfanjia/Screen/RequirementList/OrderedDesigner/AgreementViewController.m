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
@property (strong, nonatomic) ProgressWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) UIViewController *popTo;
@property (copy, nonatomic) void(^refreshBlock)(void);

@end

@implementation AgreementViewController

- (id)initWithRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock {
    if (self = [super init]) {
        _requirement = requirement;
        _popTo = popTo;
        _refreshBlock = refreshBlock;
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
    self.title = @"施工合同";
    
    [self initButtons];
}

- (void)initButtons {
    if (![RequirementBusiness isDesignRequirement:self.requirement.work_type]) {
        NSString *status = self.requirement.status;
        [StatusBlock matchReqt:status actions:
         @[[ReqtConfiguredAgreement action:^{
                self.btnConfirm.enabled = YES;
                [self.btnConfirm setNormTitle:@"确认开工"];
                [self.btnConfirm setBgColor:kFinishedColor];
            }],
           [ReqtPlanWasChoosed action:^{
                self.btnConfirm.enabled = NO;
                [self.btnConfirm setNormTitle:@"等待设置开工时间"];
                [self.btnConfirm setBgColor:kUntriggeredColor];
            }],
           [ReqtFinishedWorkSite action:^{
                self.btnConfirm.enabled = NO;
                [self.btnConfirm setNormTitle:@"已完工"];
                [self.btnConfirm setBgColor:kUntriggeredColor];
            }],
           [ElseStatus action:^{
                self.btnConfirm.enabled = NO;
                [self.btnConfirm setNormTitle:@"已开工"];
                [self.btnConfirm setBgColor:kUntriggeredColor];
            }],
           ]];
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
    
    [API startDecoration:request success:^{
        self.requirement.status = kRequirementStatusConfiguredWorkSite;
        [self initButtons];
        
        if (self.refreshBlock) {
            self.refreshBlock();
        }
        
        if (self.popTo) {
            [self.navigationController popToViewController:self.popTo animated:YES];
        }
    } failure:^{
        self.btnConfirm.enabled = YES;
    } networkError:^{
        self.btnConfirm.enabled = YES;
    }];
}

@end
