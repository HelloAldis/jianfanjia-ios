//
//  PhotoGroupCell.m
//  jianfanjia
//
//  Created by Karos on 16/5/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PhotoGroupView.h"
#import "ReuseScrollView.h"

@interface PhotoGroupItem()

@property (nonatomic, retain) UIImage *loadedImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;

@end

@implementation PhotoGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        return ((UIImageView *)_thumbView).image;
    }
    
    if (_thumbView.layer.contents) {
        return [UIImage imageWithCGImage:(CGImageRef)_thumbView.layer.contents];
    }
    
    return _thumbImage ? _thumbImage : [UIImage imageNamed:@"image_place_holder"];
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.frame.size.width < 1 || view.frame.size.height < 1) return NO;
    return imageSize.height / imageSize.width > view.frame.size.width / view.frame.size.height;
}

- (id)copyWithZone:(NSZone *)zone {
    PhotoGroupItem *item = [self.class new];
    return item;
}


@end

@interface PhotoGroupCell : ReuseCell <UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *imageContainerView;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, retain) CAShapeLayer *progressLayer;

@property (nonatomic, retain) PhotoGroupItem *item;

- (void)resizeSubviewSize;

@end

@implementation PhotoGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.frame = [UIScreen mainScreen].bounds;
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 3;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.frame = self.bounds;
    [self addSubview:_scrollView];

    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    _imageContainerView.frame = self.bounds;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor clearColor];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = CGRectMake(0, 0, 40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = _progressLayer.frame;
    frame.origin = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    _progressLayer.frame = frame;
}

- (void)setItem:(PhotoGroupItem *)item {
    if (_item == item) return;
    _item = item;
    _item.loadedImage = nil;
    
    [_scrollView setZoomScale:1.0 animated:NO];
    _scrollView.maximumZoomScale = 1;
    
    [_imageView cancelCurrentImageRequest];
    [_imageView.layer removePreviousFadeAnimation];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }
    
    if (item.itemType == PhotoGroupItemTypeOffline) {
        _item.loadedImage = _item.thumbImage;
        _progressLayer.hidden = YES;
        _imageView.image = _item.thumbImage;
        _scrollView.maximumZoomScale = 3;
        
        if (self.item.loadedBlock) {
            self.item.loadedBlock(_item.thumbImage);
        }
    } else {
        @weakify(self);
        [_imageView setImageWithId:_item.imageid withWidth:self.bounds.size.width placeholder:_item.thumbImage options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            @strongify(self);
            if (!self) return;
            CGFloat progress = receivedSize / (float)expectedSize;
            progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
            if (isnan(progress)) progress = 0;
//            self.progressLayer.hidden = NO;
            self.progressLayer.strokeEnd = progress;
        } completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
            @strongify(self);
            if (!self) return;
            self.progressLayer.hidden = YES;
            if (stage == JYZWebImageStageFinished) {
                self.scrollView.maximumZoomScale = 3;
                if (image) {
                    self.item.loadedImage = image;
                    [self resizeSubviewSize];
                    [self.imageView.layer addFadeAnimationWithDuration:0.1 curve:UIViewAnimationCurveLinear];
                    if (self.item.loadedBlock) {
                        self.item.loadedBlock(image);
                    }
                }
            }
        }];
    }
    
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _imageContainerView.frame = frame;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.frame.size.height / self.frame.size.width) {
        frame.size.height = floor(image.size.height / (image.size.width / self.frame.size.width));
        _imageContainerView.frame = frame;
    } else {
        CGFloat height = image.size.height / image.size.width * self.frame.size.width;
        if (height < 1 || isnan(height)) height = self.frame.size.height;
        height = floor(height);
        frame.size.height = height;
        _imageContainerView.frame = frame;
        _imageContainerView.center = CGPointMake(_imageContainerView.center.x, self.frame.size.height / 2);
    }
    if (_imageContainerView.frame.size.height > self.frame.size.height && _imageContainerView.frame.size.height - self.frame.size.height <= 1) {
        frame.size.height = self.frame.size.height;
        _imageContainerView.frame = frame;
    }
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width, MAX(_imageContainerView.frame.size.height, self.frame.size.height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.frame.size.height <= self.frame.size.height) {
        self.scrollView.alwaysBounceVertical = NO;
    } else {
        self.scrollView.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)reloadData:(ReuseScrollView *)scrollView item:(id)item {
    self.item = item;
}

@end

@interface PhotoGroupView() <UIScrollViewDelegate, UIGestureRecognizerDelegate, ReuseScrollViewProtocol>

@property (retain, nonatomic) ReuseScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation PhotoGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initUI];
    
    return self;
}

- (void)initUI  {
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    _scrollView.reuseDelegate = self;
    _scrollView.padding = 20;
    _scrollView.clipsToBounds = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];

    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
}

