//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ItemCell.h"
#import "ProcessDataManager.h"

@interface ItemCell ()

@property (weak, nonatomic) IBOutlet UIView *statusLine1;
@property (weak, nonatomic) IBOutlet UIView *statusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (weak, nonatomic) Item *item;


@end

@implementation ItemCell

#pragma mark - life cycle
- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - UI
- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager {
    self.dataManager = dataManager;
    self.item = item;
    self.lblItemTitle.text = item.label;
    
    if ([self.item.status isEqualToString:kSectionStatusOnGoing]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_1"];
        self.statusLine2.bgColor = kFinishedColor;
    } else if([self.item.status isEqualToString:kSectionStatusAlreadyFinished]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_2"];
        self.statusLine2.bgColor = kFinishedColor;
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_0"];
        self.statusLine2.bgColor = kUntriggeredColor;
    }
    
    if ([dataManager.selectedSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        self.statusLine1.bgColor = kFinishedColor;
    } else {
        self.statusLine1.bgColor = kUntriggeredColor;
    }
}

@end
