//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageProductItem.h"

@interface HomePageProductItem ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *image;

@property (strong, nonatomic) Product *product;

@end

@implementation HomePageProductItem

- (void)awakeFromNib {
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHomePageProductItemHeight)];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    self.image = image;
    [self.scrollView addSubview:image];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth,  kHomePageProductItemHeight)];
    self.backgroundColor = kPlaceHolderColor;
}

- (void)initWithProduct:(Product *)product {
    self.product = product;
    [self.image setImageWithId:product.cover_imageid withWidth:kScreenWidth height:kHomePageProductItemHeight];
}

@end
