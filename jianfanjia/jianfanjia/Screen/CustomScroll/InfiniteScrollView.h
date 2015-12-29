//
//  InfiniteScrollView.h
//  jianfanjia
//
//  Created by Karos on 15/12/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScrollView;

@protocol InfiniteScrollViewProtocol <NSObject>

@required

/*
 获取需要显示的一组view的数目
 */
- (NSInteger)numberOfGroupInInfiniteScrollView:(InfiniteScrollView *)scrollView;

/*
 获取需要显示的view， 必须要创建一个新的view当回调发生时
 */
- (UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView viewAtIndex:(NSInteger)index;

@end

@interface InfiniteScrollView : UIScrollView

@property (nonatomic, weak) id<InfiniteScrollViewProtocol> infiniteDelegate;
@property (nonatomic, strong, readonly) NSMutableArray *visibleViews;
@property (nonatomic, strong, readonly) NSMutableArray *allViews;

- (void)reloadData;
- (CGFloat)getDistanceToLeftEdgeForSubview:(UIView *)view;

@end
