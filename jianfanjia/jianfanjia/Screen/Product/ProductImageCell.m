//
//  ProductImageCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductImageCell.h"

@interface ProductImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribtion;

@property (weak, nonatomic) ProductImage *productImage;

@end

@implementation ProductImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithProductImage:(ProductImage *)productImage {
    self.productImage = productImage;
    
    [self.productImageView setImageWithId:self.productImage.imageid];
    self.lblSection.text = self.productImage.section;
    self.lblDescribtion.text = self.productImage.description;
}

@end
