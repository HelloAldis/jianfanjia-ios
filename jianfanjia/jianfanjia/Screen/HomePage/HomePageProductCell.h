//
//  BannerCellTableViewCell.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageProductItem.h"

#define kHomePageProductCellHeight (kHomePageProductItemHeight + 40)

@interface HomePageProductCell : UITableViewCell

@property (nonatomic, assign) BOOL isShowProduct;

- (void)initWithProducts:(NSArray *)products;

@end
