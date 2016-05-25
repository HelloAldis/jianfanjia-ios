//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "InfoAuthImageHeaderView.h"

@implementation InfoAuthImageHeaderView

+ (InfoAuthImageHeaderView *)infoAuthImageHeaderView {
    return [[NSBundle mainBundle] loadNibNamed:@"InfoAuthImageHeaderView" owner:nil options:nil].lastObject;
}

@end
