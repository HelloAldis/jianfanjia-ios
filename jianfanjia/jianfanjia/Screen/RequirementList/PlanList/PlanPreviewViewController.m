//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanPreviewViewController.h"
#import "RequirementDataManager.h"

@interface PlanPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDecHouseTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDecAreaVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDecTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDurationVal;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectPriceVal;
@property (weak, nonatomic) IBOutlet UIButton *btnPriceDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignDescriptionVal;
@property (weak, nonatomic) IBOutlet UIButton *btnChoosePlan;

@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@end

@implementation PlanPreviewViewController

#pragma mark - init method
- (id)initWithRequirement:(Requirement *)requirement withDesigner:(NSString *)designerid {
    if (self = [super init]) {
        _requirement = requirement;
        _designerid = designerid;
        _requirementDataManager = [[RequirementDataManager alloc] init];
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNav];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
}

#pragma mark - send request 
- (void)refreshPlanList {
    GetRequirementPlans *request = [[GetRequirementPlans alloc] init];
    request.designerid = self.designerid;
    request.requirementid = self.requirement._id;
    
    [API getRequirementPlans:request success:^{
        [self.requirementDataManager refreshRequirementPlans];
        
    } failure:^{
        
    }];
}

@end
