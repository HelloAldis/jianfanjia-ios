//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DiarySetUploadCell.h"
#import "ViewControllerContainer.h"

@interface DiarySetUploadCell ()

@end

@implementation DiarySetUploadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)onTap {
    [ViewControllerContainer showDiarySetUpload:nil];
}

@end
