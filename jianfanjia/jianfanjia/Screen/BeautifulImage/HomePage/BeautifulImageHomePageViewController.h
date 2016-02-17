//
//  ImageDetailViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@class BeautifulImageDataManager;

typedef void(^HomePageDismissBlock)(NSInteger index);

@protocol BeautifulImageHomePageDataManagerProtocol <NSObject>

@required
- (NSMutableArray *)beautifulImages;
- (NSInteger)loadMoreBeautifulImages;

@end

@interface BeautifulImageHomePageViewController : BaseViewController<UIScrollViewDelegate>

- (id)initWithDataManager:(id<BeautifulImageHomePageDataManagerProtocol>)dataManager index:(NSInteger)index queryDic:(NSDictionary *)queryDic dismissBlock:(HomePageDismissBlock)dismissBlock;

@end
