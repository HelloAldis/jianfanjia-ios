//
//  PhotoCropper.m
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PhotoCropper.h"
#import "RSKImageCropper.h"

@interface PhotoCropper () <RSKImageCropViewControllerDelegate>

@property (nonatomic, copy) PhotoCropperCancelBlock cancelBlock;
@property (nonatomic, copy) PhotoCropperChooseBlock chooseBlock;

@end

@implementation PhotoCropper

+ (void)showPhotoCropper:(UIViewController *)controller image:(UIImage *)image cancel:(PhotoCropperCancelBlock)cancelBlock choose:(PhotoCropperChooseBlock)chooseBlock {
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = [PhotoCropper shared];
    imageCropVC.avoidEmptySpaceAroundImage = YES;
    [PhotoCropper shared].cancelBlock = cancelBlock;
    [PhotoCropper shared].chooseBlock = chooseBlock;;
    
    [controller.navigationController pushViewController:imageCropVC animated:YES];
}

+ (void)showPhotoCropper:(UIViewController *)controller asset:(PHAsset *)asset cancel:(PhotoCropperCancelBlock)cancelBlock choose:(PhotoCropperChooseBlock)chooseBlock {
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = false;
    
    [imageManager requestImageForAsset:asset
                            targetSize:CGSizeMake(kScreenWidth * kScreenScale, kScreenHeight * kScreenScale)
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             [self showPhotoCropper:controller image:result cancel:cancelBlock choose:chooseBlock];
                         }];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    if ([PhotoCropper shared].cancelBlock) {
        [PhotoCropper shared].cancelBlock();
    }
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    if ([PhotoCropper shared].chooseBlock) {
        [PhotoCropper shared].chooseBlock(croppedImage);
    }
}

+ (instancetype)shared {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
