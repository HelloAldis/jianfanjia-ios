//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "SectionActionView.h"
#import "ViewControllerContainer.h"

const CGFloat kSectionActionViewHeight = 90;

@interface SectionActionView()

@end

@implementation SectionActionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    self.clipsToBounds = YES;
    self.expandIcon.transform = CGAffineTransformMakeRotation(M_PI);
    [self.expandView setCornerRadius:5];
    [self.btnDBYS setCornerRadius:5];
    [self.btnChangeDate setCornerRadius:5];
    [self.btnUnresolvedChangeDate setCornerRadius:5];
    [self.btnChangeDate setBorder:1 andColor:kFinishedColor.CGColor];
    
    @weakify(self);
    [[self.btnDBYS rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [ViewControllerContainer showDBYS:self.dataManager.selectedSection process:self.dataManager.process._id refresh:nil];
    }];
    
    [[[self.btnChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside]
      filter:^BOOL(id value) {
          @strongify(self);
          return self.btnChangeDate.alpha == 1;
      }]
    subscribeNext:^(id x) {
     }];
    
    [[self.btnUnresolvedChangeDate rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    }];
}

- (void)updateData:(Item *)item withMgr:(ProcessDataManager *)dataManager refresh:(void(^)(void))refreshBlock {
    self.refreshBlock = refreshBlock;
    self.dataManager = dataManager;
    self.item = item;
    
    Schedule *schedule = self.dataManager.selectedSection.schedule;
    if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusChangeDateRequest]) {
        BOOL isRequestBySelf = [[GVUserDefaults standardUserDefaults].usertype isEqualToString:schedule.request_role];
        [self enableChangeDate:!isRequestBySelf title:@"改期申请中"];
        [self hideUnresolvedChangeDate:isRequestBySelf];
    } else if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        [self enableChangeDate:NO title:@"工序已完工"];
        [self hideUnresolvedChangeDate:YES];
    } else if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusUnStart]) {
        [self enableChangeDate:NO title:@"申请改期"];
        [self hideUnresolvedChangeDate:YES];
    } else {
        [self enableChangeDate:YES title:@"申请改期"];
        [self hideUnresolvedChangeDate:YES];
    }
}

- (void)enableChangeDate:(BOOL)enable title:(NSString *)title {
    [self.btnChangeDate setTitle:title forState:UIControlStateNormal];
    
    if (enable) {
        [self.btnChangeDate setBorder:1 andColor:kFinishedColor.CGColor];
        [self.btnChangeDate setNormTitleColor:kFinishedColor];
        [self.btnChangeDate setEnabled:YES];
    } else {
        [self.btnChangeDate setBorder:1 andColor:kUntriggeredColor.CGColor];
        [self.btnChangeDate setNormTitleColor:kUntriggeredColor];
        [self.btnChangeDate setEnabled:NO];
    }
}

- (void)hideUnresolvedChangeDate:(BOOL)hide {
    self.btnUnresolvedChangeDate.hidden = hide;
}

@end
