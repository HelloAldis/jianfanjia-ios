//
//  MatchDesignerSection.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MatchDesignerSection.h"

@implementation MatchDesignerSection

+ (MatchDesignerSection *)sectionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"MatchDesignerSection" owner:nil options:nil] lastObject];
}

@end
