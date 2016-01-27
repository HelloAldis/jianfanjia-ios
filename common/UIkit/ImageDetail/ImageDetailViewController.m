//
//  ImageDetailViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ImageDetailViewController.h"

typedef NS_ENUM(NSInteger, ImageDetailViewType) {
    ImageDetailViewTypeOffline,
    ImageDetailViewTypeOnline,
    ImageDetailViewTypeOfflineOnline,
};

@interface ImageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (nonatomic, strong) NSArray *offlineImages;
@property (nonatomic, strong) NSArray *onlineImages;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) ImageDetailViewType type;
@property (nonatomic, assign) NSInteger imgCount;

@end

@implementation ImageDetailViewController

#pragma mark - init method
- (id)initWithOffline:(NSArray *)offlineImages index:(NSInteger)index {
    return [self initWithImage:offlineImages online:nil index:index type:ImageDetailViewTypeOffline];
}

- (id)initWithOnline:(NSArray *)onlineImages index:(NSInteger)index {
    return [self initWithImage:nil online:onlineImages index:index type:ImageDetailViewTypeOnline];
}

- (id)initWithOffline:(NSArray *)offlineImages online:(NSArray *)onlineImages index:(NSInteger)index {
    return [self initWithImage:offlineImages online:onlineImages index:index type:ImageDetailViewTypeOfflineOnline];
}

- (id)initWithImage:(NSArray *)offlineImages online:(NSArray *)onlineImages index:(NSInteger)index type:(ImageDetailViewType)type {
    if (self = [super init]) {
        _offlineImages = offlineImages;
        _onlineImages = onlineImages;
        _index = index;
        _type = type;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == ImageDetailViewTypeOffline) {
        self.imgCount = self.offlineImages.count;
    } else if (self.type == ImageDetailViewTypeOnline) {
        self.imgCount = self.onlineImages.count;
    } else {
        
    }
    
    self.imageViewArray = [[NSMutableArray alloc] initWithCapacity:self.imgCount];
    for (int i = 0; i < self.imgCount; i++) {
        UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [w1 setContentMode:UIViewContentModeScaleAspectFit];

        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        s.maximumZoomScale = 3;
        s.minimumZoomScale = 1;
        [s setContentSize:CGSizeMake(kScreenWidth, kScreenHeight)];
        s.bounces = NO;
        s.bouncesZoom = NO;
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        [s addSubview:w1];
        [self.scrollView addSubview:s];
        [self.imageViewArray addObject:w1];
        
        if (self.type == ImageDetailViewTypeOffline) {
            w1.image = [self.offlineImages objectAtIndex:i];
            CGFloat height = kScreenWidth / (w1.image.size.width / w1.image.size.height);
            w1.frame = CGRectMake(0, (kScreenHeight - height) / 2, kScreenWidth, height);
        } else if (self.type == ImageDetailViewTypeOnline) {
            @weakify(w1);
            [w1 setImageWithId:[self.onlineImages objectAtIndex:i] withWidth:kScreenWidth completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
                @strongify(w1);
                if (error == nil) {
                    CGFloat height = kScreenWidth / (image.size.width / image.size.height);
                    w1.frame = CGRectMake(0, (kScreenHeight - height) / 2, kScreenWidth,  height);
                }
            }];
        } else {
            
        }
    }
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * self.imgCount, 200)];
    self.lblIndex.text = [NSString stringWithFormat:@"%@/%@", @(self.index + 1), @(self.imgCount)];
    self.lblIndex.hidden = self.imgCount <= 1;
    self.scrollView.contentOffset = CGPointMake(self.index * kScreenWidth, 0);
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap)];
    [self.scrollView addGestureRecognizer:self.tap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [self.tap requireGestureRecognizerToFail:doubleTap];
}

#pragma mark - scroll view deleaget
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.index = self.scrollView.contentOffset.x/kScreenWidth;
        self.lblIndex.text = [NSString stringWithFormat:@"%@/%@", @(self.index + 1), @(self.imgCount)];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return [self.imageViewArray objectAtIndex:self.index];
    } else {
        return nil;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIScrollView *subscrollView = self.scrollView.subviews[self.index];
    UIImageView *imgView = subscrollView.subviews[0];
    UIView *subView = imgView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - user action 
- (void)onSingleTap {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)g {
    UIScrollView *subscrollView = self.scrollView.subviews[self.index];
    
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
