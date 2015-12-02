//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ItemExpandCheckCell.h"
#import "ItemImageCollectionCell.h"
#import "UIItemImageCollectionView.h"
#import "ViewControllerContainer.h"
#import "ProcessDataManager.h"
#import "ImageDetailViewController.h"

@interface ItemExpandCheckCell ()

@property (weak, nonatomic) IBOutlet UIView *statusLine1;
@property (weak, nonatomic) IBOutlet UIView *statusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItemClose;
@property (weak, nonatomic) IBOutlet UIButton *btnDBYS;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeDate;

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (weak, nonatomic) Item *item;
@property (copy, nonatomic) void(^refreshBlock)(void);

@end

@implementation ItemExpandCheckCell

#pragma mark - life cycle
- (void)awakeFromNib {
    [self.btnDBYS setCornerRadius:5];
    [self.btnChangeDate setCornerRadius:5];
    [self.btnChangeDate setBorder:1 andColor:kFinishedColor.CGColor];
    
    @weakify(self);
    [[self.btnDBYS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [ViewControllerContainer showDBYS:self.dataManager.selectedSection process:self.dataManager.process._id];
    }];

    [[self.btnChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
    }];
}

#pragma mark - UI
- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager withBlock:(void(^)(void))refreshBlock {
    self.refreshBlock = refreshBlock;
    self.dataManager = dataManager;
    self.item = item;
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
