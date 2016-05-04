//
//  ReuseScrollView.h
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReuseCell;

@protocol ReuseScrollViewProtocol <NSObject>

@required
- (ReuseCell *)reuseCellFactory;

@end

@interface ReuseScrollView : UIScrollView

@property (nonatomic, readonly) NSInteger currentPage;

@property (nonatomic, weak) id<ReuseScrollViewProtocol> reuseDelegate;
@property (nonatomic, assign) NSInteger padding;

- (instancetype)initWithFrame:(CGRect)frame items:(NSInteger)totalItems;

@end

@interface ReuseCell : UIView

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger curPage;
@property (nonatomic, readonly) CGRect originFrame;

- (void)reloadData:(ReuseScrollView *)scrollView;

@end