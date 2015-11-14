//
//  ImageDetailViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ImageDetailViewController.h"

@interface ImageDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblIndex;

@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@end

@implementation ImageDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageViewArray = [[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [w1 setContentMode:UIViewContentModeScaleAspectFit];
        [w1 setImageWithId:[self.imageArray objectAtIndex:i]];
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
    }
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth * self.imageArray.count, kBannerCellHeight)];
    self.lblIndex.text = [NSString stringWithFormat:@"%d/%d", self.index + 1, self.imageArray.count];
    self.scrollView.contentOffset = CGPointMake(self.index * kScreenWidth, 0);
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.scrollView addGestureRecognizer:self.tap];
}

#pragma mark - scroll view deleaget
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.index = self.scrollView.contentOffset.x/kScreenWidth;
        self.lblIndex.text = [NSString stringWithFormat:@"%d/%d", self.index + 1, self.imageArray.count];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return [self.imageViewArray objectAtIndex:self.index];
    } else {
        return nil;
    }
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//}

#pragma mark - user action 
- (void)onTap {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}




@end
