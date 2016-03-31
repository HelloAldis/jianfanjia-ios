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
    
    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
//        [idleImages addObject:image];
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=22; i++) {
        //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"brush_anim_%zd", i]];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateIdle];
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    self.stateLabel.hidden = YES;
}

@end
