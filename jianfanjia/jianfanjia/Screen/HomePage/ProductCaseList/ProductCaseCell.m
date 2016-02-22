//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductCaseCell.h"
#import "ViewControllerContainer.h"

@interface ProductCaseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *boderView;

@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) UITapGestureRecognizer *tapProductImage;
@property (strong, nonatomic) UITapGestureRecognizer *tapDesignerImage;

@end

@implementation ProductCaseCell

- (void)awakeFromNib {
    [self.designerImageView setCornerRadius:30];
    [self.boderView setCornerRadius:31];

    self.tapDesignerImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDesignerImage:)];
    [self.designerImageView addGestureRecognizer:self.tapDesignerImage];
    self.tapProductImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProductImage:)];
    [self.productImageView addGestureRecognizer:self.tapProductImage];
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    
    ProductImage *productImage = [product imageAtIndex:0];
    [self.productImageView setImageWithId:productImage.imageid withWidth:kScreenWidth];
    [self.designerImageView setUserImageWithId:self.product.designer.imageid];
    self.lblCell.text = product.cell;
    self.lblDetail.text = [NSString stringWithFormat:@"%@m², %@, %@, %@风格",
                           product.house_area,
                           [NameDict nameForDecType:product.dec_type],
                           [NameDict nameForHouseType:product.house_type],
                           [NameDict nameForDecStyle:product.dec_style]];
}

- (void)onTapProductImage:(UIGestureRecognizer *)sender {
    [ViewControllerContainer showProduct:self.product._id];
}

- (void)onTapDesignerImage:(UIGestureRecognizer *)sender {
    [ViewControllerContainer showDesigner:self.product.designerid];
}

@end
