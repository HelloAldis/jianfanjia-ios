//
//  UserInfoViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UpdateOneLineTextViewController.h"
#import "UpdateMultipleLineTextViewController.h"
#import "SelectSexTypeViewController.h"
#import "ViewControllerContainer.h"

@interface UserInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
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

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"个人信息";
}

- (void)initUIData {
    [self.userImageView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    self.lblUsername.text = [GVUserDefaults standardUserDefaults].username;
    self.lblSex.text = [NameDict nameForSexType:[GVUserDefaults standardUserDefaults].sex];
    
    NSArray *arr = @[[StringUtil convertNil2Empty:[GVUserDefaults standardUserDefaults].province],
                      [StringUtil convertNil2Empty:[GVUserDefaults standardUserDefaults].city],
                      [StringUtil convertNil2Empty:[GVUserDefaults standardUserDefaults].district]];
    self.lblLocation.text = [arr join:@" "];
    self.lblDetailLocation.text = [GVUserDefaults standardUserDefaults].address;
}

#pragma mark - user action
- (IBAction)onClickImage:(id)sender {
    @weakify(self);
    [PhotoUtil showUserAvatarSelector:self inView:sender withBlock:^(NSArray *imageIds) {
        @strongify(self);
        [self updateUserInfo:@"imageid" value:imageIds[0] success:^{
            [GVUserDefaults standardUserDefaults].imageid = imageIds[0];
            [self initUIData];
        }];
    }];
}

- (IBAction)onClickUsername:(id)sender {
    @weakify(self);
    UpdateOneLineTextViewController *controller = [[UpdateOneLineTextViewController alloc] initWithName:@"姓名" value:self.lblUsername.text done:^(id value) {
        @strongify(self);
        [self updateUserInfo:@"username" value:value success:^{
            [GVUserDefaults standardUserDefaults].username = value;
            [self initUIData];
        }];
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickSex:(id)sender {
    @weakify(self);
    SelectSexTypeViewController *controller = [[SelectSexTypeViewController alloc] initWithValueBlock:^(id value) {
        @strongify(self);
        [self updateUserInfo:@"sex" value:value success:^{
            [GVUserDefaults standardUserDefaults].sex = value;
            [self initUIData];
        }];
    } curValue:[GVUserDefaults standardUserDefaults].sex];
    controller.selectSexType = SelectSexTypeUserSex;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickLocation:(id)sender {
    @weakify(self);
    SelectCityViewController *controller = [[SelectCityViewController alloc] initWithAddress:self.lblLocation.text valueBlock:^(id value) {
        @strongify(self);
        [self updateUserInfo:@"location" value:value success:^{
            NSArray *addressArr = [value componentsSeparatedByString:@" "];
            [GVUserDefaults standardUserDefaults].province = addressArr[0];
            [GVUserDefaults standardUserDefaults].city = addressArr[1];
            [GVUserDefaults standardUserDefaults].district = addressArr[2];
            [self initUIData];
        }];
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onClickAccountBind:(id)sender {
    [ViewControllerContainer showAccountBind];
}

- (IBAction)onClickDetailLocation:(id)sender {
    @weakify(self);
    UpdateMultipleLineTextViewController *controller = [[UpdateMultipleLineTextViewController alloc] initWithName:@"详细地址" value:self.lblDetailLocation.text max:120 done:^(id value) {
        @strongify(self);
        [self updateUserInfo:@"address" value:value success:^{
            [GVUserDefaults standardUserDefaults].address = value;
            [self initUIData];
        }];
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)updateUserInfo:(NSString *)attrName value:(NSString *)attrValue success:(void(^)(void))success {
    UpdateUserInfo *request = [[UpdateUserInfo alloc] init];
    if ([attrName isEqualToString:@"location"]) {
        NSArray *addressArr = [attrValue componentsSeparatedByString:@" "];
        request.province = addressArr[0];
        request.city = addressArr[1];
        request.district = addressArr[2];
    } else {
        [request setValue:attrValue forKey:attrName];
    }
    
    [API updateUserInfo:request success:^{
        if (success) {
            success();
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
