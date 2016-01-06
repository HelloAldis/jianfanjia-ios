//
//  UserInfoViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AccountBindViewController.h"
#import "ViewControllerContainer.h"

@interface AccountBindViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UILabel *lblWechat;

@end

@implementation AccountBindViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initUIData];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"帐号绑定";
}

- (void)initUIData {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lblPhone.text = [GVUserDefaults standardUserDefaults].phone ? [GVUserDefaults standardUserDefaults].phone : @"未绑定";
    self.lblWechat.text = [GVUserDefaults standardUserDefaults].wechat_unionid ? @"已绑定" : @"未绑定";
}

#pragma mark - user action
- (IBAction)onClickPhone:(id)sender {
//    if ([GVUserDefaults standardUserDefaults].phone) {
//        return;
//    }
    
    [ViewControllerContainer showBindPhone:BindPhoneEventDefault];
}

- (IBAction)onClickWechat:(id)sender {
    if ([GVUserDefaults standardUserDefaults].wechat_unionid) {
        return;
    }
    
    
}

@end
