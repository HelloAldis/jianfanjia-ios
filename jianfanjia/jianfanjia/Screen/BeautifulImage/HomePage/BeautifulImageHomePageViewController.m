//
//  ImageDetailViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageHomePageViewController.h"
#import "BeautifulImageDataManager.h"
#import "BeautifulImageCollectionCell.h"

@interface BeautifulImageHomePageViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriateButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *imgDescription;
@property (weak, nonatomic) IBOutlet UILabel *imgTag;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomToSuper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarViewTopToSuper;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;
@property (nonatomic, strong) NSMutableArray<UIScrollView *> *subscrollViewArray;

@property (nonatomic, strong) BeautifulImage *beautifulImage;

@property (nonatomic, strong) NSMutableArray<BeautifulImage *> *beautifulImages;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL isGettingHomepage;
@property (nonatomic, assign) BOOL hasMoreBeautifulImage;

@property (strong, nonatomic) id<BeautifulImageHomePageDataManagerProtocol> dataManager;
@property (strong, nonatomic) BaseRequest<BeautifulImageHomePageLoadMoreRequestProtocol> *loadMoreRequest;


@property (nonatomic, strong) NSNumber *pageNumber;

@end

@implementation BeautifulImageHomePageViewController

#pragma mark - init method
- (id)initWithDataManager:(id<BeautifulImageHomePageDataManagerProtocol>)dataManager index:(NSInteger)index loadMore:(BaseRequest<BeautifulImageHomePageLoadMoreRequestProtocol> *)loadMoreRequest {
    if (self = [super init]) {
        _index = index;
        _dataManager = dataManager;
        _loadMoreRequest = loadMoreRequest;
        _beautifulImages = dataManager.beautifulImages;
        _beautifulImage = _beautifulImages[index];
        _total = dataManager.total;
        _pageNumber = @(20);
        _hasMoreBeautifulImage = _index == _total;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self reloadAllImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self initDefaultNavBarStyle];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - ui
- (void)initNav {
    [self initLeftBackInNav];
    
    @weakify(self);
    [self.favoriateButton addTapBounceAnimation:^{
        @strongify(self);
        [self onClickFavoriteButton];
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initRightNaviBarItems {
    if ([self.beautifulImage.is_my_favorite boolValue]) {
        [self.favoriateButton setNormImg:[UIImage imageNamed:@"beautiful_img_favoriate_yes"]];
    } else {
        [self.favoriateButton setNormImg:[UIImage imageNamed:@"beautiful_img_favoriate_no"]];
    }
}

- (void)initUI {
    [self initRightNaviBarItems];
    self.imgDescription.text = nil;
    self.imgTag.text = nil;
    self.btnDownload.hidden = YES;
    self.shareButton.enabled = NO;
    
    LeafImage *leafImg = [self.beautifulImage leafImageAtIndex:0];
    CGFloat scaleFactor = leafImg.width.integerValue / kScreenWidth;
    CGFloat height = leafImg.height.integerValue / scaleFactor;
    
    self.imageViewArray = [NSMutableArray arrayWithCapacity:3];
    self.subscrollViewArray = [NSMutableArray arrayWithCapacity:3];
    @weakify(self);
    for (int i = 0; i < 3; i++) {
        UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kScreenHeight - height) / 2, kScreenWidth, height)];
        w1.backgroundColor = kPlaceHolderColor;
        [w1 setContentMode:UIViewContentModeScaleAspectFit];
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        s.backgroundColor = [UIColor clearColor];
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
        [self.subscrollViewArray addObject:s];
    }
    
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * 3, kScreenHeight)];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [[self.btnDownload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickDownloadButton];
    }];
}

- (void)reloadAllImage {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (offsetX > kScreenWidth) { // 向右
        self.index++;
        self.beautifulImage = self.beautifulImages[self.index];
    } else if (offsetX < kScreenWidth) { // 向左
        self.index--;
        self.beautifulImage = self.beautifulImages[self.index];
    } else {
        self.beautifulImage = self.beautifulImages[self.index];
    }
    
    [self resetUI];
    LeafImage *preImageid = [self.beautifulImages[MAX(self.index-1, 0)] leafImageAtIndex:0];
    LeafImage *curImageid = [self.beautifulImages[self.index] leafImageAtIndex:0];
    LeafImage *nextImageid = [self.beautifulImages[MIN(self.index+1, self.beautifulImages.count-1)] leafImageAtIndex:0];
    [self reloadImageView:self.imageViewArray[0] withImage:preImageid];
    [self reloadImageView:self.imageViewArray[1] withImage:curImageid];
    [self reloadImageView:self.imageViewArray[2] withImage:nextImageid];
    
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.index+1), @(self.total)];
    self.imgDescription.text = self.beautifulImage.title;
    self.imgTag.text = [[[self.beautifulImage.keywords componentsSeparatedByString:@","] map:^id(id obj) {
        return [NSString stringWithFormat:@"#%@", obj];
    }] join:@" "];
}

