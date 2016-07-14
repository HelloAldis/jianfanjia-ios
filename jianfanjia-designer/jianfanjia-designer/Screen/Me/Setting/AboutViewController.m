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
    self.title = @"关于我们";
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

- (IBAction)onClickEvaluateUsInAppStore:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jian-fan-jia-zhuan-ye-ban/id1078884606?l=cn&mt=8"]];
}

@end
