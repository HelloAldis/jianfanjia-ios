//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "InfoAuthDiplomaImageCell.h"
#import "ViewControllerContainer.h"

CGFloat kInfoAuthDiplomaImageCellHeight;

static CGFloat imageHeight;

@interface InfoAuthDiplomaImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConst;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgView;
@property (strong, nonatomic) ProductAuthImageActionView *actionView;

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) NSString *diploma;
@property (nonatomic, assign) BOOL isEdit;

@property (copy, nonatomic) ProductAuthImageActionViewTapBlock actionBlock;

@end

@implementation InfoAuthDiplomaImageCell

+ (void)initialize {
    if ([self class] == [InfoAuthDiplomaImageCell class]) {
        CGFloat aspect =  373.0 / (kScreenWidth  - 44);
        imageHeight = ceil(280.0 / aspect);
        kInfoAuthDiplomaImageCellHeight = imageHeight + 30;
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.imgViewHeightConst.constant != imageHeight) {
        self.imgViewHeightConst.constant = imageHeight;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView setCornerRadius:5];
    [self.imgView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImgView)]];
    [self.deleteImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDeleteImg)]];
}

- (void)initWithDesigner:(Designer *)designer diploma:(NSString *)diploma isEdit:(BOOL)isEdit actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    self.designer = designer;
    self.diploma = diploma;
    self.isEdit = isEdit;
    self.actionBlock = actionBlock;
    [self.imgView setImageWithId:diploma withWidth:kScreenWidth];
    self.coverImgView.hidden = YES;
    self.deleteImgView.hidden = !isEdit;
}

- (void)onTapImgView {
    [ViewControllerContainer showOnlineImages:@[self.diploma] fromImageView:self.imgView index:0];
}

- (void)onTapDeleteImg {
    if (self.actionBlock) {
        self.actionBlock(ProductAuthImageActionDelete);
    }
}

@end
