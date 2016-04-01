//
//  BrushGifHeader.m
//  jianfanjia
//
//  Created by Karos on 16/3/30.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BrushGifHeader.h"

@implementation BrushGifHeader

#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<= 1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"brush_idle_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    NSMutableArray *pullingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<= 18; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"brush_anim_%zd", i]];
        [pullingImages addObject:image];
    }
    [self setImages:pullingImages forState:MJRefreshStatePulling];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *loadingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<= 3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"brush_loading_%zd", i]];
        [loadingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:loadingImages forState:MJRefreshStateRefreshing];
    
    self.mj_h = 50;
}

@end
