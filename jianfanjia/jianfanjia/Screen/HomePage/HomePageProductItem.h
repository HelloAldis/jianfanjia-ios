//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHomePageProductItemHeight (kScreenHeight - 64 - 44)

@interface HomePageProductItem : UICollectionViewCell

- (void)initWithProduct:(Product *)product;

@end


