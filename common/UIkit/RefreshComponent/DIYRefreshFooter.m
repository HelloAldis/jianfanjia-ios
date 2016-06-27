//
//  DIYRefreshFooter.m
//  jianfanjia
//
//  Created by Karos on 16/5/11.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DIYRefreshFooter.h"

@implementation DIYRefreshFooter

#pragma mark 基本设置
- (void)prepare {
    [super prepare];
    
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = kUntriggeredColor;
}

- (void)setStateText:(NSString *)text {
    self.stateLabel.text = text;
}

@end
