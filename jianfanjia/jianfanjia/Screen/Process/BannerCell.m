//
//  BannerCellTableViewCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BannerCell.h"
#import "ProcessViewController.h"

@interface BannerCell()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation BannerCell

- (void)awakeFromNib {
    UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerCellHeight)];
    [w1 setContentMode:UIViewContentModeScaleToFill];
    w1.image = [UIImage imageNamed:@"banner_1"];
    
    UIImageView *w2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kBannerCellHeight)];
    [w2 setContentMode:UIViewContentModeScaleToFill];
    w2.image = [UIImage imageNamed:@"banner_2"];
    
    UIImageView *w3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kBannerCellHeight)];
    [w3 setContentMode:UIViewContentModeScaleToFill];
    w3.image = [UIImage imageNamed:@"banner_3"];

    UIImageView *w4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, kBannerCellHeight)];
    [w4 setContentMode:UIViewContentModeScaleToFill];
    w4.image = [UIImage imageNamed:@"banner_4"];
    
    [self.scrollView addSubview:w1];
    [self.scrollView addSubview:w2];
    [self.scrollView addSubview:w3];
    [self.scrollView addSubview:w4];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *4, kBannerCellHeight)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - scroll view deleaget
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = self.scrollView.contentOffset.x/kScreenWidth;
    self.pageControl.currentPage = index;
}

@end
