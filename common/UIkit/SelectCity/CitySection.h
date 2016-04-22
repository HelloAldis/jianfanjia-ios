//
//  SectionView.h
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat kCitySectionHeight;

@interface CitySection : UIView

@property (weak, nonatomic) IBOutlet UILabel *label;

+ (CitySection *)citySection;


@end
