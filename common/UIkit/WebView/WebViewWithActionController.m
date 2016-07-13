//
//  WebViewWithActionController
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "WebViewWithActionController.h"
#import <SafariServices/SafariServices.h>
#import <Foundation/Foundation.h>

@interface WebViewWithActionController ()

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;

@property (assign, nonatomic) BOOL needShare;
@property (assign, nonatomic) BOOL canBack;

@property (strong, nonatomic) NSString *actionTitle;
@property (copy, nonatomic) WebViewActioBlock actionBlock;

@end

@implementation WebViewWithActionController

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url shareTopic:(NSString *)topic actionTitle:(NSString *)actionTitle actionBlock:(WebViewActioBlock)actionBlock {
    [self show:controller withUrl:url shareTopic:topic actionTitle:actionTitle canBack:YES actionBlock:actionBlock];
}

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url shareTopic:(NSString *)topic actionTitle:(NSString *)actionTitle canBack:(BOOL)canBack actionBlock:(WebViewActioBlock)actionBlock {
    WebViewWithActionController *webview = [[WebViewWithActionController alloc] initWithUrl:url shareTopic:topic actionTitle:actionTitle canBack:canBack actionBlock:actionBlock];
    [controller.navigationController pushViewController:webview animated:YES];
}

- (id)initWithUrl:(NSString *)url shareTopic:(NSString *)topic actionTitle:(NSString *)actionTitle canBack:(BOOL)canBack actionBlock:(WebViewActioBlock)actionBlock {
    if (self = [super init]) {
        self.url = url;
        self.topic = topic;
        _needShare = topic.length > 0;
        _canBack = canBack;
        _actionTitle = actionTitle;
        _actionBlock = actionBlock;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.canBack) {
        [self initLeftBackInNav];
    }
    
    if (self.needShare) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share_1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)initUI {
    [self.btnAction setTitle:self.actionTitle forState:UIControlStateNormal];
    [self.btnAction setCornerRadius:self.btnAction.frame.size.height / 2];
}

#pragma mark - load page
- (void)addConstraints {
    ProgressWebView *webV = self.webView;
    NSDictionary *views = NSDictionaryOfVariableBindings(webV);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[webV]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[webV]-50-|" options:0 metrics:nil views:views]];
}

- (IBAction)onClickActionButton:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end

