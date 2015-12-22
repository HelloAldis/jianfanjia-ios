//
//  FavoriateProductCell.m
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateProductCell.h"

@interface FavoriateProductCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (weak, nonatomic) Product *product;

@end


@implementation FavoriateProductCell

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    
    self.lblCell.text = self.product.cell;
    [self.productImageView setImageWithId:[self.product imageAtIndex:0].imageid withWidth:kScreenWidth];
    self.lblDetail.text = [NSString stringWithFormat:@"%@m², %@, %@风格",
                           self.product.house_area,
                           [NameDict nameForHouseType:self.product.house_type],
                           [NameDict nameForDecStyle:self.product.dec_style]];
}

@end
