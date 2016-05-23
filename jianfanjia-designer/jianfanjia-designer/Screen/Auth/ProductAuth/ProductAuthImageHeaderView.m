//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthImageHeaderView.h"

@implementation ProductAuthImageHeaderView

+ (ProductAuthImageHeaderView *)productAuthImageHeaderView {
    return [[NSBundle mainBundle] loadNibNamed:@"ProductAuthImageHeaderView" owner:nil options:nil].lastObject;
}

@end
