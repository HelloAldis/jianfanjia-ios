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
    NSInteger height = kBannerCellHeight;
    UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    [w1 setContentMode:UIViewContentModeScaleAspectFill];
    [w1 setClipsToBounds:YES];
    w1.image = [UIImage imageNamed:@"banner_1"];
    w1.backgroundColor = [UIColor whiteColor];
    
    UIImageView *w2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, height)];
    [w2 setContentMode:UIViewContentModeScaleAspectFill];
    [w2 setClipsToBounds:YES];
    w2.image = [UIImage imageNamed:@"banner_2"];
    w2.backgroundColor = [UIColor whiteColor];
    
    UIImageView *w3 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, height)];
    [w3 setContentMode:UIViewContentModeScaleAspectFill];
    [w3 setClipsToBounds:YES];
    w3.image = [UIImage imageNamed:@"banner_3"];
    w3.backgroundColor = [UIColor whiteColor];

    UIImageView *w4 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, height)];
    [w4 setContentMode:UIViewContentModeScaleAspectFill];
    [w4 setClipsToBounds:YES];
    w4.image = [UIImage imageNamed:@"banner_4"];
    w4.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:w1];
    [self.scrollView addSubview:w2];
    [self.scrollView addSubview:w3];
    [self.scrollView addSubview:w4];
    [self.scrollView setContentSize:CGSizeMake(kScreenWidth *4, height)];
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
