//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AvtarImageCell.h"
#import "ViewControllerContainer.h"

@interface AvtarImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@end

@implementation AvtarImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self.avatarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar)]];
}

- (void)initUI {
    [self.avatarImgView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid placeholder:[UIImage imageNamed:@"img_upload_avatar"]];
}

- (void)onTapAvatar {
    @weakify(self);
    [PhotoUtil showUserAvatarSelector:[ViewControllerContainer getCurrentTapController] inView:self withBlock:^(NSArray *imageIds) {
        @strongify(self);
        [self initUI];
        [GVUserDefaults standardUserDefaults].imageid = imageIds[0];
    }];
}

@end
