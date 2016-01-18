//
//  ImageDetailViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/11/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

@interface ImageDetailViewController : UIViewController<UIScrollViewDelegate>

- (id)initWithOffline:(NSArray *)offlineImages index:(NSInteger)index;
- (id)initWithOnline:(NSArray *)onlineImages index:(NSInteger)index;
- (id)initWithOffline:(NSArray *)offlineImages online:(NSArray *)onlineImages index:(NSInteger)index;

@end
