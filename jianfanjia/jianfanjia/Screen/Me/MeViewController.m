//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"

@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnFavoriateDesigner;
@property (weak, nonatomic) IBOutlet UIButton *btnSetting;

@property (assign, nonatomic) BOOL isTabbarhide;

@end


@implementation MeViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNav];
    [self initUIData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isTabbarhide) {
        [self showTabbar];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.isTabbarhide && animated) {
        [self hideTabbar];
    }
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUIData {
    self.lblUsername.text = [GVUserDefaults standardUserDefaults].username;
    self.lblPhone.text = [NSString stringWithFormat:@"帐号：%@", [GVUserDefaults standardUserDefaults].x];
    [self.userImageView setImageWithId:[GVUserDefaults standardUserDefaults].imageid placeholderImage:[UIImage imageNamed:@"image_place_holder_3"]];
}

#pragma mark - user action
- (IBAction)onClickNotification:(id)sender {
    
}

- (IBAction)onClickFavoriateDesigner:(id)sender {
    
}

- (IBAction)onClickSetting:(id)sender {
    SettingViewController *v = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark - Util
- (void)hideTabbar {
    if (!self.isTabbarhide) {
        self.isTabbarhide = YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, 50);
        }];
    }
}

- (void)showTabbar {
    if (self.isTabbarhide) {
        self.isTabbarhide = NO;
        [UIView animateWithDuration:0.6 animations:^{
            self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, -50);
        }];
    }
}

@end
