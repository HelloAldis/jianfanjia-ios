//
//  ThumbnailCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ThumbnailCell.h"

@interface ThumbnailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (copy, nonatomic) void (^DetailBlock)();
@end

@implementation ThumbnailCell

- (void)awakeFromNib {
    [RACObserve(self, selected) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            self.checkImageView.image = [UIImage imageNamed:@"checked"];
        } else {
            self.checkImageView.image = [UIImage imageNamed:@"unchecked_1"];;
        }
    }];
    
    [self.checkImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapCheckImage:)]];
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapThumbnailImage:)]];
}

- (void)initWithPHAsset:(PHAsset *)asset detailBlock:(void(^)(void))DetailBlock {
    self.DetailBlock = DetailBlock;
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = false;
    
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(self.imageView.frame.size.width * kScreenScale, self.imageView.frame.size.height * kScreenScale)
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = result;
        });
    }];
}

#pragma mark - gesture
- (void)handleTapCheckImage:(UIGestureRecognizer *)gesture {
    self.selected = !self.selected;
}

- (void)handleTapThumbnailImage:(UIGestureRecognizer *)gesture {
    if (self.DetailBlock) {
        self.DetailBlock();
    }
}


@end
