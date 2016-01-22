//
//  SettingViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "ViewControllerContainer.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblCache;

@end

@implementation SettingViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self updateCache];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"设置";
}

- (void)updateCache {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    self.lblCache.text = [@((cache.memoryCache.totalCost + cache.diskCache.totalCost) /8 ) humSizeString];
}

#pragma mark - user action
- (IBAction)switchChange:(id)sender {
    
}

- (IBAction)btnShare:(id)sender {
//    NSString *description = @"我在使用 #简繁家# 的App，业内一线设计师为您量身打造房间，比传统装修便宜20%，让你一手轻松掌控装修全过程。";
//    [[ShareManager shared] share:self topic:ShareTopicApp image:[UIImage imageNamed:@"about_logo"] title:@"简繁家，让装修变简单" description:description targetLink:@"http://www.jianfanjia.com/zt/mobile/index.html" delegate:self];
}

- (IBAction)btnClearCache:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    @weakify(self)
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        [self updateCache];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnFeedback:(id)sender {
    FeedbackViewController *v = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)btnHelp:(id)sender {
    
}

- (IBAction)btnAbout:(id)sender {
    AboutViewController *v = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
}

- (IBAction)onClickLogout:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ViewControllerContainer logout];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
