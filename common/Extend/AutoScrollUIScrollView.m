//
//  AutoScrollUIScrollView.m
//  jianfanjia
//
//  Created by Karos on 16/3/25.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AutoScrollUIScrollView.h"

@implementation AutoScrollUIScrollView

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    if (!self.disableAutoScroll) {
        [super scrollRectToVisible:rect animated:animated];
    }
}

@end
