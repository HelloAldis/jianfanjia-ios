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
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (strong, nonatomic) Designer *designer;
@property (copy, nonatomic) AvtarImageCellUpdateBlock updateBlock;

@end

@implementation AvtarImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self.avatarImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAvatar)]];
}

- (void)initWithDesigner:(Designer *)designer allowsEdit:(BOOL)allowsEdit updateBlock:(AvtarImageCellUpdateBlock)updateBlock {
    self.designer = designer;
    self.updateBlock = updateBlock;
    [self refreshAvatar];
    self.userInteractionEnabled = allowsEdit;
    self.imgArrow.hidden = !allowsEdit;
}

- (void)refreshAvatar {
    [self.avatarImgView setUserImageWithId:self.designer.imageid placeholder:[UIImage imageNamed:@"img_upload_avatar"]];
}

- (void)onTapAvatar {
    @weakify(self);
    [PhotoUtil showUserAvatarSelector:[ViewControllerContainer getCurrentTopController] inView:self withBlock:^(NSArray *imageIds) {
        @strongify(self);
        self.designer.imageid = imageIds[0];
        [self refreshAvatar];
        if (self.updateBlock) {
            self.updateBlock(imageIds[0]);
        }
    }];
}

@end
