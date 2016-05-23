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

@end

@implementation ProductAuthPlanImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView setCornerRadius:5];
    [self.imgView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
}

- (void)initWithProduct:(Product *)product image:(ProductImage *)image {
    [self.imgView setImageWithId:image.imageid withWidth:kScreenWidth];
    self.coverImgView.hidden = ![product.cover_imageid isEqualToString:image.imageid];
}

@end
