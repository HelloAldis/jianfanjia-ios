//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCell.h"
#import "ViewControllerContainer.h"
#import "RequirementDataManager.h"
#import "DesignerStatusCell.h"

static const NSInteger CELL_SPACE = 0;

static NSString *DesignerStatusCellIdentifier = @"DesignerStatusCell";

@interface RequirementCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblPubulishTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (weak, nonatomic) IBOutlet UIButton *btnGoProcessPreview;
@property (weak, nonatomic) IBOutlet UIButton *btnViewPlan;
@property (weak, nonatomic) IBOutlet UIButton *btnGoProcess;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *lblTips;

@property (weak, nonatomic) RACDisposable *btnGoProcessPreDisposable;

@property (strong, nonatomic) NSMutableArray *currentPlanStatus;
@property (strong, nonatomic) RequirementDataManager *dataManager;
@property (strong, nonatomic) Requirement *requirement;


@end

@implementation RequirementCell

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    [self.imgHomeOwner setCornerRadius:self.imgHomeOwner.bounds.size.width / 2];
    self.dataManager = [[RequirementDataManager alloc] init];
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeaderView:)]];
    
    [self.imgCollection registerNib:[UINib nibWithNibName:DesignerStatusCellIdentifier bundle:nil] forCellWithReuseIdentifier:DesignerStatusCellIdentifier];
    
    self.flowLayout.minimumLineSpacing = CELL_SPACE;
    self.flowLayout.minimumInteritemSpacing = CELL_SPACE;
    
    @weakify(self);
    [[self.btnViewPlan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickGotoViewPlan];
    }];
    [[self.btnGoProcess rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickGotoWorksite];
    }];
}

- (void)initWithRequirement:(Requirement *)requirement {
    [self.imgHomeOwner setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    self.requirement = requirement;
    [self.dataManager refreshOrderedDesigners:requirement];
    [self updateRequirement:requirement];
    [self calcuateItemSize];
}

#pragma mark - calculate item size
- (void)calcuateItemSize {
    CGFloat colCount = self.dataManager.orderedDesigners.count;
    CGFloat minWidth = 60;
    CGFloat itemInterval = floor((kScreenWidth - minWidth * colCount) / (colCount + 1));
    CGFloat itemWidth = minWidth + itemInterval;
    CGFloat itemHeight = self.imgCollection.bounds.size.height;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, itemInterval / 2, 0, itemInterval / 2);
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    [self.imgCollection reloadData];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataManager.orderedDesigners.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DesignerStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DesignerStatusCellIdentifier forIndexPath:indexPath];
    [cell initWithDesigner:self.dataManager.orderedDesigners[indexPath.row] requirement:self.requirement];
    
    return cell;
}

#pragma mark - gestures
- (void)handleTapHeaderView:(UIGestureRecognizer*)gestureRecognizer {
    [ViewControllerContainer showRequirementCreate:self.requirement];
}

#pragma mark - requirement
- (void)updateRequirement:(Requirement *)requirement {
    self.lblPubulishTimeVal.text = [NSDate yyyy_MM_dd:requirement.create_at];
    self.lblUpdateTimeVal.text = [NSDate yyyy_MM_dd:requirement.last_status_update_time];
    self.lblCellNameVal.text = requirement.basic_address;
    
    NSString *status = requirement.status;
    [StatusBlock matchReqt:status actions:
     @[[ReqtUnorderDesigner action:^{
            self.lblTips.hidden = NO;
            [self updateGoProcessPre:@"预览工地" titleColor:kThemeTextColor];
            [self gotoShowPreviewWorksite];
            [self showGotoWorksite:NO];
        }],
       [ReqtPlanWasChoosed action:^{
            self.lblTips.hidden = YES;
            [self updateGoProcessPre:@"查看方案" titleColor:kThemeColor];
            [self gotoShowViewPlan];
            [self showGotoWorksite:NO];
        }],
       [ReqtConfiguredAgreement action:^{
            self.lblTips.hidden = YES;
            [self updateGoProcessPre:@"查看方案" titleColor:kThemeColor];
            [self gotoShowViewPlan];
            [self showGotoWorksite:NO];
        }],
       [ReqtConfiguredWorkSite action:^{
            self.lblTips.hidden = YES;
            [self showGotoWorksite:YES];
        }],
       [ReqtFinishedWorkSite action:^{
            self.lblTips.hidden = YES;
            [self showGotoWorksite:YES];
        }],
       [ElseStatus action:^{
            self.lblTips.hidden = YES;
            [self updateGoProcessPre:@"预览工地" titleColor:kThemeTextColor];
            [self gotoShowPreviewWorksite];
            [self showGotoWorksite:NO];
        }],
      ]];
}

#pragma mark - Go to workspace function
- (void)showGotoWorksite:(BOOL)show {
    self.btnGoProcessPreview.hidden = show;
    self.btnViewPlan.hidden = !show;
    self.btnGoProcess.hidden = !show;
}

- (void)updateGoProcessPre:(NSString *)title titleColor:(UIColor *)titleColor {
    [self.btnGoProcessPreview setNormTitleColor:titleColor];
    [self.btnGoProcessPreview setNormTitle:title];
}

- (void)updateGotoBlock:(void (^)(void))gotoBlock {
    [self.btnGoProcessPreDisposable dispose];
    self.btnGoProcessPreDisposable = [[self.btnGoProcessPreview rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (gotoBlock) {
            gotoBlock();
        }
    }];
}

- (void)gotoShowPreviewWorksite {
    [self updateGotoBlock:^{
        [ViewControllerContainer showProcessPreview];
    }];
}

- (void)gotoShowViewPlan {
    [self updateGotoBlock:^{
        [self onClickGotoViewPlan];
    }];
}

- (void)onClickGotoViewPlan {
    NSString *finalPlanId = self.requirement.final_planid;
    __block Plan *finalPlan = nil;
    [self.dataManager.orderedDesigners enumerateObjectsUsingBlock:^(Designer  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.plan._id isEqualToString:finalPlanId]) {
            finalPlan = obj.plan;
            *stop = YES;
        }
    }];
    
    [ViewControllerContainer showPlanPerview:finalPlan forRequirement:self.requirement popTo:nil refresh:nil];
}

- (void)onClickGotoWorksite {
    [ViewControllerContainer showProcess:self.requirement.process._id];
}

@end
