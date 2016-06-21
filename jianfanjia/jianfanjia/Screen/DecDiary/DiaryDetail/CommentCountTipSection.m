//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "CommentCountTipSection.h"

@implementation CommentCountTipSection

+ (CommentCountTipSection *)commentCountTipSection {
    return [[NSBundle mainBundle] loadNibNamed:@"CommentCountTipSection" owner:nil options:nil].lastObject;
}

@end
