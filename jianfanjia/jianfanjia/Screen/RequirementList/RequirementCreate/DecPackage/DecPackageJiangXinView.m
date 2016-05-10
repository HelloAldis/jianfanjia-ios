//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DecPackageJiangXinView.h"

const CGFloat kDecPackageJiangXinViewHeight = 100;

@interface DecPackageJiangXinView()
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;

@end

@implementation DecPackageJiangXinView

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
    self.lblDesc.text = @"您完全符合我们“匠心定制包”的标准\n我们的设计师将为您提供全程定制化的服务";
}

@end
