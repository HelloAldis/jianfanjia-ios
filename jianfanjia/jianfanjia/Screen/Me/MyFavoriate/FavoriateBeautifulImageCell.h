//
//  FavoriateBeautifulImageCell.h
//  jianfanjia
//
//  Created by JYZ on 15/12/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavoriateViewController.h"

@interface FavoriateBeautifulImageCell : UICollectionViewCell

- (void)initWithImage:(BeautifulImage *)beautifulImage withDeleteBlock:(DeleteFavoriateBeautifulImageBlock)block;

@end
