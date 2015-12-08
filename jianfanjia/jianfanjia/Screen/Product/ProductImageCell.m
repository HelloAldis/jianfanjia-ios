//
//  ProductImageCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductImageCell.h"
#import "ViewControllerContainer.h"
#import "ImageDetailViewController.h"

@interface ProductImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblSection;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribtion;

@property (weak, nonatomic) ProductImage *productImage;
@property (weak, nonatomic) NSArray *images;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation ProductImageCell

- (void)awakeFromNib {
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.productImageView addGestureRecognizer:self.tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithProductImage:(ProductImage *)productImage andIndex:(NSInteger)index andImages:(NSArray *)images {
    self.productImage = productImage;
    self.index = index;
    self.images = images;
    
    [self.productImageView setImageWithId:self.productImage.imageid withWidth:kScreenWidth];
    self.lblSection.text = self.productImage.section;
    self.lblDescribtion.text = self.productImage.description;
}

- (void)onTap {
    NSArray *imageArray = [self.images map:^(NSDictionary *dict) {
        return [dict objectForKey:@"imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imageArray index:self.index];
}

@end
