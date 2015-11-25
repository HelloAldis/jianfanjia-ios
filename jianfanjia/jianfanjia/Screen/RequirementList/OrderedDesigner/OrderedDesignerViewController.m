//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "OrderedDesignerViewController.h"
#import "DesignerDeclineHomeOwnerCell.h"
#import "DesignerMeasureHouseWithoutPlanCell.h"
#import "DesignerRespondedWithoutMeasureHouseCell.h"
#import "DesignerSubmittedPlanCell.h"
#import "ExpiredAsDesignerDidNotRespondCell.h"
#import "ExpiredAsDesignerDidProvidePlanInSpecifiedTimeCell.h"
#import "HomeOwnerOrderedWithoutResponseCell.h"
#import "PlanWasChoosedCell.h"
#import "PlanWasNotChoosedCell.h"
#import "DesignerPlanStatusBaseCell.h"
#import "RequirementDataManager.h"

static NSString *DesignerDeclineHomeOwner = @"DesignerDeclineHomeOwnerCell";
static NSString *DesignerMeasureHouseWithoutPlan = @"DesignerMeasureHouseWithoutPlanCell";
static NSString *DesignerRespondedWithoutMeasureHouse = @"DesignerRespondedWithoutMeasureHouseCell";
static NSString *DesignerSubmittedPlan = @"DesignerSubmittedPlanCell";
static NSString *ExpiredAsDesignerDidNotRespond = @"ExpiredAsDesignerDidNotRespondCell";
static NSString *ExpiredAsDesignerDidProvidePlanInSpecifiedTime = @"ExpiredAsDesignerDidProvidePlanInSpecifiedTimeCell";
static NSString *HomeOwnerOrderedWithoutResponse = @"HomeOwnerOrderedWithoutResponseCell";
static NSString *PlanWasChoosed = @"PlanWasChoosedCell";
static NSString *PlanWasNotChoosed = @"PlanWasNotChoosedCell";

@interface OrderedDesignerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *orderableDesigners;
@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;
@property (assign, nonatomic) NSInteger orderableCount;

@property (assign, nonatomic) BOOL isChooseAll;

@end

@implementation OrderedDesignerViewController

#pragma mark - init method
- (id)initWithRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        _requirement = requirement;
        _requirementDataManager = [[RequirementDataManager alloc] init];
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:DesignerDeclineHomeOwner bundle:nil] forCellReuseIdentifier:DesignerDeclineHomeOwner];
    [self.tableView registerNib:[UINib nibWithNibName:DesignerMeasureHouseWithoutPlan bundle:nil] forCellReuseIdentifier:DesignerMeasureHouseWithoutPlan];
    [self.tableView registerNib:[UINib nibWithNibName:DesignerRespondedWithoutMeasureHouse bundle:nil] forCellReuseIdentifier:DesignerRespondedWithoutMeasureHouse];
    [self.tableView registerNib:[UINib nibWithNibName:DesignerSubmittedPlan bundle:nil] forCellReuseIdentifier:DesignerSubmittedPlan];
    [self.tableView registerNib:[UINib nibWithNibName:ExpiredAsDesignerDidNotRespond bundle:nil] forCellReuseIdentifier:ExpiredAsDesignerDidNotRespond];
    [self.tableView registerNib:[UINib nibWithNibName:ExpiredAsDesignerDidProvidePlanInSpecifiedTime bundle:nil] forCellReuseIdentifier:ExpiredAsDesignerDidProvidePlanInSpecifiedTime];
    [self.tableView registerNib:[UINib nibWithNibName:HomeOwnerOrderedWithoutResponse bundle:nil] forCellReuseIdentifier:HomeOwnerOrderedWithoutResponse];
    [self.tableView registerNib:[UINib nibWithNibName:PlanWasChoosed bundle:nil] forCellReuseIdentifier:PlanWasChoosed];
    [self.tableView registerNib:[UINib nibWithNibName:PlanWasNotChoosed bundle:nil] forCellReuseIdentifier:PlanWasNotChoosed];
    
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshOrderedList];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requirementDataManager.orderedDesigners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithDesigner:self.requirementDataManager.orderedDesigners[indexPath.row] withTableView:tableView forIndex:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - send request 
- (void)refreshOrderedList {
    GetOrderedDesignder *request = [[GetOrderedDesignder alloc] init];
    request.requirementid = self.requirement._id;
    
    [API getOrderedDesigner:request success:^{
        [self.requirementDataManager refreshOrderedDesigners];
        [self.tableView reloadData];
    } failure:^{
    
    }];
}

#pragma mark - get specified cell
- (DesignerPlanStatusBaseCell *)loadCellWithDesigner:(Designer *)orderedDesigner withTableView:(UITableView *)tableView forIndex:(NSIndexPath *)path {
    NSString *status = orderedDesigner.plan.status;
    
    NSString *cellIdentifier;
    if ([status isEqualToString:kPlanStatusHomeOwnerOrderedWithoutResponse]) {
        cellIdentifier = HomeOwnerOrderedWithoutResponse;
    } else if ([status isEqualToString:kPlanStatusDesignerRespondedWithoutMeasureHouse]) {
        cellIdentifier = DesignerRespondedWithoutMeasureHouse;
    } else if ([status isEqualToString:kPlanStatusDesignerSubmittedPlan]) {
        cellIdentifier = DesignerSubmittedPlan;
    } else if ([status isEqualToString:kPlanStatusPlanWasChoosed]) {
        cellIdentifier = PlanWasChoosed;
    } else if ([status isEqualToString:kPlanStatusDesignerDeclineHomeOwner]) {
        cellIdentifier = DesignerDeclineHomeOwner;
    } else if ([status isEqualToString:kPlanStatusPlanWasNotChoosed]) {
        cellIdentifier = PlanWasNotChoosed;
    } else if ([status isEqualToString:kPlanStatusDesignerMeasureHouseWithoutPlan]) {
        cellIdentifier = DesignerMeasureHouseWithoutPlan;
    } else if ([status isEqualToString:kPlanStatusExpiredAsDesignerDidNotRespond]) {
        cellIdentifier = ExpiredAsDesignerDidNotRespond;
    }
    
    DesignerPlanStatusBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:path];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self);
    [cell initWithDesigner:orderedDesigner withRequirement:self.requirement withBlock:^{
        @strongify(self);
        [self refreshOrderedList];
    }];
    return cell;
}

@end