//
//  UserInfoViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailLocation;

@end

@implementation UserInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.userImageView setCornerRadius:30];
    [self initUIData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initNav];
    
    UserGetInfo *request = [[UserGetInfo alloc] init];
    @weakify(self);
    [API userGetInfo:request success:^{
        @strongify(self);
        [self initUIData];
    } failure:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"个人信息";
}

- (void)initUIData {
    [self.userImageView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    self.lblUsername.text = [GVUserDefaults standardUserDefaults].username;
    self.lblSex.text = [NameDict nameForSexType:[GVUserDefaults standardUserDefaults].sex];
    self.lblPhone.text = [GVUserDefaults standardUserDefaults].x;
    self.lblLocation.text = [@[[GVUserDefaults standardUserDefaults].province,
                              [GVUserDefaults standardUserDefaults].city,
                              [GVUserDefaults standardUserDefaults].district] join:@" "];
    self.lblDetailLocation.text = [GVUserDefaults standardUserDefaults].address;
}

#pragma mark - user action
- (IBAction)onClickImage:(id)sender {
    [PhotoUtil showUserAvatarSelector];
}

- (IBAction)onClickUsername:(id)sender {

}

- (IBAction)onClickSex:(id)sender {
    
}

- (IBAction)onClickLocation:(id)sender {
}

- (IBAction)onClickDetailLocation:(id)sender {
    
}

@end
