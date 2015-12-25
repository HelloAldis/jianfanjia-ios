//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageCollectionCell.h"
#import "ViewControllerContainer.h"

@interface BeautifulImageCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) BeautifulImage *beautifulImage;
@property (weak, nonatomic) DeleteFavoriateBeautifulImageBlock block;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation BeautifulImageCollectionCell

- (void)awakeFromNib {
    [self.image setCornerRadius:5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.image addGestureRecognizer:tap];
}

- (void)initWithImage:(NSString *)imageid width:(CGFloat)width {
    [self.image setImageWithId:imageid withWidth:width];
}

- (void)initWithImage:(BeautifulImage *)beautifulImage {
    self.beautifulImage = beautifulImage;
    LeafImage *leafImage = [self.beautifulImage leafImageAtIndex:0];
    [self.image setImageWithId:leafImage.imageid withWidth:self.bounds.size.width];
}

- (void)onTap {
    if (self.beautifulImage) {
        [ViewControllerContainer showBeautifulImageHomePage:self.beautifulImage];
    }
}

@end
