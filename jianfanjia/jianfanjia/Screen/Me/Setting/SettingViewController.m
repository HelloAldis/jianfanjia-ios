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

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"设置";
}

- (void)updateCache {
    self.lblCache.text = [@([[SDImageCache sharedImageCache] getSize] / 8) humSizeString];
}

#pragma mark - user action
- (IBAction)switchChange:(id)sender {
    
}

- (IBAction)btnShare:(id)sender {
    
}

- (IBAction)btnClearCache:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定清空缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    @weakify(self)
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [[SDImageCache sharedImageCache] clearDisk];
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
        [GVUserDefaults standardUserDefaults].isLogin = NO;
        [GVUserDefaults standardUserDefaults].userid = nil;
        [GVUserDefaults standardUserDefaults].imageid = nil;
        [GVUserDefaults standardUserDefaults].usertype = nil;
        [ViewControllerContainer logout];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
