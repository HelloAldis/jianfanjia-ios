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
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"个人信息";
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
