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

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) OverlayView *overlayView;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *sourceImage;
@property (copy, nonatomic) FinishUploadBlock finishUploadBlock;

@end

@implementation ImageEditorViewController

#pragma mark - init method
- (id)initWithAsset:(PHAsset *)asset finishBlock:(FinishUploadBlock)finishUploadBlock {
    if (self = [super init]) {
        _asset = asset;
        _finishUploadBlock = finishUploadBlock;
    }
    
    return self;
}

- (id)initWithImage:(UIImage *)sourceImage finishBlock:(FinishUploadBlock)finishUploadBlock {
    if (self = [super init]) {
        _sourceImage = sourceImage;
        _finishUploadBlock = finishUploadBlock;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNav];
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.minimumZoomScale = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.scrollView addSubview:self.imageView];
    [self initImageView];
    [self initOverlayView];
}

#pragma mark - UI
- (void)initOverlayView {
    CGRect frame = CGRectMake(0, 0, kScreenWidth - 10, kScreenWidth - 10);
    self.overlayView = [[OverlayView alloc] initWithFrame:frame];
    self.overlayView.center = self.scrollView.center;
    self.overlayView.gridHidden = NO;
    self.overlayView.userInteractionEnabled = NO;
    [self.view addSubview:self.overlayView];
}

- (void)initNav {
    [self initLeftBackInNav];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onClickDone)];
    item.tintColor = kThemeColor;
    self.navigationItem.rightBarButtonItem = item;
}

- (void)initImageView {
    if (self.asset) {
        PHImageManager *imageManager = [PHImageManager defaultManager];
        
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = false;
        
        [imageManager requestImageForAsset:self.asset targetSize:CGSizeMake(self.imageView.frame.size.width * kScreenScale, self.imageView.frame.size.height * kScreenScale)
                               contentMode:PHImageContentModeAspectFit
                                   options:options
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     DDLogDebug(@"%@", NSStringFromCGSize(result.size));
                                     self.image = result;
                                     self.image = [result getCenterSquareImage];
                                     DDLogDebug(@"%@", NSStringFromCGSize(self.image.size));
                                     self.imageView.image = self.image;
                                 });
                             }];

    } else if (self.sourceImage) {
        self.image = [self.sourceImage aspectToScale:self.imageView.frame.size.width * kScreenScale];
        self.image = [self.image getCenterSquareImage];
        self.imageView.image = self.image;
    }
}

#pragma mark - scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return  self.imageView;
}

- (void)onClickDone {
    UIImage *newImage;
    DDLogDebug(@"--------------");
    
    DDLogDebug(@"%@", NSStringFromCGRect(self.imageView.frame));
    CGRect rect = [self.scrollView convertRect:self.scrollView.bounds toView:self.imageView];
    DDLogDebug(@"%@", NSStringFromCGRect(rect));
    
    float fx = (rect.origin.x * self.scrollView.zoomScale) / self.imageView.frame.size.width;
    float fy = (rect.origin.y * self.scrollView.zoomScale) / self.imageView.frame.size.height;
    float fw = (rect.size.width * self.scrollView.zoomScale) / self.imageView.frame.size.width;
    float fh = (rect.size.height * self.scrollView.zoomScale) / self.imageView.frame.size.height;
    
    DDLogDebug(@"%@", NSStringFromCGRect(CGRectMake(fx, fy, fw, fh)));
    CGRect newImageRect = CGRectMake(self.image.size.width * fx, self.image.size.height * fy, self.image.size.width * fw, self.image.size.width * fh);
    newImage = [self.image getSubImage:newImageRect];
    
    UploadImage *request = [[UploadImage alloc] init];
    request.image = newImage;
    @weakify(self);
    [API uploadImage:request success:^{
        @strongify(self);
        if (self.finishUploadBlock) {
            self.finishUploadBlock(@[[DataManager shared].lastUploadImageid]);
        }
        [self navigateToOriginalScreen];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)navigateToOriginalScreen {
    NSArray *controllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
    UIViewController *purposeController = nil;
    for (UIViewController *controller in controllers) {
        if (![controller isKindOfClass:[ImageBrowerViewController class]] && ![controller isKindOfClass:[ImageEditorViewController class]]) {
            purposeController = controller;
            break;
        }
    }
    
    [self.navigationController popToViewController:purposeController animated:YES];
}


@end
