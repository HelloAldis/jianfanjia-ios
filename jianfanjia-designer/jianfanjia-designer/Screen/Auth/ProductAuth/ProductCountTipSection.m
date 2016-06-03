//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductCountTipSection.h"

@implementation ProductCountTipSection

+ (ProductCountTipSection *)productCountTipSection {
    return [[NSBundle mainBundle] loadNibNamed:@"ProductCountTipSection" owner:nil options:nil].lastObject;
}

@end
