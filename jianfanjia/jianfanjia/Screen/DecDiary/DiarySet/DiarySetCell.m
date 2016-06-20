//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetCell.h"
#import "ViewControllerContainer.h"

@interface DiarySetCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) DiarySet *diarySet;
@property (nonatomic, copy) DiarySetCellDeleteBlock deleteBlock;

@end

@implementation DiarySetCell

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
    [self.btnDelete setCornerRadius:self.btnDelete.frame.size.height / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initWithDiarySet:(DiarySet *)diarySet edit:(BOOL)edit deleteBlock:(DiarySetCellDeleteBlock)deleteBlock {
    self.diarySet = diarySet;
    self.deleteBlock = deleteBlock;
    
    [self.productImageView setImageWithId:diarySet.cover_imageid withWidth:kScreenWidth];
//    self.lblCell.text = product.cell;
//    self.lblDetail.text = product.house_area ? [NSString stringWithFormat:@"%@m², %@, %@, %@风格\n%@, %@万",
//                                                product.house_area,
//                                                [NameDict nameForDecType:product.dec_type],
//                                                [ProductBusiness houseTypeByDecType:product],
//                                                [NameDict nameForDecStyle:product.dec_style],
//                                                [NameDict nameForWorkType:product.work_type],
//                                                product.total_price] : @"";
//    [self.lblDetail setRowSpace:7.0f];;
//    
//    if ([product.auth_type isEqualToString:kAuthTypeUnsubmitVerify]) {
//        self.coverView.hidden = YES;
//    } else {
//        self.coverView.hidden = !edit;
//    }
}

- (void)onTap {
    [ViewControllerContainer showDiarySetDetail:self.diarySet fromNewDiarySet:NO];
}

- (IBAction)onClickDelete:(id)sender {
    
}

@end
