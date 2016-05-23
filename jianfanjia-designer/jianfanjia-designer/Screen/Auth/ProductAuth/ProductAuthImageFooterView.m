//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthImageFooterView.h"

@implementation ProductAuthImageFooterView

+ (ProductAuthImageFooterView *)productAuthImageFooterView {
    return [[NSBundle mainBundle] loadNibNamed:@"ProductAuthImageFooterView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)onTap {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
