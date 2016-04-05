//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DecPackage365View.h"
#import "ViewControllerContainer.h"

const CGFloat kDecPackage365ViewHeight = 170;

@interface DecPackage365View()

@end

@implementation DecPackage365View

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    self.clipsToBounds = YES;
}

- (void)updateData:(Requirement *)requirement {
    self.requirement = requirement;
   
}

@end
