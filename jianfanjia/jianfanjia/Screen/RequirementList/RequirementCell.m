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
@property (weak, nonatomic) IBOutlet UILabel *lblRequirementStatusVal;
@property (weak, nonatomic) IBOutlet UIButton *btnGoToWorkspace;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) RACDisposable *btnGoToDisposable;

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
            self.lblRequirementStatusVal.textColor = kUntriggeredColor;
            [self updateGoToWorksite:@"预览工地" titleColor:kThemeTextColor];
            [self gotoShowPreviewWorksite];
        }],
       [ReqtConfiguredAgreement action:^{
            self.lblRequirementStatusVal.textColor = kFinishedColor;
            [self updateGoToWorksite:@"查看合同" titleColor:kFinishedColor];
            [self gotoShowAgreement];
        }],
       [ReqtPlanWasChoosed action:^{
            self.lblRequirementStatusVal.textColor = kPassStatusColor;
            [self updateGoToWorksite:@"查看合同" titleColor:kFinishedColor];
            [self gotoShowAgreement];
        }],
       [ReqtConfiguredWorkSite action:^{
            self.lblRequirementStatusVal.textColor = kFinishedColor;
            [self updateGoToWorksite:@"前往工地" titleColor:kFinishedColor];
            [self gotoShowWorksite];
        }],
       [ReqtFinishedWorkSite action:^{
            self.lblRequirementStatusVal.textColor = kPassStatusColor;
            [self updateGoToWorksite:@"前往工地" titleColor:kFinishedColor];
            [self gotoShowWorksite];
        }],
       [ElseStatus action:^{
            self.lblRequirementStatusVal.textColor = kUntriggeredColor;
            [self updateGoToWorksite:@"预览工地" titleColor:kThemeTextColor];
            [self gotoShowPreviewWorksite];
        }],
      ]];
}

#pragma mark - Go to workspace function
- (void)updateGoToWorksite:(NSString *)title titleColor:(UIColor *)titleColor {
    [self.btnGoToWorkspace setNormTitleColor:titleColor];
    [self.btnGoToWorkspace setNormTitle:title];
}

- (void)updateGotoBlock:(void (^)(void))gotoBlock {
    [self.btnGoToDisposable dispose];
    self.btnGoToDisposable = [[self.btnGoToWorkspace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (gotoBlock) {
            gotoBlock();
        }
    }];
}

- (void)gotoShowWorksite {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showProcess:self.requirement.process._id];
    }];
}

- (void)gotoShowOrderDesigner {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showOrderDesigner:self.requirement];
    }];
}

- (void)gotoShowOrderedDesigner {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showOrderedDesigner:self.requirement];
    }];
}

- (void)gotoShowPreviewWorksite {
    [self updateGotoBlock:^{
        [ViewControllerContainer showProcessPreview];
    }];
}

- (void)gotoShowAgreement {
    @weakify(self);
    [self updateGotoBlock:^{
        @strongify(self);
        [ViewControllerContainer showAgreement:self.requirement popTo:[ViewControllerContainer getCurrentTapController] refresh:nil];
    }];
}

@end
