//
//  FavoriateProductData.h
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriateProductData : NSObject

@property (strong, nonatomic) NSMutableArray *products;
- (NSInteger)refreshProduct;
- (NSInteger)loadMoreProduct;

@end
