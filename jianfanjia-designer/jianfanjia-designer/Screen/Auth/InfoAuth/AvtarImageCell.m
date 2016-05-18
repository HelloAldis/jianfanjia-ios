//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AvtarImageCell.h"

@interface AvtarImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;

@end

@implementation AvtarImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self.avatarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar)]];
}

- (void)initUI {
    [self.avatarImgView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
}

- (void)onTapAvatar {
    
}

@end
