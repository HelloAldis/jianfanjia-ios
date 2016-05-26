//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "IDAuthIDCardImageCell.h"
#import "ViewControllerContainer.h"

@interface IDAuthIDCardImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *idCardLeftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftDelImgView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardRightImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightDelImgView;

@property (strong, nonatomic) Designer *designer;
@property (copy, nonatomic) CardImageCellActionBlock actionBlock;

@end

@implementation IDAuthIDCardImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.idCardLeftImgView setCornerRadius:5];
    [self.idCardRightImgView setCornerRadius:5];
    [self.idCardLeftImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftImgView)]];
    [self.leftDelImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftDelImgView)]];
    [self.idCardRightImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRightImgView)]];
    [self.rightDelImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRightDelImgView)]];
}

- (void)initWithDesigner:(Designer *)designer actionBlock:(CardImageCellActionBlock)actionBlock {
    self.designer = designer;
    self.actionBlock = actionBlock;
    [self initUI];
}

- (void)initUI {
    [self.idCardLeftImgView setImageWithId:self.designer.uid_image1 withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_id_card_front"]];
    [self.idCardRightImgView setImageWithId:self.designer.uid_image2 withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_id_card_back"]];
    self.leftDelImgView.hidden = self.designer.uid_image1.length > 0 ? NO : YES;
    self.rightDelImgView.hidden = self.designer.uid_image2.length > 0 ? NO : YES;
    self.idCardLeftImgView.contentMode = self.designer.uid_image1.length > 0 ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleToFill;
    self.idCardRightImgView.contentMode = self.designer.uid_image2.length > 0 ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleToFill;
    [self.idCardLeftImgView setBorder:self.designer.uid_image1.length > 0 ? 0.5 : 0.0 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.idCardRightImgView setBorder:self.designer.uid_image2.length > 0 ? 0.5 : 0.0 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
}

- (void)onTapLeftImgView {
    if (self.designer.uid_image1.length > 0) {
        [ViewControllerContainer showOnlineImages:@[self.designer.uid_image1] index:0];
    } else {
        [PhotoUtil showUploadProductImageSelector:[ViewControllerContainer getCurrentTapController] inView:self max:1 withBlock:^(NSArray *imageIds) {
            self.designer.uid_image1 = imageIds[0];
            [self initUI];
            if (self.actionBlock) {
                self.actionBlock(CardImageActionAdd, CardImageTypeFront);
            }
        }];
    }
}

- (void)onTapLeftDelImgView {
    self.designer.uid_image1 = @"";
    [self initUI];
    if (self.actionBlock) {
        self.actionBlock(CardImageActionDelete, CardImageTypeFront);
    }
}

- (void)onTapRightImgView {
    if (self.designer.uid_image2.length > 0) {
        [ViewControllerContainer showOnlineImages:@[self.designer.uid_image2] index:0];
    } else {
        [PhotoUtil showUploadProductImageSelector:[ViewControllerContainer getCurrentTapController] inView:self max:1 withBlock:^(NSArray *imageIds) {
            self.designer.uid_image2 = imageIds[0];
            [self initUI];
            if (self.actionBlock) {
                self.actionBlock(CardImageActionAdd, CardImageTypeBack);
            }
        }];
    }
}

- (void)onTapRightDelImgView {
    self.designer.uid_image2 = @"";
    [self initUI];
    if (self.actionBlock) {
        self.actionBlock(CardImageActionDelete, CardImageTypeBack);
    }
}

@end
