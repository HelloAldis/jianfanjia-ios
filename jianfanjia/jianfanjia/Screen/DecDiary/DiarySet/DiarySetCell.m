//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetCell.h"
#import "ViewControllerContainer.h"

CGFloat kDiarySetCellHeight;

@interface DiarySetCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *btnPhase;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (strong, nonatomic) DiarySet *diarySet;
@property (nonatomic, copy) DiarySetCellDeleteBlock deleteBlock;

@end

@implementation DiarySetCell

+ (void)initialize {
    if ([self class] == [DiarySetCell class]) {
        CGFloat aspect =  1176 / kScreenWidth;
        kDiarySetCellHeight = round(612 / aspect);
    }
}

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
    [self.barView setCornerRadius:self.barView.frame.size.height / 2];
    [self.btnPhase setCornerRadius:self.btnPhase.frame.size.height / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initWithDiarySet:(DiarySet *)diarySet edit:(BOOL)edit deleteBlock:(DiarySetCellDeleteBlock)deleteBlock {
    self.diarySet = diarySet;
    self.deleteBlock = deleteBlock;
    
    [self.productImageView setImageWithId:diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"]];
    self.lblCell.text = diarySet.title;
    self.lblDetail.text = [DiaryBusiness diarySetInfo:diarySet];
    self.lblViewCount.text = [diarySet.view_count humCountString];
    [self.btnPhase setNormTitle:[NSString stringWithFormat:@"%@阶段", diarySet.latest_section_label ? diarySet.latest_section_label : @"准备"]];
    [self.btnPhase setBgColor:[DiaryBusiness colorForPhase:diarySet]];
}

- (void)onTap {
    [ViewControllerContainer showDiarySetDetail:self.diarySet fromNewDiarySet:NO];
}

@end
