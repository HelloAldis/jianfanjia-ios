//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateDiarySetCell.h"
#import "ViewControllerContainer.h"

CGFloat kFavoriateDiarySetCellHeight;

@interface FavoriateDiarySetCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *btnPhase;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblStarCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

@property (strong, nonatomic) DiarySet *diarySet;
@property (nonatomic, copy) DiarySetCellDeleteBlock deleteBlock;

@end

@implementation FavoriateDiarySetCell

+ (void)initialize {
    if ([self class] == [FavoriateDiarySetCell class]) {
        CGFloat aspect =  1176 / kScreenWidth;
        kFavoriateDiarySetCellHeight = round(612 / aspect);
    }
}

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
    [self.barView setCornerRadius:self.barView.frame.size.height / 2];
    [self.btnPhase setCornerRadius:self.btnPhase.frame.size.height / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kFavoriateDiarySetCellHeight);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithR:0x00 g:0x00 b:0x00 a:0.3] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    gradient.startPoint = CGPointMake(0.5, 1.0);
    gradient.endPoint = CGPointMake(0.5, 0.0);
    gradient.locations = @[@0.15, @1.0];
    [self.productImageView.layer addSublayer:gradient];
}

- (void)initWithDiarySet:(DiarySet *)diarySet edit:(BOOL)edit deleteBlock:(DiarySetCellDeleteBlock)deleteBlock {
    self.diarySet = diarySet;
    self.deleteBlock = deleteBlock;
    
    [self.productImageView setImageWithId:diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"]];
    self.lblCell.text = diarySet.title;
    self.lblDetail.text = [DiaryBusiness diarySetInfo:diarySet];
    self.lblViewCount.text = [diarySet.view_count humCountString];
    self.lblStarCount.text = diarySet.favorite_count ? [diarySet.favorite_count humCountString] : @"0";
    [self.btnPhase setNormTitle:[NSString stringWithFormat:@"%@阶段", diarySet.latest_section_label ? diarySet.latest_section_label : @"准备"]];
    [self.btnPhase setBgColor:[DiaryBusiness colorForPhase:diarySet]];
}

- (void)onTap {
    [ViewControllerContainer showDiarySetDetail:self.diarySet fromNewDiarySet:NO];
}

@end
