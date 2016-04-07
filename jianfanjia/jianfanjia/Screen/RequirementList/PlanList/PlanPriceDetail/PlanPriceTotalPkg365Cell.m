//
//  PlanPriceTotalCell.m
//  jianfanjia-designer
//
//  Created by JYZ on 16/1/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanPriceTotalPkg365Cell.h"

@interface PlanPriceTotalPkg365Cell ()

@property (weak, nonatomic) IBOutlet UILabel *lblBasicFee;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalizedFee;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectPriceBeforeDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectPriceAfterDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignFee;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPriceBeforeDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPriceAfterDiscount;

@end

@implementation PlanPriceTotalPkg365Cell

- (void)initWithPlan:(Plan *)plan item365:(PriceItem *)item365 {
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[@(plan.project_price_before_discount.floatValue + plan.total_design_fee.floatValue) humRmbString] attributes:attribtDic];

    CGFloat basicFee = item365 ? item365.price.floatValue : 0.0f;
    CGFloat personalizedFee = plan.project_price_before_discount.floatValue - basicFee;
    
    self.lblBasicFee.text = [@(basicFee) humRmbString];
    self.lblPersonalizedFee.text = [@(personalizedFee) humRmbString];
    self.lblProjectPriceBeforeDiscount.text = [plan.project_price_before_discount humRmbString];
    self.lblProjectPriceAfterDiscount.text = [plan.project_price_after_discount humRmbString];
    self.lblDesignFee.text = [plan.total_design_fee humRmbString];
    self.lblTotalPriceBeforeDiscount.attributedText = attribtStr;
    self.lblTotalPriceAfterDiscount.text = [plan.total_price humRmbString];
}

@end
