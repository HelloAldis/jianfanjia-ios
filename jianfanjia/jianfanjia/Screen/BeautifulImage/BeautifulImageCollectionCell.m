//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageCollectionCell.h"

@interface BeautifulImageCollectionCell ()

@end

@implementation BeautifulImageCollectionCell

- (void)awakeFromNib {
    [self.image setCornerRadius:5];
}

- (void)initWithImage:(NSString *)imageid width:(CGFloat)width {
    [self.image setImageWithId:imageid withWidth:width];
}

- (void)initWithImage:(UIImage *)image {
    self.image.image = image;
}

@end
