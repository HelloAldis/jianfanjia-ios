//
//  ItemsBackgroundView.m
//  jianfanjia
//
//  Created by Karos on 15/12/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ItemsBackgroundView.h"

@implementation ItemsBackgroundView

+ (ItemsBackgroundView *)itemsBackgroundView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ItemsBackgroundView" owner:nil options:nil] lastObject];
}

@end
