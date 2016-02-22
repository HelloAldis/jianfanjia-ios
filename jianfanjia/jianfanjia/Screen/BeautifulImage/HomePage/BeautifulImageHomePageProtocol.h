//
//  BeautifulImageHomePageProtocol.h
//  jianfanjia
//
//  Created by Karos on 16/2/22.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#ifndef BeautifulImageHomePageProtocol_h
#define BeautifulImageHomePageProtocol_h

@protocol BeautifulImageHomePageDataManagerProtocol <NSObject>

@required
- (NSMutableArray *)beautifulImages;
- (NSInteger)loadMoreBeautifulImages;

@end

@protocol BeautifulImageHomePageLoadMoreRequestProtocol <NSObject>

@required
- (NSNumber *)from;
- (void)setFrom:(NSNumber *)from;
- (NSNumber *)limit;
- (void)setLimit:(NSNumber *)limit;

@end

#endif /* BeautifulImageHomePageProtocol_h */
