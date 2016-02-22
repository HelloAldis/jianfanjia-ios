//
//  DesignerListDataManager.h
//  jianfanjia
//
//  Created by Karos on 16/2/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeautifulImageHomePageProtocol.h"

@interface SearchBeautifulImageDataManager : NSObject <BeautifulImageHomePageDataManagerProtocol>

@property (nonatomic, strong) NSMutableArray *beautifulImages;

- (NSInteger)refreshBeautifulImages;
- (NSInteger)loadMoreBeautifulImages;

@end
