//
//  DIYGifHeader.m
//  jianfanjia
//
//  Created by Karos on 16/3/31.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DIYGifHeader.h"

@interface DIYGifHeader()

/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@property (weak, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation DIYGifHeader

#pragma mark - 懒加载
- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_indicator = indicator];
    }
    return _indicator;
}

- (UIImageView *)gifView {
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations {
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
    [self setImages:images duration:images.count * 0.1 forState:state];
}

- (NSArray *)imagesForState:(MJRefreshState)state {
    return self.stateImages[@(state)];
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    
    if (self.state == MJRefreshStateIdle) {
        NSArray *images = self.stateImages[@(self.state)];
        if (images.count == 0) return;
        // 停止动画
        [self.gifView stopAnimating];
        // 设置当前需要显示的图片
        NSUInteger index =  images.count * pullingPercent;
        if (index >= images.count) index = images.count - 1;
        self.gifView.image = images[index];
    } else if (self.state == MJRefreshStatePulling) {
        NSArray *images = self.stateImages[@(self.state)];
        if (images.count == 0) return;
        // 停止动画
        [self.gifView stopAnimating];
        // 设置当前需要显示的图片
        NSUInteger index =  images.count * (pullingPercent - 1);
        if (index >= images.count) index = images.count - 1;
        self.gifView.image = images[index];
        self.mj_y = - self.mj_h * self.pullingPercent;
    }
}

- (void)placeSubviews {
    self.gifView.frame = self.bounds;
    self.gifView.contentMode = UIViewContentModeCenter;
    self.mj_y = - self.mj_h;
    self.indicator.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        [self.indicator stopAnimating];
        self.gifView.contentMode = UIViewContentModeCenter;
    } else if (state == MJRefreshStatePulling) {
        [self.indicator stopAnimating];
        self.gifView.contentMode = UIViewContentModeTop;
    } else if (state == MJRefreshStateRefreshing) {
        self.gifView.image = nil;
        [self.indicator startAnimating];
//        NSArray *images = self.stateImages[@(state)];
//        if (images.count == 0) return;
//        
//        [self.gifView stopAnimating];
//        if (images.count == 1) { // 单张图片
//            self.gifView.image = [images lastObject];
//        } else { // 多张图片
//            self.gifView.animationImages = images;
//            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
//            [self.gifView startAnimating];
//        }
    }
}

@end
