//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TopDiarySetsCell.h"
#import "ReuseScrollView.h"
#import "TopDiarySetView.h"
#import "TouchDelegateView.h"

#define kScrollViewLeft 20
#define kScrollCellPadding 5

CGFloat kTopDiarySetsCellHeight;

@interface TopDiarySetsCell () <ReuseScrollViewProtocol>
@property (weak, nonatomic) IBOutlet TouchDelegateView *containerView;
@property (strong, nonatomic) ReuseScrollView *scrollView;

@property (nonatomic, strong) NSArray *topDiarySets;

@end

@implementation TopDiarySetsCell

+ (void)initialize {
    if ([self class] == [TopDiarySetsCell class]) {
        CGFloat aspect =  1240 / kScreenWidth;
        kTopDiarySetsCellHeight = round(900 / aspect);
    }
}

- (void)awakeFromNib {
    [self setupReuseCells];
}

- (void)initWithDiarySets:(NSArray *)topDiarySets {
    self.topDiarySets = topDiarySets;
    self.scrollView.items = self.topDiarySets;
    [self.scrollView removeFromSuperview];
    [self.containerView addSubview:self.scrollView];
    [self.scrollView scrollViewDidScroll:self.scrollView];
}

- (void)setupReuseCells {
    CGFloat height = kTopDiarySetsCellHeight - 67;
    CGFloat width = height / 707.0 * 540.0;
    
    self.scrollView = [[ReuseScrollView alloc] initWithFrame:CGRectMake(kScrollViewLeft, 0, width, height)];
    self.scrollView.reuseDelegate = self;
    self.scrollView.padding = kScrollCellPadding;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.bounces = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.containerView.touchDelegateView = self.scrollView;
}

#pragma mark - reuse delegate
- (ReuseCell *)reuseCellFactory {
    TopDiarySetView *topDiarySetView = [TopDiarySetView topDiarySetView];
    return topDiarySetView;
}

@end
