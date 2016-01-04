//
//  FavoriateProductCell.h
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavoriateViewController.h"

@interface FavoriateProductCell : UITableViewCell

- (void)initWithProduct:(Product *)product andDeleteFavoriateBlock:(DeleteFavoriateProductBlock)block;

@end
