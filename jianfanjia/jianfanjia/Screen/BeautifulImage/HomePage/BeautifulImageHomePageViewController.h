//
//  ImageDetailViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"
#import "BeautifulImageHomePageProtocol.h"

@class BeautifulImageDataManager;

typedef void(^HomePageDismissBlock)(NSInteger index);

@interface BeautifulImageHomePageViewController : BaseViewController<UIScrollViewDelegate>

- (id)initWithDataManager:(id<BeautifulImageHomePageDataManagerProtocol>)dataManager index:(NSInteger)index loadMore:(BaseRequest<BeautifulImageHomePageLoadMoreRequestProtocol> *)loadMoreRequest dismissBlock:(HomePageDismissBlock)dismissBlock;

@end
