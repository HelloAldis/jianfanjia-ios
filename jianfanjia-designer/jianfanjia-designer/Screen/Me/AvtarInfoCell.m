//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AvtarInfoCell.h"
#import "ViewControllerContainer.h"

@interface AvtarInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end

@implementation AvtarInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initUI {
    self.lblUserName.text = [GVUserDefaults standardUserDefaults].username;
    if ([GVUserDefaults standardUserDefaults].phone) {
        self.lblPhone.text = [NSString stringWithFormat:@"帐号：%@", [GVUserDefaults standardUserDefaults].phone];
    } else {
        self.lblPhone.hidden = YES;
    }
    
    [self.avatarImgView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    [[NotificationDataManager shared] refreshUnreadCount];
}

- (void)onTap {
    [ViewControllerContainer showInfoAuth];
}

@end
