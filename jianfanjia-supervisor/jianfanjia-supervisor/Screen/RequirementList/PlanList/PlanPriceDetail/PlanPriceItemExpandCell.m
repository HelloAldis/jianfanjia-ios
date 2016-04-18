//
//  PlanPriceItemExpandCell.m
//  jianfanjia-designer
//
//  Created by JYZ on 16/1/27.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "PlanPriceItemExpandCell.h"

@interface PlanPriceItemExpandCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblItemVal;
@property (weak, nonatomic) IBOutlet UILabel *lblItemPriceVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation PlanPriceItemExpandCell

- (void)initWithPriceItem:(PriceItem *)priceItem {
    self.lblItemVal.text = priceItem.item;
    self.lblItemPriceVal.text = [NSString stringWithFormat:@"%d", priceItem.price.intValue];
    self.lblDescription.text = priceItem.price_description;
    
    self.backgroundColor = [RequirementBusiness isPriceItem365:priceItem] ? [UIColor colorWithR:0xEE g:0xF8 b:0xFC] : [UIColor whiteColor];
}

@end