- (void)resetUI {
    [self initRightNaviBarItems];
    self.btnDownload.hidden = YES;
    self.shareButton.enabled = NO;
    [self.subscrollViewArray[1] setZoomScale:1];
}

- (void)reloadImageView:(UIImageView *)imgView withImage:(LeafImage *)imageid {
    LeafImage *leafImg = imageid;
    CGFloat scaleFactor = leafImg.width.integerValue / kScreenWidth;
    CGFloat height = leafImg.height.integerValue / scaleFactor;
    imgView.frame = CGRectMake(0, (kScreenHeight - height) / 2, kScreenWidth, height);
    
    @weakify(imgView);
    [imgView setImageWithId:leafImg.imageid withWidth:kScreenWidth completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
        @strongify(imgView);
        if (error == nil) {
            if (imgView == self.imageViewArray[1]) {
                self.btnDownload.hidden = NO;
                self.shareButton.enabled = YES;
            }
        }
    }];
}

#pragma mark - scroll view deleaget
- (CGPoint)nearestTargetOffset:(CGPoint)curOffset velocity:(CGPoint)velocity {
    CGPoint targetOffset;
    if (curOffset.x > kScreenWidth) {
        if (curOffset.x > kScreenWidth * 1.5 || velocity.x > 0) {
            targetOffset = CGPointMake(kScreenWidth * 2, curOffset.y);
        } else {
            targetOffset = CGPointMake(kScreenWidth, curOffset.y);
        }
    } else {
        if (curOffset.x < kScreenWidth * 0.5 || velocity.x < 0) {
            targetOffset = CGPointMake(0, curOffset.y);
        } else {
            targetOffset = CGPointMake(kScreenWidth, curOffset.y);
        }
    }
    
    return targetOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.scrollView) {
        CGPoint targetOffset = [self nearestTargetOffset:scrollView.contentOffset velocity:velocity];
        targetContentOffset->x = targetOffset.x;
        targetContentOffset->y = targetOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.scrollView) {
        if (!decelerate) {
            [self reloadAllImage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self reloadAllImage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offsetX = self.scrollView.contentOffset.x;
        if (self.index == 0 && offsetX < kScreenWidth) {
            self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
        } else if (self.index == self.beautifulImages.count - 1 && offsetX > kScreenWidth) {
            self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
            if (self.index < self.total && !self.isGettingHomepage) {
                [self loadMoreBeautifulImage];
            }
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return self.imageViewArray[1];
    } else {
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = self.imageViewArray[1];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - user action
- (IBAction)onClickBackButton:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock(self.index);
    }
}

- (void)onClickFavoriteButton {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            if (![self.beautifulImage.is_my_favorite boolValue]) {
                FavoriteBeautifulImage *request = [[FavoriteBeautifulImage alloc] init];
                request._id = self.beautifulImage._id;
                
                [API favoriteBeautifulImage:request success:^{
                    self.beautifulImage.is_my_favorite = @1;
                    [self.favoriateButton setNormImg:[UIImage imageNamed:@"beautiful_img_favoriate_yes"]];
                    [HUDUtil showSuccessText:@"收藏成功"];
                } failure:^{
                    [HUDUtil showErrText:@"收藏失败"];
                } networkError:^{
                }];
            } else {
                UnfavoriteBeautifulImage *request = [[UnfavoriteBeautifulImage alloc] init];
                request._id = self.beautifulImage._id;
                
                [API unfavoriteBeautifulImage:request success:^{
                    self.beautifulImage.is_my_favorite = @0;
                    [self.favoriateButton setNormImg:[UIImage imageNamed:@"beautiful_img_favoriate_no"]];
                    [HUDUtil showSuccessText:@"取消收藏成功"];
                } failure:^{
                    [HUDUtil showErrText:@"取消收藏失败"];
                } networkError:^{
                }];
            }
        }
    }];
}

- (IBAction)onClickShareButton:(id)sender {
    NSString *title = self.beautifulImage.title;
    UIImage *shareImage = [self.imageViewArray[1] image];
    NSString *imgid = [[self.beautifulImage leafImageAtIndex:0] imageid];
    NSString *imgLink = [StringUtil beautifulImageUrl:imgid title:title];
    NSString *description = [NSString stringWithFormat:@"我在简繁家发现一张%@风格的%@美图，感觉还不错，分享给大家！", [NameDict nameForDecStyle:self.beautifulImage.dec_style], self.beautifulImage.section];
    
    [[ShareManager shared] share:self topic:ShareTopicBeautifulImage image:shareImage title:title description:description targetLink:imgLink delegate:self];
}

