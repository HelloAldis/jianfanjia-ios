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
#import "MessageAlertViewController.h"
#import "DateAlertViewController.h"

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
        [ViewControllerContainer showDBYS:self.dataManager.selectedSection process:self.dataManager.process._id refresh:^{
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
    }];

    [[[self.btnChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside]
        filter:^BOOL(id value) {
          @strongify(self);
          return self.btnChangeDate.alpha == 1;
        }]
        subscribeNext:^(id x) {
            @strongify(self);
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:self.dataManager.selectedSection.start_at.longLongValue / 1000];
            NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
            NSDate *minDate = [cal dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            NSDate *maxDate = [cal dateByAddingUnit:NSCalendarUnitYear value:1 toDate:minDate options:0];

            [DateAlertViewController presentAlert:@"选择改期时间" min:minDate max:maxDate cancel:^(id obj) {
                
            } ok:^(UIDatePicker *obj) {
                Reschedule *request = [[Reschedule alloc] init];
                request.processid = self.dataManager.process._id;
                request.userid = self.dataManager.process.userid;
                request.designerid = self.dataManager.process.final_designerid;
                request.section = self.dataManager.selectedSection.name;
                request.updated_date = @([obj.date timeIntervalSince1970] * 1000);
                
                [API reschedule:request success:^{
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                } failure:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.refreshBlock) {
                            self.refreshBlock();
                        }
                    });
                } networkError:^{
                    
                }];
            }];
        }];
    
    [[self.btnUnresolvedChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [MessageAlertViewController presentAlert:@"改期提醒" msg:@"对方申请改期至" second:[NSDate yyyy_MM_dd:self.dataManager.selectedSection.schedule.updated_date]
            rejectTitle:@"拒绝"
            reject:^{
                RejectReschedule *request = [[RejectReschedule alloc] init];
                request.processid = self.dataManager.process._id;

                [API rejectReschedule:request success:^{
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                 
                } failure:^{

                } networkError:^{
                    
                }];
            }
            agreeTitle:@"同意"
            agree:^{
                AgreeReschedule *request = [[AgreeReschedule alloc] init];
                request.processid = self.dataManager.process._id;

                [API agreeReschedule:request success:^{
                    if (self.refreshBlock) {
                        self.refreshBlock();
                    }
                } failure:^{

                } networkError:^{
                    
                }];
            }];
    }];
}

#pragma mark - UI
- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager withBlock:(void(^)(void))refreshBlock {
    self.refreshBlock = refreshBlock;
    self.dataManager = dataManager;
    self.item = item;
    self.lblItemTitle.text = [ProcessBusiness nameForKey:item.name];
    
    if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusOnGoing]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_1"];
        self.statusLine2.backgroundColor = kFinishedColor;
    } else if([self.dataManager.selectedSection.status  isEqualToString:kSectionStatusAlreadyFinished]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_2"];
        self.statusLine2.backgroundColor = kFinishedColor;
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_0"];
        self.statusLine2.backgroundColor = kUntriggeredColor;
    }
    
    Schedule *schedule = self.dataManager.selectedSection.schedule;
    if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusChangeDateRequest]) {
        if ([[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role]) {
            [self.btnChangeDate setBorder:1 andColor:kUntriggeredColor.CGColor];
            [self.btnChangeDate setTitleColor:kUntriggeredColor forState:UIControlStateNormal];
            [self.btnChangeDate setTitle:@"改期申请中" forState:UIControlStateNormal];
            self.btnUnresolvedChangeDate.hidden = YES;
        } else {
            self.btnUnresolvedChangeDate.hidden = NO;
        }
    } else if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        [self.btnChangeDate setBorder:1 andColor:kUntriggeredColor.CGColor];
        [self.btnChangeDate setTitleColor:kUntriggeredColor forState:UIControlStateNormal];
        [self.btnChangeDate setTitle:@"工序已完工" forState:UIControlStateNormal];
    } else {
        [self.btnChangeDate setBorder:1 andColor:kFinishedColor.CGColor];
        [self.btnChangeDate setTitleColor:kFinishedColor forState:UIControlStateNormal];
        [self.btnChangeDate setTitle:@"申请改期" forState:UIControlStateNormal];
        self.btnChangeDate.alpha = 1;
        self.btnUnresolvedChangeDate.hidden = YES;
    }
}

@end
