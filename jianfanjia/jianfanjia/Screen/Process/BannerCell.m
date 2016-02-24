//
//  BannerCellTableViewCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BannerCell.h"

CGFloat kBannerCellHeight;

@interface BannerCell()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray *imgViews;
@property (strong, nonatomic) NSMutableArray *imgs;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation BannerCell

+ (void)initialize {
    if ([self class] == [BannerCell class]) {
        CGFloat aspect =  414.0 / kScreenWidth;
        kBannerCellHeight = round(173 / aspect);
    }
}

- (void)awakeFromNib {
    CGFloat height = kBannerCellHeight;
    self.imgs = [NSMutableArray array];
    [self.imgs addObject:@"banner_1"];
    [self.imgs addObject:@"banner_2"];
    
    self.imgViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        
        [self.scrollView addSubview:imgView];
        [self.imgViews addObject:imgView];
    }

    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * 3, height)];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.pageControl.numberOfPages = self.imgs.count;
    [self reloadAllImage];
}

#pragma mark - util
- (void)reloadAllImage {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    
    if (offsetX > kScreenWidth) { // 向右
        self.index++;
    } else if (offsetX < kScreenWidth) { // 向左
        self.index--;
    } else {
        
    }

    if (self.index < 0) {
        self.index = self.imgs.count - 1;
    } else if (self.index > self.imgs.count - 1) {
        self.index = 0;
    }

    NSString *preImg = self.imgs[self.index - 1 >= 0 ? self.index - 1 : self.imgs.count - 1];
    NSString *curImg = self.imgs[self.index];
    NSString *nextImg = self.imgs[self.index + 1 < self.imgs.count ? self.index + 1 : 0];
    
    UIImageView *preImgView = self.imgViews[0];
    UIImageView *centerImgView = self.imgViews[1];
    UIImageView *nextImgView = self.imgViews[2];
    
    preImgView.image = [UIImage imageNamed:preImg];
    centerImgView.image = [UIImage imageNamed:curImg];
    nextImgView.image = [UIImage imageNamed:nextImg];
    
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.pageControl.currentPage = self.index;
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(fireTimer) userInfo:nil repeats:NO];
    }
}

- (void)fireTimer {
    [UIView animateWithDuration:0.75 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 2, 0) animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
            [self reloadAllImage];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(fireTimer) userInfo:nil repeats:NO];
        }
    }];
}

#pragma mark - scroll view deleaget
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
    self.timer = nil;
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

@end
