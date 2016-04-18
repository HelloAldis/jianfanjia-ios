//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "UnexpandSectionActionView.h"
#import "ViewControllerContainer.h"

const CGFloat kUnexpandSectionActionViewHeight = 20;

@interface UnexpandSectionActionView()

@end

@implementation UnexpandSectionActionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        self.clipsToBounds = YES;
        [self.expandView setCornerRadius:5];
    }
    
    return self;
}

@end
