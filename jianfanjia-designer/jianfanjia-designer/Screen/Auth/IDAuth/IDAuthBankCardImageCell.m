//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "IDAuthBankCardImageCell.h"
#import "ViewControllerContainer.h"

CGFloat kIDAuthBankCardImageCellHeight;

@interface IDAuthBankCardImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *idCardLeftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftDelImgView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardRightImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightDelImgView;

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) Team *team;
@property (copy, nonatomic) CardImageCellActionBlock actionBlock;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation IDAuthBankCardImageCell

+ (void)initialize {
    if ([self class] == [IDAuthBankCardImageCell class]) {
        CGFloat aspect =  545.0 / ((kScreenWidth  - 42) / 2.0);
        kIDAuthBankCardImageCellHeight = round(342.0 / aspect) + 32;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.idCardLeftImgView setCornerRadius:5];
    [self.idCardRightImgView setCornerRadius:5];
    [self.idCardLeftImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftImgView)]];
    [self.leftDelImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftDelImgView)]];
}

- (void)initWithDesigner:(Designer *)designer isEdit:(BOOL)isEdit actionBlock:(CardImageCellActionBlock)actionBlock {
    self.designer = designer;
    self.team = nil;
    self.isEdit = isEdit;
    self.actionBlock = actionBlock;
    [self initUI];
}

- (void)initWithTeam:(Team *)team isEdit:(BOOL)isEdit actionBlock:(CardImageCellActionBlock)actionBlock {
    self.designer = nil;
    self.team = team;
    self.isEdit = isEdit;;
    self.actionBlock = actionBlock;
    [self initUI];
}

- (void)initUI {
    id obj = self.designer ? self.designer : self.team;

    [self.idCardLeftImgView setImageWithId:[obj bank_card_image1] withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_bank_card_front"]];
    self.leftDelImgView.hidden = [obj bank_card_image1].length > 0 ? NO : YES;
    [self.idCardLeftImgView setBorder:[obj bank_card_image1].length > 0 ? 0.5 : 0.0 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    
    if (self.isEdit) {
        self.leftDelImgView.hidden = [obj bank_card_image1].length > 0 ? NO : YES;
    } else {
        self.leftDelImgView.hidden = YES;
    }
}

- (void)onTapLeftImgView {
    [[ViewControllerContainer getCurrentTopController].view endEditing:YES];
    id obj = self.designer ? self.designer : self.team;
    if ([obj bank_card_image1].length > 0) {
        [ViewControllerContainer showOnlineImages:@[[obj bank_card_image1]] index:0];
    } else {
        if (self.isEdit) {
            [PhotoUtil showUserAvatarSelector:[ViewControllerContainer getCurrentTopController] inView:self withBlock:^(NSArray *imageIds) {
                [obj setBank_card_image1:imageIds[0]];
                [self initUI];
                if (self.actionBlock) {
                    self.actionBlock(CardImageActionAdd, CardImageTypeFront);
                }
            }];
        }
    }
}

- (void)onTapLeftDelImgView {
    [[ViewControllerContainer getCurrentTopController].view endEditing:YES];
    id obj = self.designer ? self.designer : self.team;
    [obj setBank_card_image1:@""];
    [self initUI];
    if (self.actionBlock) {
        self.actionBlock(CardImageActionDelete, CardImageTypeFront);
    }
}

@end