- (void)onClickDownloadButton {
    [UIView playBounceAnimationFor:self.btnDownload block:^{
        UIImageView *imgView = self.imageViewArray[1];
        UIImageWriteToSavedPhotosAlbum(imgView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [HUDUtil showSuccessText:@"保存到相册成功"];
    } else {
        [HUDUtil showErrText:@"保存到相册失败"];
    }
}

#pragma mark - gesture
- (void)onSingleTap {
    self.isHidden = !self.isHidden;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.navBarViewTopToSuper.constant = self.isHidden ? -44 : 20;
        self.textViewBottomToSuper.constant = self.isHidden ? -35 : 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)g {
    UIScrollView *subscrollView = self.subscrollViewArray[1];
    
    if (subscrollView.zoomScale > 1) {
        [subscrollView setZoomScale:1.0 animated:YES];
    } else {
        UIImageView *imgView = subscrollView.subviews[0];
        CGPoint touchPoint = [g locationInView:imgView];
        CGFloat newZoomScale = subscrollView.maximumZoomScale;
        CGFloat xsize = subscrollView.frame.size.width / newZoomScale;
        CGFloat ysize = subscrollView.frame.size.height / newZoomScale;
        [subscrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - api request
- (void)loadMoreBeautifulImage {
    if (self.hasMoreBeautifulImage) {
        [HUDUtil showSuccessText:@"没有更多美图了"];
        return;
    }
    
    [HUDUtil showWait:@"更多美图加载中..."];
    self.isGettingHomepage = YES;
    
    if ([self.loadMoreRequest isKindOfClass:[SearchBeautifulImage class]]) {
        [self.loadMoreRequest setFrom:@(self.dataManager.beautifulImages.count)];
        [API searchBeautifulImage:(SearchBeautifulImage *)self.loadMoreRequest success:^{
            [self resetData];
            [self reloadAllImage];
            [HUDUtil hideWait];
            self.isGettingHomepage = NO;
        } failure:^{
            [HUDUtil hideWait];
            self.isGettingHomepage = NO;
        } networkError:^{
            [HUDUtil hideWait];
            self.isGettingHomepage = NO;
        }];
    } else if ([self.loadMoreRequest isKindOfClass:[ListFavoriateBeautifulImage class]]) {
        [self.loadMoreRequest setFrom:@(self.dataManager.beautifulImages.count)];
        @weakify(self);
        [API listFavoriateBeautifulImage:(ListFavoriateBeautifulImage *)self.loadMoreRequest success:^{
            @strongify(self);
            [self resetData];
            [self reloadAllImage];
            [HUDUtil hideWait];
            self.isGettingHomepage = NO;
        } failure:^{
            [HUDUtil hideWait];
            self.isGettingHomepage = NO;
        } networkError:^{
            [HUDUtil hideWait];
            self.isGettingHomepage = NO;
        }];
    }
}

- (void)resetData {
    NSInteger count = [self.dataManager loadMoreBeautifulImages];
    self.beautifulImages = self.dataManager.beautifulImages;
    self.index = [self.beautifulImages indexOfObject:self.beautifulImage];
    self.hasMoreBeautifulImage = count < [self.pageNumber integerValue];
}

- (void)presentFromImageView:(UIImageView *)fromImageView fromController:(UIViewController *)controller {
    UIView *toContainer = controller.navigationController.view;
    CGRect fromFrame = [toContainer convertRect:fromImageView.bounds fromView:fromImageView];
    
    UIImageView *fromViewImage = [[UIImageView alloc] initWithFrame:fromFrame];
    [fromViewImage setImage:fromImageView.image];
    [fromViewImage setBackgroundColor:kPlaceHolderColor];
    
    UIView *background = [[UIView alloc] initWithFrame:toContainer.bounds];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0;

    [toContainer addSubview:background];
    [toContainer addSubview:fromViewImage];
    
    CGFloat scaleFactor = fromFrame.size.width / kScreenWidth;
    CGFloat height = fromFrame.size.height / scaleFactor;
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        background.alpha = 1;
        fromViewImage.frame = CGRectMake(0, (kScreenHeight - height) / 2, kScreenWidth, height);
    }completion:^(BOOL finished) {
        [fromViewImage removeFromSuperview];
        [background removeFromSuperview];
        [controller.navigationController pushViewController:self animated:NO];
    }];
}

- (void)dismissToRect:(CGRect)toFrame {
    UIViewController *controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    [self.navigationController popViewControllerAnimated:NO];
    UIView *toContainer = controller.view;

    UIImageView *enterImageView = self.imageViewArray[1];
    UIImageView *toViewImage = [[UIImageView alloc] initWithFrame:enterImageView.frame];
    [toViewImage setImage:enterImageView.image];
    [toViewImage setBackgroundColor:kPlaceHolderColor];
    
    UIView *background = [[UIView alloc] initWithFrame:toContainer.bounds];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 1;
    
    [toContainer addSubview:background];
    [toContainer addSubview:toViewImage];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        background.alpha = 0;
        toViewImage.frame = toFrame;
    }completion:^(BOOL finished) {
        [toViewImage removeFromSuperview];
        [background removeFromSuperview];
    }];
}
@end
