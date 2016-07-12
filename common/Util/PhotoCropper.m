//
//  PhotoCropper.m
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PhotoCropper.h"
#import "TOCropViewController.h"

@interface PhotoCropper () <TOCropViewControllerDelegate>

@property (nonatomic, copy) PhotoCropperCancelBlock cancelBlock;
@property (nonatomic, copy) PhotoCropperChooseBlock chooseBlock;

@end

@implementation PhotoCropper

+ (void)showPhotoCropper:(UIViewController *)controller image:(UIImage *)image style:(PhotoCropperStyle)style cancel:(PhotoCropperCancelBlock)cancelBlock choose:(PhotoCropperChooseBlock)chooseBlock {
    [PhotoCropper shared].cancelBlock = cancelBlock;
    [PhotoCropper shared].chooseBlock = chooseBlock;
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = [PhotoCropper shared];
    cropViewController.aspectRatioPreset = style == PhotoCropperStyleOriginal ? TOCropViewControllerAspectRatioPresetOriginal : TOCropViewControllerAspectRatioPresetSquare;
    cropViewController.aspectRatioPickerButtonHidden = YES;
    cropViewController.rotateButtonsHidden = YES;
    cropViewController.aspectRatioLockEnabled = YES;
    cropViewController.resetAspectRatioEnabled = NO;
    [cropViewController resetCropViewLayout];
    
    UIViewController *contrl = controller.presentedViewController ? controller.presentedViewController : controller;
    [contrl presentViewController:cropViewController animated:YES completion:nil];
}

+ (void)showPhotoCropper:(UIViewController *)controller asset:(PHAsset *)asset style:(PhotoCropperStyle)style cancel:(PhotoCropperCancelBlock)cancelBlock choose:(PhotoCropperChooseBlock)chooseBlock {
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
                             [self showPhotoCropper:controller image:result style:style cancel:cancelBlock choose:chooseBlock];
                         }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    if ([PhotoCropper shared].chooseBlock) {
        [PhotoCropper shared].chooseBlock(image);
    }
    
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    if ([PhotoCropper shared].cancelBlock) {
        [PhotoCropper shared].cancelBlock();
    }
    
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
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
