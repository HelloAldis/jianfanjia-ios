//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView

+ (SectionView *)sectionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:nil options:nil] lastObject];
}

@end
