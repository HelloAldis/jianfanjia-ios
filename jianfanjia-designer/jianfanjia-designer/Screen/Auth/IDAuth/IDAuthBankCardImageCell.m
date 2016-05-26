//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "IDAuthBankCardImageCell.h"
#import "ViewControllerContainer.h"

@interface IDAuthBankCardImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *idCardLeftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftDelImgView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardRightImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightDelImgView;

@property (strong, nonatomic) Designer *designer;
@property (copy, nonatomic) CardImageCellActionBlock actionBlock;

@end

@implementation IDAuthBankCardImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.idCardLeftImgView setCornerRadius:5];
    [self.idCardRightImgView setCornerRadius:5];
    [self.idCardLeftImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftImgView)]];
    [self.leftDelImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftDelImgView)]];
}

- (void)initWithDesigner:(Designer *)designer actionBlock:(CardImageCellActionBlock)actionBlock {
    self.designer = designer;
    self.actionBlock = actionBlock;
    [self initUI];
}

- (void)initUI {
    [self.idCardLeftImgView setImageWithId:self.designer.bank_card_image1 withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_bank_card_front"]];
    self.leftDelImgView.hidden = self.designer.bank_card_image1.length > 0 ? NO : YES;
    self.idCardLeftImgView.contentMode = self.designer.bank_card_image1.length > 0 ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleToFill;
    [self.idCardLeftImgView setBorder:self.designer.bank_card_image1.length > 0 ? 0.5 : 0.0 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
}

- (void)onTapLeftImgView {
    if (self.designer.bank_card_image1.length > 0) {
        [ViewControllerContainer showOnlineImages:@[self.designer.bank_card_image1] index:0];
    } else {
        [PhotoUtil showUploadProductImageSelector:[ViewControllerContainer getCurrentTapController] inView:self max:1 withBlock:^(NSArray *imageIds) {
            self.designer.bank_card_image1 = imageIds[0];
            [self initUI];
            if (self.actionBlock) {
                self.actionBlock(CardImageActionAdd, CardImageTypeFront);
            }
        }];
    }
}

- (void)onTapLeftDelImgView {
    self.designer.bank_card_image1 = @"";
    [self initUI];
    if (self.actionBlock) {
        self.actionBlock(CardImageActionDelete, CardImageTypeFront);
    }
}

@end
