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

@end

@implementation ThumbnailCell

- (void)awakeFromNib {
    [RACObserve(self, selected) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            self.checkImageView.hidden = NO;
        } else {
            self.checkImageView.hidden = YES;
        }
    }];
}


- (void)initWithPHAsset:(PHAsset *)asset {
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

@end
