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
#import "PhotoGroupView.h"
#import "ViewControllerContainer.h"

@interface BeautifulImageHomePageViewController () <PhotoGroupViewProtocol>

@property (weak, nonatomic) IBOutlet UILabel *imgDescription;
@property (weak, nonatomic) IBOutlet UILabel *imgTag;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewBottomToSuper;

@property (strong, nonatomic) PhotoGroupView *photoGroupView;

@property (strong, nonatomic) UIBarButtonItem *favoriteItem;
@property (strong, nonatomic) UIBarButtonItem *shareItem;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViewArray;
@property (nonatomic, strong) NSMutableArray<UIScrollView *> *subscrollViewArray;

@property (nonatomic, strong) BeautifulImage *beautifulImage;

@property (nonatomic, strong) NSMutableArray<BeautifulImage *> *beautifulImages;
@property (nonatomic, strong) NSArray<PhotoGroupItem *> *groupItems;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - ui
- (void)initNav {
    [self initTransparentNavBar:UIBarStyleBlack];
    [self initLeftWhiteBackInNav];
    self.navigationController.navigationBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beautiful_img_favoriate_yes"]];
    @weakify(self);
    [imageView addTapBounceAnimation:^{
        @strongify(self);
        [self onClickFavoriteButton];
    }];
    self.favoriteItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    self.favoriteItem.tintColor = [UIColor whiteColor];

    self.shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShareButton)];
    self.shareItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[self.shareItem, self.favoriteItem];
}

- (void)initRightNaviBarItems {
    if ([self.beautifulImage.is_my_favorite boolValue]) {
        [self.favoriteItem.customView setImage:[UIImage imageNamed:@"beautiful_img_favoriate_yes"]];
    } else {
        [self.favoriteItem.customView setImage:[UIImage imageNamed:@"beautiful_img_favoriate_no"]];
    }
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.photoGroupView = [[PhotoGroupView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.photoGroupView.delegate = self;
    self.photoGroupView.groupItems = [self convertToGroupItems];
    self.photoGroupView.index = self.index;
    [self.view insertSubview:self.photoGroupView belowSubview:self.bottomView];
    
    [self initRightNaviBarItems];
    self.imgDescription.text = nil;
    self.imgTag.text = nil;
    self.btnDownload.hidden = YES;
    self.shareItem.enabled = NO;
    
    @weakify(self);
    [[self.btnDownload rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickDownloadButton];
    }];
}

#pragma mark - photo group view delegate
- (void)photoGrouopViewDidChangePage:(PhotoGroupView *)photoGroupView toPage:(NSInteger)toPage {
    self.beautifulImage = self.beautifulImages[toPage];
    self.title = [NSString stringWithFormat:@"%@/%@", @(toPage+1), @(self.total)];
    self.imgDescription.text = self.beautifulImage.title;
    self.imgTag.text = [[[self.beautifulImage.keywords componentsSeparatedByString:@","] map:^id(id obj) {
        return [NSString stringWithFormat:@"#%@", obj];
    }] join:@" "];
    
    [self initRightNaviBarItems];
    self.btnDownload.hidden = ![self.groupItems[toPage] loadedImage];
    self.shareItem.enabled = [self.groupItems[toPage] loadedImage] != nil;
    self.index = toPage;
}

- (void)photoGrouopViewDidSingleTap:(PhotoGroupView *)photoGroupView {
    self.isHidden = !self.isHidden;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.textViewBottomToSuper.constant = self.isHidden ? -35 : 0;
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.navigationController setNavigationBarHidden:self.isHidden animated:YES];
}

- (void)photoGrouopViewWillLoadMore:(PhotoGroupView *)photoGroupView {
    if (!self.isGettingHomepage) {
        [self loadMoreBeautifulImage];
    }
}

#pragma mark - user action
- (void)onClickBack {
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
                    [self.favoriteItem.customView setImage:[UIImage imageNamed:@"beautiful_img_favoriate_yes"]];
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
                    [self.favoriteItem.customView setImage:[UIImage imageNamed:@"beautiful_img_favoriate_no"]];
                    [HUDUtil showSuccessText:@"取消收藏成功"];
                } failure:^{
                    [HUDUtil showErrText:@"取消收藏失败"];
                } networkError:^{
                }];
            }
        }
    }];
}

- (void)onClickShareButton {
    NSString *title = self.beautifulImage.title;
    UIImage *shareImage = [self.groupItems[self.index] loadedImage];
    NSString *imgid = [[self.beautifulImage leafImageAtIndex:0] imageid];
    NSString *imgLink = [StringUtil beautifulImageUrl:imgid title:title];
    NSString *description = [NSString stringWithFormat:@"我在简繁家发现一张%@风格的%@美图，感觉还不错，分享给大家！", [NameDict nameForDecStyle:self.beautifulImage.dec_style], self.beautifulImage.section];
    
    [[ShareManager shared] share:self topic:ShareTopicBeautifulImage image:shareImage title:title description:description targetLink:imgLink delegate:self];
}

- (void)onClickDownloadButton {
    [UIView playBounceAnimationFor:self.btnDownload block:^{
        UIImageWriteToSavedPhotosAlbum([self.groupItems[self.index] loadedImage], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [HUDUtil showSuccessText:@"保存到相册成功"];
    } else {
        [HUDUtil showErrText:@"保存到相册失败"];
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
    self.hasMoreBeautifulImage = count < [self.pageNumber integerValue];
    self.photoGroupView.groupItems = [self convertToGroupItems];
}

#pragma mark - covert to group items
- (NSArray *)convertToGroupItems {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.beautifulImages.count];
    [self.beautifulImages enumerateObjectsUsingBlock:^(BeautifulImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = idx;
        PhotoGroupItem *item = [[PhotoGroupItem alloc] init];
        item.imageid = [[obj leafImageAtIndex:0] imageid];
        item.loadedBlock = ^(UIImage *img) {
            if (index == self.index) {
                self.btnDownload.hidden = NO;
                self.shareItem.enabled = YES;
            }
        };
        
        [arr addObject:item];
    }];

    self.groupItems = arr;
    return arr;
}

#pragma mark - show animation
- (void)presentFromImageView:(UIImageView *)fromImageView fromController:(UIViewController *)controller {
    UIView *toContainer = [ViewControllerContainer navigation].view;
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
        [[ViewControllerContainer navigation] pushViewController:self animated:NO];
    }];
}

- (void)dismissToRect:(CGRect)toFrame {
    UIViewController *controller = [ViewControllerContainer navigation].viewControllers[[ViewControllerContainer navigation].viewControllers.count - 2];
    [[ViewControllerContainer navigation] popViewControllerAnimated:NO];
    UIView *toContainer = controller.view;

    UIImageView *toViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [toViewImage setImage:[self.groupItems[self.index] loadedImage]];
    [toViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [toViewImage setBackgroundColor:[UIColor clearColor]];
    
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
