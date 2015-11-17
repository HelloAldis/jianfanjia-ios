//
//  IntentDesignerSection.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "IntentDesignerSection.h"

@implementation IntentDesignerSection

+ (IntentDesignerSection *)sectionView {
    return [[[NSBundle mainBundle] loadNibNamed:@"IntentDesignerSection" owner:nil options:nil] lastObject];
}

@end
