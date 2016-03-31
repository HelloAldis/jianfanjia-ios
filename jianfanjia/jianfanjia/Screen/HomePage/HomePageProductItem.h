//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHomePageProductItemHeight (kScreenHeight - kNavWithStatusBarHeight - kTabBarHeight)

@interface HomePageProductItem : UICollectionViewCell

- (void)initWithProduct:(Product *)product;

@end


