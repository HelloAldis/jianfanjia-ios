//
//  AboutViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AboutViewController.h"
#import "WebViewWithoutShareController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end

@implementation AboutViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.lblVersion.text = [NSString stringWithFormat:@"版本号：%@", version];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"更多";
}

#pragma mark - action
- (IBAction)onClickOfficialWechat:(id)sender {
    [UIPasteboard generalPasteboard].string = @"jianfanjia";
    [AlertUtil show:self title:@"微信号已复制成功，请在微信搜索并关注简繁家。" doneBlock:^{
        
    }];
}

- (IBAction)onClickOfficialWeibo:(id)sender {
    [WebViewWithoutShareController show:self withUrl:@"http://weibo.com/u/5691975473?topnav=1&wvr=6&topsug=1&is_all=1"];
}

- (IBAction)onClickShareToFriend:(id)sender {
    NSString *description = @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。";
    [[ShareManager shared] share:self topic:ShareTopicApp image:[UIImage imageNamed:@"about_logo"] title:@"简繁家，让装修变简单" description:description targetLink:@"http://www.jianfanjia.com/zt/mobile/index.html" delegate:self];
}

- (IBAction)onClickEvaluateUsInAppStore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jian-fan-jia/id1065725149?l=cn&mt=8"]];
}

@end
