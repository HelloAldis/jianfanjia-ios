//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiarySectionView.h"

@implementation AddDiarySectionView

+ (AddDiarySectionView *)addDiarySectionView {
    return [[NSBundle mainBundle] loadNibNamed:@"AddDiarySectionView" owner:nil options:nil].lastObject;
}

@end
