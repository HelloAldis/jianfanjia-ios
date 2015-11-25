//
//  FavoriteDesignerData.h
//  jianfanjia
//
//  Created by JYZ on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteDesignerData : NSObject

@property (strong, nonatomic) NSMutableArray *designers;

- (NSInteger)refreshDesigner;
- (NSInteger)loadMoreDesigner;

@end
