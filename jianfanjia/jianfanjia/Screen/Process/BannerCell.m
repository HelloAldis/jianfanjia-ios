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

@end

@implementation BannerCell

- (void)awakeFromNib {
    UIImageView *w1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_CELL_HEIGHT)];
    [w1 setContentMode:UIViewContentModeScaleToFill];
    w1.image = [UIImage imageNamed:@"banner_1"];
    
    UIImageView *w2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, BANNER_CELL_HEIGHT)];
    [w2 setContentMode:UIViewContentModeScaleToFill];
    w2.image = [UIImage imageNamed:@"banner_2"];
    
    UIImageView *w3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, BANNER_CELL_HEIGHT)];
    [w3 setContentMode:UIViewContentModeScaleToFill];
    w3.image = [UIImage imageNamed:@"banner_3"];

    UIImageView *w4 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, BANNER_CELL_HEIGHT)];
    [w4 setContentMode:UIViewContentModeScaleToFill];
    w4.image = [UIImage imageNamed:@"banner_4"];
    
    [self.scrollView addSubview:w1];
    [self.scrollView addSubview:w2];
    [self.scrollView addSubview:w3];
    [self.scrollView addSubview:w4];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH *4, BANNER_CELL_HEIGHT)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
