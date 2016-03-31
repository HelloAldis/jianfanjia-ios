//
//  DIYGifHeader.h
//  jianfanjia
//
//  Created by Karos on 16/3/31.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface DIYGifHeader : MJRefreshStateHeader

@property (weak, nonatomic) UIImageView *gifView;

/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
- (NSArray *)imagesForState:(MJRefreshState)state;

@end
