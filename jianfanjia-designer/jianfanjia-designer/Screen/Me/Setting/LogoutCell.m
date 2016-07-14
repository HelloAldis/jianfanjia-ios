//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "LogoutCell.h"
#import "ViewControllerContainer.h"

@interface LogoutCell ()

@end

@implementation LogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)onTap {
    [AlertUtil show:[ViewControllerContainer navigation] title:@"确定退出？"  cancelBlock:^{
        
    } doneBlock:^{
        [ViewControllerContainer logout];
    }];
}

@end
