//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthPlanImageCell.h"

@interface ProductAuthPlanImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (strong, nonatomic) ProductAuthImageActionView *actionView;

@end

@implementation ProductAuthPlanImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView setCornerRadius:5];
    [self.imgView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImgView)]];
}

- (void)initWithProduct:(Product *)product image:(ProductImage *)image actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    [self.imgView setImageWithId:image.imageid withWidth:kScreenWidth];
    self.coverImgView.hidden = ![product.cover_imageid isEqualToString:image.imageid];
    [self initActionView:actionBlock];
}

- (void)initActionView:(ProductAuthImageActionViewTapBlock)actionBlock {
    if (!self.actionView) {
        self.actionView = [[ProductAuthImageActionView alloc] initWithFrame:CGRectMake(kScreenWidth - kProductAuthImageActionViewWidth - 30, kProductAuthPlanImageCellHeight - kProductAuthImageActionViewHeight - 30, kProductAuthImageActionViewWidth, kProductAuthImageActionViewHeight)];
        [self.contentView addSubview:self.actionView];
    }
    
    self.actionView.tapBlock = actionBlock;
}

- (void)onTapImgView {

}

@end
