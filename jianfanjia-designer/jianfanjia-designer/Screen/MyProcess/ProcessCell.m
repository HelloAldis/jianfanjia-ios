//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessCell.h"
#import "ViewControllerContainer.h"
#import "ProcessDataManager.h"
#import "SetWorksiteStartTimeViewController.h"

@interface ProcessCell ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UIScrollView *sectionScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblPublishTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessStatusVal;
@property (weak, nonatomic) IBOutlet UIButton *btnGoToWorkspace;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAgreement;

@property (strong, nonatomic) Process *process;

@property (weak, nonatomic) Item *item;

@end

@implementation ProcessCell

- (void)awakeFromNib {
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    
    @weakify(self);
    [[self.btnViewPlan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickViewPlan];
    }];
    
    [[self.btnViewAgreement rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickViewAgreement];
    }];
    
    [[self.btnGoToWorkspace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickGoToWorkSiteButton];
    }];
    
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
    self.sectionScrollView.showsHorizontalScrollIndicator = NO;
    self.sectionScrollView.showsVerticalScrollIndicator = NO;
}

- (void)initWithProcess:(Process *)process {
    self.process = process;
    [self.imgHomeOwner setUserImageWithId:self.process.user.imageid];
    self.lblPublishTimeVal.text = [NSDate yyyy_MM_dd_HH_mm:self.process.requirement.create_at];
    self.lblUpdateTimeVal.text = [NSDate yyyy_MM_dd_HH_mm:self.process.requirement.last_status_update_time];;
    self.lblCellNameVal.text = process.cell;
    self.lblProcessStatusVal.text = [NSString stringWithFormat:@"%@阶段", [ProcessBusiness nameForKey:process.going_on]];
    
    @weakify(self);
    [[NotificationDataManager shared] subscribeUnreadCountForProcess:self.process._id observer:^(id value) {
        @strongify(self);
        self.btnGoToWorkspace.badgeValue = [value intValue] > 0 ? [value stringValue] : nil;
        self.btnGoToWorkspace.badgeOriginX = kScreenWidth / 2 + 17;
    }];
    
    [self updateSections:process];
}

#pragma mark - user action
- (void)onClickGoToWorkSiteButton {
    [ViewControllerContainer showProcess:self.process._id];
}

- (void)onClickViewPlan {
    [ViewControllerContainer showPlanPerview:self.process.plan withOrder:1 forRequirement:self.process.requirement];
}

- (void)onClickViewAgreement {
    [SetWorksiteStartTimeViewController showSetMeasureHouseTime:self.process.requirement completion:nil];
}

#pragma mark - gestures
- (void)handleTapHeaderView:(UIGestureRecognizer*)gestureRecognizer {
    [ViewControllerContainer showRequirementCreate:self.process.requirement];
}

#pragma mark - update sections
- (void)updateSections:(Process *)process {
    [self.sectionScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *allSection = [ProcessBusiness allSectionName];
    NSInteger ongoingIdx = [allSection indexOfObject:process.going_on];
    
    CGFloat scrollViewHeight = CGRectGetHeight(self.sectionScrollView.frame);
    CGFloat imgWidth = 60;
    CGFloat textLabelHeight = 25;
    CGFloat lineWidth = 10;
    for (NSInteger i = 0; i < allSection.count; i++) {
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(i * (imgWidth + lineWidth * 2), (scrollViewHeight - textLabelHeight) / 2, lineWidth, 1)];
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(imgWidth + lineWidth + i * (imgWidth + lineWidth * 2), (scrollViewHeight - textLabelHeight) / 2, lineWidth, 1)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(lineWidth + i * (imgWidth + lineWidth * 2), (scrollViewHeight - imgWidth - textLabelHeight) / 2, imgWidth, imgWidth)];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineWidth + i * (imgWidth + lineWidth * 2), imgView.frame.origin.y + imgView.frame.size.height, imgWidth, textLabelHeight)];
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = kThemeTextColor;
        textLabel.text = [ProcessBusiness nameForKey:allSection[i]];
        
        if ([process.going_on isEqualToString:@"done"]) {
            leftLine.backgroundColor = kFinishedColor;
            rightLine.backgroundColor = kFinishedColor;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%@_%d", @(i), 2]];
        } else if (i < ongoingIdx) {
            leftLine.backgroundColor = kFinishedColor;
            rightLine.backgroundColor = i + 1 == ongoingIdx ? kUntriggeredColor : kFinishedColor;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%@_%d", @(i), 2]];
        } else if (i == ongoingIdx) {
            leftLine.backgroundColor = kUntriggeredColor;
            rightLine.backgroundColor = kUntriggeredColor;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%@_%d", @(i), 1]];
        } else {
            leftLine.backgroundColor = kUntriggeredColor;
            rightLine.backgroundColor = kUntriggeredColor;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%@_%d", @(i), 0]];
        }
        
        if (i == 0) {
            leftLine.hidden = YES;
        } else if (i == allSection.count - 1) {
            rightLine.hidden = YES;
        }
        
        [self.sectionScrollView addSubview:leftLine];
        [self.sectionScrollView addSubview:rightLine];
        [self.sectionScrollView addSubview:imgView];
        [self.sectionScrollView addSubview:textLabel];
    }
    
    [self.sectionScrollView setContentSize:CGSizeMake(allSection.count * (imgWidth + lineWidth * 2), imgWidth + textLabelHeight)];
}

@end