- (void)setGroupItems:(NSArray<PhotoGroupItem *> *)groupItems {
    _groupItems = groupItems;
    self.scrollView.items = groupItems;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.scrollView.index = index;
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    PhotoGroupCell *cell = [[PhotoGroupCell alloc] init];
    return cell;
}

- (void)reuseScrollViewDidEndDragging:(ReuseScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat lastCellOffsetX = (scrollView.cellSize.width + scrollView.padding) * (self.groupItems.count - 1);
        if (scrollView.currentPage == self.groupItems.count - 1 && offsetX > lastCellOffsetX) {
            if ([_delegate respondsToSelector:@selector(photoGrouopViewWillLoadMore:)]) {
                [_delegate photoGrouopViewWillLoadMore:self];
            }
        }
    }
}

- (void)reuseScrollViewDidChangePage:(ReuseScrollView *)scrollView toPage:(NSInteger)toPage {
    if ([_delegate respondsToSelector:@selector(photoGrouopViewDidChangePage:toPage:)]) {
        [_delegate photoGrouopViewDidChangePage:self toPage:toPage];
    }
}

#pragma mark - gesture
- (void)onSingleTap {
    if ([_delegate respondsToSelector:@selector(photoGrouopViewDidSingleTap:)]) {
        [_delegate photoGrouopViewDidSingleTap:self];
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)g {
    PhotoGroupCell *cell = (PhotoGroupCell *)[self.scrollView cellForPage:self.scrollView.currentPage];
    UIScrollView *subscrollView = cell.scrollView;
    
    if (subscrollView.zoomScale > 1) {
        [subscrollView setZoomScale:1.0 animated:YES];
    } else {
        UIImageView *imgView = cell.imageView;
        CGPoint touchPoint = [g locationInView:imgView];
        CGFloat newZoomScale = subscrollView.maximumZoomScale;
        CGFloat xsize = subscrollView.frame.size.width / newZoomScale;
        CGFloat ysize = subscrollView.frame.size.height / newZoomScale;
        [subscrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

@end

@interface PhotoGroupAnimationView() <PhotoGroupViewProtocol>

@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, retain) UIImage *snapshotImage;
@property (nonatomic, retain) UIImage *snapshorImageHideFromView;

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIImageView *blurBackground;

@property (nonatomic, retain) UILabel *pagerLabel;
@property (nonatomic, assign) CGFloat pagerCurrentPage;

@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;

@end

@implementation PhotoGroupAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect rect = !CGRectIsEmpty(frame) ? frame : CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self = [super initWithFrame:rect];
    [self initUI];
    
    return self;
}

- (void)initUI  {
    [super initUI];
    self.delegate = self;
    _blurEffectBackground = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    _panGesture = pan;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _pagerLabel = [[UILabel alloc] init];
    _pagerLabel.textColor = [UIColor whiteColor];
    _pagerLabel.textAlignment = NSTextAlignmentCenter;
    _pagerLabel.userInteractionEnabled = NO;
    _pagerLabel.frame = CGRectMake(0, 0, self.frame.size.width - 36, 20);
    _pagerLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 24);
    _pagerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:_pagerLabel];
    
    [self insertSubview:_background belowSubview:self.contentView];
    [self insertSubview:_blurBackground belowSubview:self.contentView];
}

#pragma mark - delegate
- (void)reuseScrollViewDidEndDragging:(ReuseScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self hidePager];
    }
}

- (void)reuseScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}

- (void)reuseScrollViewDidChangePage:(ReuseScrollView *)scrollView toPage:(NSInteger)toPage {
    [self updatePagerText:toPage];
    [self showPager:YES];
}

- (void)onSingleTap {
    [self dismissAnimated:YES completion:nil];
}

