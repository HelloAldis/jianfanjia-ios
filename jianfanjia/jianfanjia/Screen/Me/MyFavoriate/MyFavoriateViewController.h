//
//  MyFavoriateViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"
#import "CollectionFallsFlowLayout.h"

@class FavoriateBeautifulImageCell;
@class FavoriateProductCell;

typedef void(^DeleteFavoriateProductBlock)(FavoriateProductCell *indexPath);
typedef void(^DeleteFavoriateBeautifulImageBlock)(FavoriateBeautifulImageCell *indexPath);

@interface MyFavoriateViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, CollectionFallsFlowLayoutProtocol>

@end
