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

@property (nonatomic, strong) UIImage *loadedImage;

@end

@implementation PhotoGroupItem

@end

@interface PhotoGroupCell : ReuseCell <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) PhotoGroupItem *item;

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
    _imageView.frame = self.bounds;
    [_imageContainerView addSubview:_imageView];
    
    return self;
}

- (void)setItem:(PhotoGroupItem *)item {
    if (_item == item) return;
    _item = item;
    _item.loadedImage = nil;
    
    [_scrollView setZoomScale:1.0 animated:NO];
    _scrollView.maximumZoomScale = 1;
    
    @weakify(self);
    [_imageView setImageWithId:_item.imageid withWidth:self.bounds.size.width completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
        @strongify(self);
        if (error == nil) {
            self.scrollView.maximumZoomScale = 3;
            self.item.loadedImage = image;
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
        frame.origin.y = (_scrollView.frame.size.height - height)/ 2;
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
    self.item = item;
}

@end

@interface PhotoGroupView() <UIScrollViewDelegate, UIGestureRecognizerDelegate, ReuseScrollViewProtocol>

@property (strong, nonatomic) ReuseScrollView *scrollView;

@end

@implementation PhotoGroupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initUI];
    
    return self;
}

- (void)initUI  {
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.scrollView.reuseDelegate = self;
    self.scrollView.padding = 20;
    self.scrollView.clipsToBounds = YES;
    [self addSubview:self.scrollView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
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

