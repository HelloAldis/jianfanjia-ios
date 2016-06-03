//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductAuthDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *products;

- (NSInteger)refresh;
- (NSInteger)loadMore;
- (NSInteger)authedProductCount;

@end
