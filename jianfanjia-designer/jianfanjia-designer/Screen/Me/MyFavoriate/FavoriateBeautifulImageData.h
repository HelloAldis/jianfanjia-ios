//
//  FavoriateBeautifulImageData.h
//  jianfanjia
//
//  Created by JYZ on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriateBeautifulImageData : NSObject

@property (strong, nonatomic) NSMutableArray *beautifulImages;
- (NSInteger)refreshBeautifulImages;
- (NSInteger)loadMoreBeautifulImages;

@end
