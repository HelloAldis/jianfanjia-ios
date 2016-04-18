//
//  SectionView.h
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProcessDataManager.h"

extern CGFloat const kUnexpandSectionActionViewHeight;

@interface UnexpandSectionActionView : UIView

@property (weak, nonatomic) IBOutlet UIView *expandView;
@property (weak, nonatomic) IBOutlet UIImageView *expandIcon;

@end
