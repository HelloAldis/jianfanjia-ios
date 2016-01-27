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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithPriceItem:(PriceItem *)priceItem {
    self.lblItemVal.text = priceItem.item;
    self.lblItemPriceVal.text = [NSString stringWithFormat:@"%d", priceItem.price.intValue];
    self.lblDescription.text = priceItem.price_description;
}

@end
