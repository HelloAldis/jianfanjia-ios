//
//  SearchPrettyImage.h
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"
#import "BeautifulImageHomePageProtocol.h"

@interface SearchBeautifulImage : BaseRequest <BeautifulImageHomePageLoadMoreRequestProtocol>

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) NSDictionary *sort;
@property (nonatomic, strong) NSString *search_word;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *limit;

@end
