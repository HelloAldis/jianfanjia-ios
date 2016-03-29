//
//  SectionView.h
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kSectionViewWidth;
extern const CGFloat kSectionViewHeight;

@interface SectionView : UIView

@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

+ (SectionView *)sectionView;


@end
