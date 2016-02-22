//
//  ListFavoriateBeautilImage.h
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"
#import "BeautifulImageHomePageProtocol.h"

@interface ListFavoriateBeautifulImage : BaseRequest <BeautifulImageHomePageLoadMoreRequestProtocol>

@property (assign, nonatomic) NSNumber *from;
@property (assign, nonatomic) NSNumber *limit;

@end
