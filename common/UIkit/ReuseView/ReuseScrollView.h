//
//  ReuseScrollView.h
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseCell.h"

@protocol ReuseScrollViewProtocol <NSObject>

@required
- (ReuseCell *)reuseCellFactory;

@end

@interface ReuseScrollView : UIScrollView

@property (nonatomic, weak) id<ReuseScrollViewProtocol> reuseDelegate;
@property (nonatomic, assign) NSInteger padding;

- (instancetype)initWithFrame:(CGRect)frame items:(NSInteger)totalItems;

@end
