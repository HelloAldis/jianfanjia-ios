//
//  FavoriateProductData.h
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriateDiarySetData : NSObject

@property (nonatomic, strong) NSMutableArray *diarySets;
- (NSInteger)refreshDiarySets;
- (NSInteger)loadMoreDiarySets;

@end
