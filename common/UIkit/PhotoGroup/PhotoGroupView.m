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
@property (nonatomic, strong) UIImage *UIImage;

@end

@implementation PhotoGroupItem

@end

@interface PhotoGroupCell : ReuseCell <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) PhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;
@end

@implementation PhotoGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.bouncesZoom = YES;
    _scrollView.maximumZoomScale = 3;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [YYAnimatedImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [_imageContainerView addSubview:_imageView];
    
    CGRect frame = CGRectMake(0, 0, 40, 40);
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = frame;
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
    [_scrollView.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(_scrollView.frame.size.width / 2, _scrollView.frame.size.height / 2);
    CGRect frame = _progressLayer.frame;
    frame.origin.x = center.x - frame.size.width * 0.5;
    frame.origin.y = center.y - frame.size.height * 0.5;
    _progressLayer.frame = frame;
}

- (void)setItem:(PhotoGroupItem *)item {
    if (_item == item) return;
    _item = item;
    _itemDidLoad = NO;
    
    
    [_scrollView setZoomScale:1.0 animated:NO];
    _scrollView.maximumZoomScale = 1;
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
    
    @weakify(self);
    [_imageView setImageWithId:item.imageid withWidth:kScreenWidth completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
        @strongify(self);
        self.progressLayer.hidden = YES;
        if (error == nil) {
            self->_itemDidLoad = YES;
            [self resizeSubviewSize];
            if (self.item.loadedBlock) {
                self.item.loadedBlock(image);
            }
        }
    }];
    
    [self resizeSubviewSize];
}

- (void)resizeSubviewSize {
    CGRect frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    _imageContainerView.frame = frame;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > _scrollView.frame.size.height / _scrollView.frame.size.width) {
        frame.size.height = floor(image.size.height / (image.size.width / _scrollView.frame.size.width));
        _imageContainerView.frame = frame;
    } else {
        CGFloat height = image.size.height / image.size.width * _scrollView.frame.size.width;
        if (height < 1 || isnan(height)) height = _scrollView.frame.size.height;
        height = floor(height);
        frame.size.height = height;
        frame.origin.y = _scrollView.frame.size.height / 2;
        _imageContainerView.frame = frame;
    }
    if (_imageContainerView.frame.size.height > _scrollView.frame.size.height && _imageContainerView.frame.size.height - _scrollView.frame.size.height <= 1) {
        frame.size.height = _scrollView.frame.size.height;
        _imageContainerView.frame = frame;
    }
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, MAX(_imageContainerView.frame.size.height, _scrollView.frame.size.height));
    [_scrollView scrollRectToVisible:_scrollView.bounds animated:NO];
    
    if (_imageContainerView.frame.size.height <= _scrollView.frame.size.height) {
        _scrollView.alwaysBounceVertical = NO;
    } else {
        _scrollView.alwaysBounceVertical = YES;
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
    _item = item;
}

@end

@interface PhotoGroupView() <UIScrollViewDelegate, UIGestureRecognizerDelegate, ReuseScrollViewProtocol>

@property (strong, nonatomic) ReuseScrollView *scrollView;

@end

@implementation PhotoGroupView

- (instancetype)initWithGroupItems:(NSArray *)groupItems {
    self = [super init];
    if (groupItems.count == 0) return nil;
    
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.items = self.groupItems;
    self.scrollView.index = self.index;
    self.scrollView.reuseDelegate = self;
    self.scrollView.padding = 20;
    self.scrollView.clipsToBounds = NO;
    [self addSubview:self.scrollView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    return self;
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    PhotoGroupCell *cell = [[PhotoGroupCell alloc] init];
    return cell;
}

- (void)reuseScrollViewPageDidChange:(ReuseScrollView *)scrollView toPage:(NSInteger)toPage {

}

#pragma mark - gesture
- (void)onSingleTap {

}

- (void)onDoubleTap:(UITapGestureRecognizer *)g {
    PhotoGroupCell *cell = (PhotoGroupCell *)[self.scrollView cellForPage:self.scrollView.currentPage];
    UIScrollView *subscrollView = cell.scrollView;
    
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

@end

