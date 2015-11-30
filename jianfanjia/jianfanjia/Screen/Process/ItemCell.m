//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@property (weak, nonatomic) IBOutlet UIView *statusLine1;
@property (weak, nonatomic) IBOutlet UIView *statusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;


@property (weak, nonatomic) Process *process;
@property (weak, nonatomic) Item *item;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) NSInteger itemIndex;

@end

@implementation ItemCell

#pragma mark - life cycle
- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - UI
- (void)initWithItem:(Item *)item sectionIndex:(NSInteger )sectionIndex itemIndex:(NSInteger)itemIndex forProcess:(Process *)process  {
    self.process = process;
    self.item = item;
    self.sectionIndex = sectionIndex;
    self.itemIndex = itemIndex;
    self.lblItemTitle.text = [ProcessBusiness nameForKey:item.name];
    
    
    if ([self.item.status isEqualToString:kSectionStatusOnGoing]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_1"];
        self.statusLine2.backgroundColor = kFinishedColor;
    } else if([self.item.status isEqualToString:kSectionStatusAlreadyFinished]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_2"];
        self.statusLine2.backgroundColor = kFinishedColor;
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_0"];
        self.statusLine2.backgroundColor = kUntriggeredColor;
    }
}

@end
