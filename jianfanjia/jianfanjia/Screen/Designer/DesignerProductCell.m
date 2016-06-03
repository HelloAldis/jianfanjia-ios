//
//  DesignerProductCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerProductCell.h"
#import "ViewControllerContainer.h"

@interface DesignerProductCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (weak, nonatomic) Product *product;
@property (strong, nonatomic) UITapGestureRecognizer *tapProductImage;

@end

@implementation DesignerProductCell

- (void)awakeFromNib {
    self.tapProductImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProductImage:)];
    [self.productImageView addGestureRecognizer:self.tapProductImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    
    self.lblCell.text = self.product.cell;
    [self.productImageView setImageWithId:product.cover_imageid withWidth:kScreenWidth];
    self.lblDetail.text = product.house_area ? [NSString stringWithFormat:@"%@m², %@, %@, %@风格\n%@, %@万",
                                                product.house_area,
                                                [NameDict nameForDecType:product.dec_type],
                                                [ProductBusiness houseTypeByDecType:product],
                                                [NameDict nameForDecStyle:product.dec_style],
                                                [NameDict nameForWorkType:product.work_type],
                                                product.total_price] : @"";
    [self.lblDetail setRowSpace:7.0f];
}

- (void)onTapProductImage:(UIGestureRecognizer *)sender {
    if (self.product) {
        [ViewControllerContainer showProduct:self.product._id];
    }
}

@end
