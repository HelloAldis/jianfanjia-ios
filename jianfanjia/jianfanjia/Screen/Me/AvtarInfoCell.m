//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AvtarInfoCell.h"
#import "ViewControllerContainer.h"
#import "UserInfoViewController.h"

CGFloat kAvtarInfoCellHeight;

@interface AvtarInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIView *avtarView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end

@implementation AvtarInfoCell

+ (void)initialize {
    if ([self class] == [AvtarInfoCell class]) {
        CGFloat aspect =  621.0 / kScreenWidth;
        kAvtarInfoCellHeight = round(440 / aspect);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self.avatarImgView setBorder:1 andColor:[UIColor whiteColor].CGColor];
    [self.avatarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initUI {
    if ([[LoginEngine shared] isLogin]) {
        self.lblUserName.text = [GVUserDefaults standardUserDefaults].username;
        self.lblUserName.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        self.lblPhone.font = [UIFont systemFontOfSize:14];
        if ([GVUserDefaults standardUserDefaults].phone) {
            self.lblPhone.text = [NSString stringWithFormat:@"手机号：%@", [GVUserDefaults standardUserDefaults].phone];
            self.lblPhone.hidden = NO;
        } else {
            self.lblPhone.hidden = YES;
        }
    } else {
        self.lblUserName.text = @"登录/注册";
        self.lblUserName.font = [UIFont systemFontOfSize:17];
        self.lblPhone.text = @"登录简繁家，发现更多精彩！";
        self.lblPhone.font = [UIFont systemFontOfSize:16];
    }
    
    [self.avatarImgView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
}

- (void)onTap {
    if ([[LoginEngine shared] isLogin]) {
        UserInfoViewController *v = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
        [[ViewControllerContainer navigation] pushViewController:v animated:YES];
    } else {
        [[LoginEngine shared] showLogin:^(BOOL logined) {
            if (logined) {
                [self initUI];
            }
        }];
    }
}

@end
