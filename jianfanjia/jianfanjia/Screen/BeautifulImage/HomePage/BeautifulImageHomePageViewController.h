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
@class BeautifulImageCollectionCell;

typedef void(^HomePageDismissBlock)(NSInteger index);

@interface BeautifulImageHomePageViewController : BaseViewController<UIScrollViewDelegate>

@property (copy, nonatomic) HomePageDismissBlock dismissBlock;

- (id)initWithDataManager:(id<BeautifulImageHomePageDataManagerProtocol>)dataManager index:(NSInteger)index loadMore:(BaseRequest<BeautifulImageHomePageLoadMoreRequestProtocol> *)loadMoreRequest;

- (void)presentFromImageView:(UIImageView *)fromImageView fromController:(UIViewController *)controller;
- (void)dismissToRect:(CGRect)toFrame;

@end
