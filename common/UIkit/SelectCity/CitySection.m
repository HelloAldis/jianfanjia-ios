//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "CitySection.h"

const CGFloat kCitySectionHeight = 30;

@implementation CitySection

+ (CitySection *)citySection {
    return [[[NSBundle mainBundle] loadNibNamed:@"CitySection" owner:nil options:nil] lastObject];
}

@end
