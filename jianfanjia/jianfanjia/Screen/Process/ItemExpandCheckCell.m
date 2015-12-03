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
#import "CustomAlertViewController.h"

@interface ItemExpandCheckCell ()

@property (weak, nonatomic) IBOutlet UIView *statusLine1;
@property (weak, nonatomic) IBOutlet UIView *statusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItemClose;
@property (weak, nonatomic) IBOutlet UIButton *btnDBYS;
@property (weak, nonatomic) IBOutlet UIButton *btnChangeDate;
@property (weak, nonatomic) IBOutlet UIButton *btnUnresolvedChangeDate;

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (weak, nonatomic) Item *item;
@property (copy, nonatomic) void(^refreshBlock)(void);

@end

@implementation ItemExpandCheckCell

#pragma mark - life cycle
- (void)awakeFromNib {
    [self.btnDBYS setCornerRadius:5];
    [self.btnChangeDate setCornerRadius:5];
    [self.btnUnresolvedChangeDate setCornerRadius:5];
    [self.btnChangeDate setBorder:1 andColor:kFinishedColor.CGColor];
    
    @weakify(self);
    [[self.btnDBYS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [ViewControllerContainer showDBYS:self.dataManager.selectedSection process:self.dataManager.process._id];
    }];

    [[self.btnChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.btnUnresolvedChangeDate.userInteractionEnabled = NO;
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        
        Reschedule *request = [[Reschedule alloc] init];
        
        [API reschedule:request success:^{
            self.btnUnresolvedChangeDate.userInteractionEnabled = YES;
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        } failure:^{
            self.btnUnresolvedChangeDate.userInteractionEnabled = YES;
        }];
    }];
    
    [[self.btnUnresolvedChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
//        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"改期提醒"
//                                                                       message:@"确定要改期吗？"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive
//                                                             handler:^(UIAlertAction * action) {
//                                                                 RejectReschedule *request = [[RejectReschedule alloc] init];
//                                                                 
//                                                                 [API rejectReschedule:request success:^{
//                                                                     if (self.refreshBlock) {
//                                                                         self.refreshBlock();
//                                                                     }
//                                                                 } failure:^{
//                                                                     
//                                                                 }];
//                                                             }];
//        
//        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction * action) {
//                                                                  AgreeReschedule *request = [[AgreeReschedule alloc] init];
//                                                                  
//                                                                  [API agreeReschedule:request success:^{
//                                                                      if (self.refreshBlock) {
//                                                                          self.refreshBlock();
//                                                                      }
//                                                                  } failure:^{
//                                                                
//                                                                  }];
//                                                              }];
//        
//        
//        [alert addAction:cancelAction];
//        [alert addAction:okAction];
        [CustomAlertViewController presentOkAlert:nil msg:nil];
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
    
    if ([self.item.status isEqualToString:kSectionStatusChangeDateRequest]) {
        self.btnUnresolvedChangeDate.hidden = NO;
    } else {
        self.btnUnresolvedChangeDate.hidden = YES;
    }
}

#pragma mark - date piker
- (void)onDatePickerValueChanged:(id)value {
    
}

@end
