//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthPlanImageCell.h"
#import "ViewControllerContainer.h"

CGFloat kProductAuthPlanImageCellHeight;

static CGFloat imageHeight;

@interface ProductAuthPlanImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConst;
@property (strong, nonatomic) ProductAuthImageActionView *actionView;

@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) ProductImage *image;

@end

@implementation ProductAuthPlanImageCell

+ (void)initialize {
    if ([self class] == [ProductAuthPlanImageCell class]) {
        CGFloat aspect =  373.0 / (kScreenWidth  - 44);
        imageHeight = ceil(280.0 / aspect);
        kProductAuthPlanImageCellHeight = imageHeight + 30;
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
}

- (void)initWithProduct:(Product *)product image:(ProductImage *)image actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    self.product = product;
    self.image = image;
    [self.imgView setImageWithId:image.imageid withWidth:kScreenWidth];
    [self initActionView:actionBlock];
}

- (void)initActionView:(ProductAuthImageActionViewTapBlock)actionBlock {
    if (!self.actionView) {
        self.actionView = [[ProductAuthImageActionView alloc] initWithFrame:CGRectMake(kScreenWidth - kProductAuthImageActionViewWidth - 30, self.imgViewHeightConst.constant - kProductAuthImageActionViewHeight + 5, kProductAuthImageActionViewWidth, kProductAuthImageActionViewHeight)];
        self.actionView.setCoverImgView.hidden = YES;
        [self.contentView addSubview:self.actionView];
    }
    
    self.actionView.tapBlock = actionBlock;
}

- (void)onTapImgView {
    NSArray *imageArray = [self.product.plan_images map:^(NSDictionary *dict) {
        return [dict objectForKey:@"imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imageArray index:[imageArray indexOfObject:self.image.imageid]];
}

@end
