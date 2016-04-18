//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanPriceItemSection.h"

@implementation PlanPriceItemSection

+ (UIView *)sectionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PlanPriceItemSection" owner:nil options:nil] lastObject];
}

@end