#pragma mark - show / hide
- (void)presentFromImageView:(UIView *)fromView
               fromItemIndex:(NSInteger)fromItemIndex
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) return;
    
    _fromView = fromView;
    _fromItemIndex = fromItemIndex;
    _toContainerView = toContainer;
    
    [self.scrollView setIndex:fromItemIndex];
    
    _snapshotImage = [_toContainerView snapshotImage:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
    _background.image = _snapshorImageHideFromView;
    if (_blurEffectBackground) {
        _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark]; //Same to UIBlurEffectStyleDark
    } else {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
    }

    CGRect frame = self.frame;
    frame.size = _toContainerView.frame.size;
    self.frame = frame;
    _blurBackground.alpha = 0;
    _pagerLabel.alpha = 0;
    [_toContainerView addSubview:self];
    [self layoutIfNeeded];
    [self updatePagerText:fromItemIndex];

    [UIView setAnimationsEnabled:YES];
    _fromNavigationBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    
    PhotoGroupCell *cell = (PhotoGroupCell *)[self.scrollView cellForPage:_fromItemIndex];
    PhotoGroupItem *item = self.groupItems[_fromItemIndex];
    
    if (item.thumbClippedToTop) {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.scrollView];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.frame.size.width;
        
        CGRect frame = cell.imageContainerView.frame;
        frame.size.height = fromFrame.size.height / scale;
        cell.imageContainerView.frame = frame;
        [cell.imageContainerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
        cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMidY(fromFrame));
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        self.scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell.imageContainerView.layer setValue:@(1) forKeyPath:@"transform.scale"];
            cell.imageContainerView.frame = originFrame;
            [self showPager:NO];
        }completion:^(BOOL finished) {
            _isPresented = YES;
            [self.scrollView scrollViewDidScroll:self.scrollView];
            self.scrollView.userInteractionEnabled = YES;
            [self hidePager];
            if (completion) completion();
        }];
        
    } else {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
        
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = animated ? 0.18 : 0;
        [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        self.scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            [cell.imageView.layer setValue:@(1.01) forKeyPath:@"transform.scale"];
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                [cell.imageView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
                [self showPager:NO];
            } completion:^(BOOL finished) {
                cell.imageContainerView.clipsToBounds = YES;
                _isPresented = YES;
                [self.scrollView scrollViewDidScroll:self.scrollView];
                self.scrollView.userInteractionEnabled = YES;
                [self hidePager];
                if (completion) completion();
            }];
        }];
    }

}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    NSInteger currentPage = self.scrollView.currentPage;
    
    PhotoGroupCell *cell = (PhotoGroupCell *)[self.scrollView cellForPage:currentPage];
    PhotoGroupItem *item = self.groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    if (fromView == nil) {
        self.background.image = _snapshotImage;
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            [self.scrollView.layer setValue:@(0.95) forKeyPath:@"transform.scale"];
            self.scrollView.alpha = 0;
            _pagerLabel.alpha = 0;
            _blurBackground.alpha = 0;
        }completion:^(BOOL finished) {
            [self.scrollView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            [self removeFromSuperview];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (_fromItemIndex != currentPage) {
        _background.image = _snapshotImage;
        [_background.layer addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut];
    } else {
        _background.image = _snapshorImageHideFromView;
    }
    
    if (isFromImageClipped) {
        CGPoint off = cell.scrollView.contentOffset;
        off.y = 0 - cell.scrollView.contentInset.top;
        [cell.scrollView setContentOffset:off animated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        _pagerLabel.alpha = 0.0;
        _blurBackground.alpha = 0.0;
        if (isFromImageClipped) {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.scrollView];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.frame.size.width * cell.scrollView.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.frame.size.width;
            if (isnan(height)) height = cell.imageContainerView.frame.size.height;
            
            CGRect frame = cell.imageContainerView.frame;
            frame.size.height = height;
            cell.imageContainerView.frame = frame;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            [cell.imageContainerView.layer setValue:@(scale) forKeyPath:@"transform.scale"];
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
}

- (void)updatePagerText:(NSInteger)toPage {
    _pagerLabel.text = [NSString stringWithFormat:@"%@ / %@", @(toPage + 1), @(self.groupItems.count)];
}

- (void)hidePager {
    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pagerLabel.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}

- (void)showPager:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.3 : 0.0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pagerLabel.alpha = self.groupItems.count > 1 ? 1 : 0;
    }completion:^(BOOL finish) {
    }];
}

- (void)cancelAllImageLoad {
    [self.scrollView.cells enumerateObjectsUsingBlock:^(PhotoGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView cancelCurrentImageRequest];
    }];
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            CGRect frame = self.scrollView.frame;
            frame.origin.y = deltaY;
            self.scrollView.frame = frame;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = MIN(1, MAX(alpha, 0));
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _blurBackground.alpha = alpha;
                _pagerLabel.alpha = self.groupItems.count > 1 ? alpha : 0;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                [self cancelAllImageLoad];
                _isPresented = NO;
                [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationFade];
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                
                CGRect frame = self.scrollView.frame;
                CGFloat duration = (moveToTop ? CGRectGetMaxY(frame) : self.frame.size.height - frame.origin.y) / vy;
                duration *= 0.8;
                duration = MIN(0.3, MAX(duration, 0.05));
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _blurBackground.alpha = 0;
                    _pagerLabel.alpha = 0;
                    
                    CGRect frame = self.scrollView.frame;
                    if (moveToTop) {
                        frame.origin.y = 0 - frame.size.height;
                        self.scrollView.frame = frame;
                    } else {
                        frame.origin.y = self.frame.size.height;
                        self.scrollView.frame = frame;
                    }
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
                
                _background.image = _snapshotImage;
                [_background.layer addFadeAnimationWithDuration:0.3 curve:UIViewAnimationCurveEaseInOut];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    CGRect frame = self.scrollView.frame;
                    frame.origin.y = 0;
                    self.scrollView.frame = frame;
                    _blurBackground.alpha = 1;
                    [self showPager:NO];
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            CGRect frame = self.scrollView.frame;
            frame.origin.y = 0;
            self.scrollView.frame = frame;
            _blurBackground.alpha = 1;
        }
        default:break;
    }
}

@end

