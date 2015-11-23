//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanPriceItemCell.h"

@interface PlanPriceItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblItemVal;
@property (weak, nonatomic) IBOutlet UILabel *lblItemPriceVal;

@property (strong, nonatomic) Plan *plan;

@end

@implementation PlanPriceItemCell

- (void)initWithPriceItem:(PriceItem *)priceItem {
    self.lblItemVal.text = priceItem.item;
    self.lblItemPriceVal.text = [NSString stringWithFormat:@"%d", priceItem.price.intValue];
}

@end
