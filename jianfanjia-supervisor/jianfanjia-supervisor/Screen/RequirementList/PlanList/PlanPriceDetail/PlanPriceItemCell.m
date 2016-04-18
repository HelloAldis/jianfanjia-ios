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
@property (weak, nonatomic) IBOutlet UIView *lblDetailView;
@property (weak, nonatomic) IBOutlet UILabel *lblNo;

@property (strong, nonatomic) Plan *plan;

@end

@implementation PlanPriceItemCell

- (void)initWithPriceItem:(PriceItem *)priceItem {
    self.lblItemVal.text = priceItem.item;
    self.lblItemPriceVal.text = [NSString stringWithFormat:@"%d", priceItem.price.intValue];
    
    if ([priceItem.price_description trim].length > 0) {
        self.lblDetailView.hidden = NO;
        self.lblNo.hidden = YES;
    } else {
        self.lblDetailView.hidden = YES;
        self.lblNo.hidden = NO;
    }

    self.backgroundColor = [RequirementBusiness isPriceItem365:priceItem] ? [UIColor colorWithR:0xEE g:0xF8 b:0xFC] : [UIColor whiteColor];
}

@end
