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

@import WebKit;

static NSString *MessageModel = @"jianfanjia";
static NSString *DefaultTitle = @"简繁家，让装修变简单";

@interface WebViewWithActionController () <WKNavigationDelegate, WKScriptMessageHandler>

@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;

@property (strong, nonatomic) ProgressWebView *webView;

@property (strong, nonatomic) NSString *articleImgUrl;
@property (strong, nonatomic) NSString *articleDescription;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *topic;

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
        _url = url;
        _topic = topic;
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
    
    [self initNav];
    [self initUI];
    [self loadPage];
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
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_webView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[_webView]-50-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_webView]|" options:0 metrics:nil views:views]];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kMApiUrl];
    NSString *urlString = [self.url containsString:@"http"] ? self.url : [NSString stringWithFormat:@"http://%@%@%@/%@", components.host, components.port ? @":" : @"", components.port ? components.port : @"", self.url];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.title = ![self.webView.title isEmpty] ? self.webView.title : DefaultTitle;
    
    if (self.needShare) {
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
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.articleImgUrl]]];
    [[ShareManager shared] share:self topic:self.topic image:image ? image : [UIImage imageNamed:@"about_logo"] title:![self.webView.title isEmpty] ? self.webView.title : DefaultTitle description:self.articleDescription ? self.articleDescription : @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。" targetLink:self.webView.URL.absoluteString delegate:self];
}

- (void)onClickBack {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super onClickBack];
    }
}

- (IBAction)onClickActionButton:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
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

