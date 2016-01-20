//
//  ProcessViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@class InfiniteScrollView;

@interface ProcessViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, InfiniteScrollViewProtocol>

- (id)initWithProcess:(NSString *)processid;
- (id)initWithProcessPreview;

@end
