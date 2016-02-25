//
//  PrettyPictureDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeautifulImageHomePageProtocol.h"

@interface BeautifulImageDataManager : NSObject <BeautifulImageHomePageDataManagerProtocol>

@property (nonatomic, strong) NSMutableArray *beautifulImages;
@property (nonatomic, assign) NSInteger total;

- (NSInteger)refreshBeautifulImages;
- (NSInteger)loadMoreBeautifulImages;

@end
