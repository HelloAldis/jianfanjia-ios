//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductAuthCell.h"
#import "ViewControllerContainer.h"

@interface ProductAuthCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (strong, nonatomic) Product *product;

@end

@implementation ProductAuthCell

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    [self.productImageView setImageWithId:product.cover_imageid withWidth:kScreenWidth];
    self.lblCell.text = product.cell;
    self.lblDetail.text = [NSString stringWithFormat:@"%@m², %@, %@, %@风格",
                           product.house_area,
                           [NameDict nameForDecType:product.dec_type],
                           [NameDict nameForHouseType:product.house_type],
                           [NameDict nameForDecStyle:product.dec_style]];
}

- (void)onTap {
//    [ViewControllerContainer showProduct:self.product._id];
}

@end
