//
//  ImageEditorViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ImageEditorViewController.h"
#import "OverlayView.h"

@interface ImageEditorViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) OverlayView *overlayView;

@end

@implementation ImageEditorViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNav];
    [self initImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initOverlayView];
}

#pragma mark - UI
- (void)initOverlayView {
    
    self.overlayView = [[OverlayView alloc] initWithFrame:self.scrollView.frame];
    self.overlayView.gridHidden = NO;
    [self.view addSubview:self.overlayView];
}

- (void)initNav {
    [self initLeftBackInNav];
}

- (void)initImageView {
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = false;
    
    [imageManager requestImageForAsset:self.asset targetSize:self.imageView.frame.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = result;
        });
    }];
}


@end
