//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "CompareImageEditCell.h"

@interface CompareImageEditCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *compareImgView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImgView;

@end

@implementation CompareImageEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCompare)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapUpload)]];
}

- (void)initWithItem:(EditCellItem *)item {
    [super initWithItem:item];
    if (item.attrTitle) {
        self.lblTitle.attributedText = item.attrTitle;
    } else {
        self.lblTitle.attributedText = nil;
        self.lblTitle.text = item.title;
    }
    
    self.compareImgView.image = item.compareImage;
    if (item.uploadImage) {
        [self.uploadImgView setImageWithId:item.uploadImage withWidth:kScreenWidth];
    } else {
        self.uploadImgView.image = [UIImage imageNamed:@"btn_add_image"];
    }
}

- (void)onTapCompare {
    
}

- (void)onTapUpload {
    
}

@end
