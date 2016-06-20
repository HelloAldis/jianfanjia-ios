//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "StaticImageCollectionCell.h"

@interface StaticImageCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgView;

@end

@implementation StaticImageCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage)]];
    self.deleteView.tintColor = [UIColor whiteColor];
    [self.deleteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDelete)]];
}

- (void)initWithImageId:(NSString *)imageid {
    [self.image setImageWithId:imageid withWidth:self.frame.size.width];
}

- (void)initWithImage:(UIImage *)image {
    self.image.image = image;
}

- (void)onTapImage {
    if (self.tapImageBlock) {
        self.tapImageBlock(self);
    }
}

- (void)onTapDelete {
    if (self.tapDeleteBlock) {
        self.tapDeleteBlock(self);
    }
}

@end
