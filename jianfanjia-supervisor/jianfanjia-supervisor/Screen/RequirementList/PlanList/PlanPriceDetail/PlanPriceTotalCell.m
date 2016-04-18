//
//  PlanPriceTotalCell.m
//  jianfanjia-designer
//
//  Created by JYZ on 16/1/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanPriceTotalCell.h"

@interface PlanPriceTotalCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblProjectPriceBeforeDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectPriceAfterDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignFee;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;

@end

@implementation PlanPriceTotalCell

- (void)initWithPlan:(Plan *)plan {
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:plan.project_price_before_discount ? [plan.project_price_before_discount humRmbString] : @"" attributes:attribtDic];
    self.lblProjectPriceBeforeDiscount.attributedText = attribtStr;
    self.lblProjectPriceAfterDiscount.text = [NSString stringWithFormat:@"%@", [plan.project_price_after_discount doubleValue] > 0 ? [plan.project_price_after_discount humRmbString] : [plan.project_price_before_discount humRmbString]];
    self.lblDesignFee.text = [NSString stringWithFormat:@"%@", [plan.total_design_fee humRmbString]];
    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@", [plan.total_price humRmbString]];
}


@end
