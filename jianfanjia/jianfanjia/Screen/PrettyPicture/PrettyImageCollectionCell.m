//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PrettyImageCollectionCell.h"

@interface PrettyImageCollectionCell ()

@property (strong, nonatomic) NSString *imageid;

@end

@implementation PrettyImageCollectionCell

- (void)initWithImage:(NSString *)imageid width:(CGFloat)width {
    self.imageid = imageid;
    
    if (imageid) {
        [self.image setImageWithId:imageid withWidth:width];
    } else {
        self.image.image = [UIImage imageNamed:@"image_place_holder"];
    }
}

- (void)initWithImage:(UIImage *)image {
    self.image.image = image;
}

@end
