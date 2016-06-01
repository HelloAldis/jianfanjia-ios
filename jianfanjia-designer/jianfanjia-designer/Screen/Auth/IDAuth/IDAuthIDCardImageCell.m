//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "IDAuthIDCardImageCell.h"
#import "ViewControllerContainer.h"

CGFloat kIDAuthIDCardImageCellHeight;

@interface IDAuthIDCardImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *idCardLeftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *leftDelImgView;
@property (weak, nonatomic) IBOutlet UIImageView *idCardRightImgView;
@property (weak, nonatomic) IBOutlet UIImageView *rightDelImgView;

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) Team *team;
@property (copy, nonatomic) CardImageCellActionBlock actionBlock;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation IDAuthIDCardImageCell

+ (void)initialize {
    if ([self class] == [IDAuthIDCardImageCell class]) {
        CGFloat aspect =  545.0 / ((kScreenWidth  - 44) / 2.0);
        kIDAuthIDCardImageCellHeight = round(342.0 / aspect) + 32.5;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.idCardLeftImgView setCornerRadius:5];
    [self.idCardRightImgView setCornerRadius:5];
    [self.idCardLeftImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftImgView)]];
    [self.leftDelImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftDelImgView)]];
    [self.idCardRightImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRightImgView)]];
    [self.rightDelImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRightDelImgView)]];
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
    self.isEdit = isEdit;
    self.actionBlock = actionBlock;
    [self initUI];
}

- (void)initUI {
    id obj = self.designer ? self.designer : self.team;

    [self.idCardLeftImgView setImageWithId:[obj uid_image1] withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_id_card_front"]];
    [self.idCardRightImgView setImageWithId:[obj uid_image2] withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_id_card_back"]];
    
    [self.idCardLeftImgView setBorder:[obj uid_image1].length > 0 ? 0.5 : 0.0 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.idCardRightImgView setBorder:[obj uid_image2].length > 0 ? 0.5 : 0.0 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];

    if (self.isEdit) {
        self.leftDelImgView.hidden = [obj uid_image1].length > 0 ? NO : YES;
        self.rightDelImgView.hidden = [obj uid_image2].length > 0 ? NO : YES;
    } else {
        self.leftDelImgView.hidden = YES;
        self.rightDelImgView.hidden = YES;
    }
}

- (void)onTapLeftImgView {
    id obj = self.designer ? self.designer : self.team;
    if ([obj uid_image1].length > 0) {
        [ViewControllerContainer showOnlineImages:@[[obj uid_image1]] index:0];
    } else {
        if (self.isEdit) {
            [PhotoUtil showUploadProductImageSelector:[ViewControllerContainer getCurrentTopController] inView:self max:1 withBlock:^(NSArray *imageIds) {
                [obj setUid_image1:imageIds[0]];
                [self initUI];
                if (self.actionBlock) {
                    self.actionBlock(CardImageActionAdd, CardImageTypeFront);
                }
            }];
        }
    }
}

- (void)onTapLeftDelImgView {
    id obj = self.designer ? self.designer : self.team;
    [obj setUid_image1:@""];
    [self initUI];
    if (self.actionBlock) {
        self.actionBlock(CardImageActionDelete, CardImageTypeFront);
    }
}

- (void)onTapRightImgView {
    id obj = self.designer ? self.designer : self.team;
    if ([obj uid_image2].length > 0) {
        [ViewControllerContainer showOnlineImages:@[[obj uid_image2]] index:0];
    } else {
        if (self.isEdit) {
            [PhotoUtil showUploadProductImageSelector:[ViewControllerContainer getCurrentTopController] inView:self max:1 withBlock:^(NSArray *imageIds) {
                [obj setUid_image2:imageIds[0]];
                [self initUI];
                if (self.actionBlock) {
                    self.actionBlock(CardImageActionAdd, CardImageTypeBack);
                }
            }];
        }
    }
}

- (void)onTapRightDelImgView {
    id obj = self.designer ? self.designer : self.team;
    [obj setUid_image2:@""];
    [self initUI];
    if (self.actionBlock) {
        self.actionBlock(CardImageActionDelete, CardImageTypeBack);
    }
}

@end
