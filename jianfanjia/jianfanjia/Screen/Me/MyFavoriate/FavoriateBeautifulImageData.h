//
//  FavoriateBeautifulImageData.h
//  jianfanjia
//
//  Created by JYZ on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeautifulImageHomePageProtocol.h"

@interface FavoriateBeautifulImageData : NSObject <BeautifulImageHomePageDataManagerProtocol>

@property (strong, nonatomic) NSMutableArray *beautifulImages;
@property (nonatomic, assign) NSInteger total;

- (NSInteger)refreshBeautifulImages;
- (NSInteger)loadMoreBeautifulImages;

@end
