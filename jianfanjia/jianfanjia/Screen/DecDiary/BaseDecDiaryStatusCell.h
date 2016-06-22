//
//  HomePageDesignerCell.h
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseDecDiaryStatusCell : UITableViewCell

@property (weak, nonatomic) NSLayoutConstraint *base_msgHeightConst;
@property (weak, nonatomic) NSLayoutConstraint *base_imgsHeightConst;
@property (weak, nonatomic) YYLabel *base_msgView;
@property (weak, nonatomic) UIView *base_imgsView;
@property (weak, nonatomic) UIView *base_toolbarView;
@property (weak, nonatomic) UIView *base_zanView;
@property (weak, nonatomic) UIImageView *base_zanImgView;
@property (weak, nonatomic) UILabel *base_lblZan;
@property (weak, nonatomic) UIView *base_commentView;
@property (weak, nonatomic) UIImageView *base_commentImgView;
@property (weak, nonatomic) UILabel *base_lblComment;

@property (strong, nonatomic) NSMutableArray *base_picViews;

@property (strong, nonatomic) Diary *diary;

- (void)initImageView;
- (void)layoutMsg;
- (void)layoutImageView;
- (void)initToolbar;

- (void)onClickZan;

@end
