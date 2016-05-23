//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductUploadCell.h"
#import "ViewControllerContainer.h"

@interface ProductUploadCell ()

@end

@implementation ProductUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)onTap {
    [ViewControllerContainer showProductAuthUploadPart1:nil];
}

@end
