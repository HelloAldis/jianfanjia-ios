//
//  DesignerInfoCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TopDiarySetView.h"
#import "ViewControllerContainer.h"

@interface TopDiarySetView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblStarCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (strong, nonatomic) DiarySet *diarySet;

@end

@implementation TopDiarySetView

+ (TopDiarySetView *)topDiarySetView {
    TopDiarySetView *obj = [[[NSBundle mainBundle] loadNibNamed:@"TopDiarySetView" owner:nil options:nil] lastObject];
    [obj initUI];
    
    return obj;
}

#pragma mark - init ui
- (void)initUI {
    [self setCornerRadius:3];
    [self setBorder:0.5 andColor:[UIColor colorWithR:0xE6 g:0xE7 b:0xE8].CGColor];
    [self.barView setCornerRadius:self.barView.frame.size.height / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

#pragma mark - init data
- (void)initWithDiarySet:(DiarySet *)diarySet {
    self.diarySet = diarySet;
    
    [self.coverImageView setImageWithId:diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"]];
    self.lblCell.text = diarySet.title;
    self.lblDetail.text = [DiaryBusiness diarySetInfo:diarySet];
    self.lblViewCount.text = [diarySet.view_count humCountString];
    self.lblStarCount.text = diarySet.favorite_count ? [diarySet.favorite_count humCountString] : @"0";
}

#pragma mark - reload data
- (void)reloadData:(ReuseScrollView *)scrollView item:(id)item {
    [self initWithDiarySet:item];
}

#pragma mark - user action
- (void)onTap {
    [ViewControllerContainer showDiarySetDetail:self.diarySet fromNewDiarySet:NO];
}

@end
