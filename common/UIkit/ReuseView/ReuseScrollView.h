//
//  ReuseScrollView.h
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReuseCell;
@class ReuseScrollView;

@protocol ReuseScrollViewProtocol <NSObject>

@required
- (ReuseCell *)reuseCellFactory;

@optional
- (void)reuseScrollViewPageDidChange:(ReuseScrollView *)scrollView toPage:(NSInteger)toPage;

@end

@interface ReuseScrollView : UIScrollView

@property (nonatomic, weak) id<ReuseScrollViewProtocol> reuseDelegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSInteger padding;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, readonly) CGSize cellSize;

- (ReuseCell *)cellForPage:(NSInteger)page;
- (CGRect)getOriginCellFrame:(NSInteger)page;

@end

@interface ReuseCell : UIView

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger curPage;
@property (nonatomic, readonly) CGRect originFrame;

- (void)reloadData:(ReuseScrollView *)scrollView item:(id)item;

@end