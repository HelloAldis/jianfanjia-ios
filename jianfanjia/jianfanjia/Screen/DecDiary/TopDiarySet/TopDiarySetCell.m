//
//  DecorationStyleCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TopDiarySetCell.h"

@interface TopDiarySetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblStarCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIImageView *viewImgView;
@property (weak, nonatomic) IBOutlet UIImageView *starImgView;

@property (strong, nonatomic) DiarySet *diarySet;

@end

@implementation TopDiarySetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setCornerRadius:3];
    [self setBorder:1.0 andColor:[UIColor colorWithR:0xE6 g:0xE7 b:0xE8].CGColor];
    [self.barView setCornerRadius:self.barView.frame.size.height / 2];
}

#pragma mark - init data
- (void)initWithDiarySet:(DiarySet *)diarySet {
    self.diarySet = diarySet;
    
    [self.coverImageView setImageWithId:diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"]];
    self.lblCell.text = diarySet.title;
    self.lblDetail.text = [DiaryBusiness diarySetInfo:diarySet];
    [self.lblDetail setRowSpace:5];
    self.lblViewCount.text = [diarySet.view_count humCountString];
    self.lblStarCount.text = diarySet.favorite_count ? [diarySet.favorite_count humCountString] : @"0";
}

@end
