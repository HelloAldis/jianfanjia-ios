//
//  ImageDetailViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageHomePageViewController.h"

@interface BeautifulImageHomePageViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *imgDescription;
@property (weak, nonatomic) IBOutlet UILabel *imgTag;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomToSuper;

@property (nonatomic, strong) UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *imageViewStatus;
@property (nonatomic, assign) NSInteger imgCount;

@property (nonatomic, strong) BeautifulImage *beautifulImage;
@property (nonatomic, assign) NSInteger index;

@end

@implementation BeautifulImageHomePageViewController

#pragma mark - init method
- (id)initWithBeautifulImage:(BeautifulImage *)beautifulImage index:(NSInteger)index {
    if (self = [super init]) {
        _beautifulImage = beautifulImage;
        _index = index;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

#pragma mark - ui
- (void)initNav {
    [self initLeftBackInNav];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"white_back"];
    
    self.favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[self.beautifulImage.is_my_favorite boolValue]? @"collected" : @"collect"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickFavoriteButton)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShareButton)];
    
    self.navigationItem.rightBarButtonItems = @[shareButton, self.favoriteButton];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUI {
    self.imgCount = self.beautifulImage.images.count;
    self.imageViewStatus = [NSMutableArray arrayWithCapacity:self.imgCount];
    self.imageViewArray = [NSMutableArray arrayWithCapacity:self.imgCount];
    @weakify(self);
    for (int i = 0; i < self.imgCount; i++) {
        UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [w1 setContentMode:UIViewContentModeScaleAspectFit];
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        s.maximumZoomScale = 3;
        s.minimumZoomScale = 1;
        [s setContentSize:CGSizeMake(kScreenWidth,  kScreenHeight)];
        s.bounces = NO;
        s.bouncesZoom = NO;
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        [s addSubview:w1];
        [self.scrollView addSubview:s];
        [self.imageViewArray addObject:w1];
        
        LeafImage *leafImage = [self.beautifulImage leafImageAtIndex:i];
        [self.imageViewStatus addObject:@0];
        [w1 setImageWithId:leafImage.imageid withWidth:kScreenWidth completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self);
            if (error == nil) {
                self.imageViewStatus[i] = @1;
            }
        }];
    }
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * self.imgCount, kBannerCellHeight)];
    self.title = [NSString stringWithFormat:@"%@/%@", @(self.index + 1), @(self.imgCount)];
    self.scrollView.contentOffset = CGPointMake(self.index * kScreenWidth, 0);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    self.imgDescription.text = self.beautifulImage.beautiful_image_description;
    self.imgTag.text = [[[self.beautifulImage.keywords componentsSeparatedByString:@","] map:^id(NSString *obj) {
        return [NSString stringWithFormat:@"#%@", obj];
    }] join:@" "];
    
    [[self.btnDownload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickDownloadButton];
    }];
}

#pragma mark - scroll view deleaget
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.index = self.scrollView.contentOffset.x/kScreenWidth;
        self.title = [NSString stringWithFormat:@"%@/%@", @(self.index + 1), @(self.imgCount)];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return [self.imageViewArray objectAtIndex:self.index];
    } else {
        return nil;
    }
}

#pragma mark - user action
- (void)onClickFavoriteButton {
    if (![self.beautifulImage.is_my_favorite boolValue]) {
        FavoriteBeautifulImage *request = [[FavoriteBeautifulImage alloc] init];
        request._id = self.beautifulImage._id;
        
        [API favoriteBeautifulImage:request success:^{
            self.beautifulImage.is_my_favorite = @1;
            [self.favoriteButton setImage:[UIImage imageNamed:@"collected"]];
        } failure:^{
            
        } networkError:^{
            
        }];
    } else {
        UnfavoriteBeautifulImage *request = [[UnfavoriteBeautifulImage alloc] init];
        request._id = self.beautifulImage._id;
        
        [API unfavoriteBeautifulImage:request success:^{
            self.beautifulImage.is_my_favorite = @0;
            [self.favoriteButton setImage:[UIImage imageNamed:@"collect"]];
        } failure:^{
            
        } networkError:^{
            
        }];
    }
}

- (void)onClickShareButton {
    [HUDUtil showSuccessText:@"分享功能还没开放，敬请期待"];
}

- (void)onClickDownloadButton {
    NSNumber *status = self.imageViewStatus[self.index];
    if ([status boolValue]) {
        UIImageView *imgView = self.imageViewArray[self.index];
        UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        [HUDUtil showErrText:@"美图正在准备中，请耐心等待"];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [HUDUtil showSuccessText:@"保存成功"];
    } else {
        [HUDUtil showSuccessText:@"保存失败"];
    }
}

#pragma mark - gesture
- (void)onSingleTap {
    BOOL isHidden = self.navigationController.navigationBarHidden;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [self.navigationController setNavigationBarHidden:!isHidden animated:YES];
        self.textViewBottomToSuper.constant = !isHidden ? 0 : 45;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)onDoubleTap {
    UIScrollView *subscrollView = self.scrollView.subviews[self.index];
    
    if (subscrollView.zoomScale > 1) {
        [subscrollView setZoomScale:1.0 animated:YES];
    } else {
        [subscrollView setZoomScale:2.0 animated:YES];
    }
}

@end
