//
//  MyFavoriateViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^DeleteFavoriateProductBlock)(NSIndexPath *indexPath);
typedef void(^DeleteFavoriateBeautifulImageBlock)(NSIndexPath *indexPath);

@interface MyFavoriateViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@end
