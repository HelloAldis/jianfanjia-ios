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
#import "ExpiredAsDesignerDidNotProvidePlanInSpecifiedTimeCell.h"
#import "HomeOwnerOrderedWithoutResponseCell.h"
#import "PlanWasChoosedCell.h"
#import "PlanWasChoosedForDesignCell.h"
#import "PlanWasNotChoosedCell.h"
#import "PlanExpiredCell.h"
#import "DesignerPlanStatusBaseCell.h"
#import "RequirementDataManager.h"

static NSString *DesignerDeclineHomeOwnerIdentifier = @"DesignerDeclineHomeOwnerCell";
static NSString *DesignerMeasureHouseWithoutPlanIdentifier = @"DesignerMeasureHouseWithoutPlanCell";
static NSString *DesignerRespondedWithoutMeasureHouseIdentifier = @"DesignerRespondedWithoutMeasureHouseCell";
static NSString *DesignerSubmittedPlanIdentifier = @"DesignerSubmittedPlanCell";
static NSString *ExpiredAsDesignerDidNotRespondIdentifier = @"ExpiredAsDesignerDidNotRespondCell";
static NSString *ExpiredAsDesignerDidNotProvidePlanInSpecifiedTimeIdentifier = @"ExpiredAsDesignerDidNotProvidePlanInSpecifiedTimeCell";
static NSString *HomeOwnerOrderedWithoutResponseIdentifier = @"HomeOwnerOrderedWithoutResponseCell";
static NSString *PlanWasChoosedIdentifier = @"PlanWasChoosedCell";
static NSString *PlanWasChoosedForDesignIdentifier = @"PlanWasChoosedForDesignCell";
static NSString *PlanWasNotChoosedIdentifier = @"PlanWasNotChoosedCell";
static NSString *PlanExpiredIdentifier = @"PlanExpiredCell";

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
    [self.tableView registerNib:[UINib nibWithNibName:DesignerDeclineHomeOwnerIdentifier bundle:nil] forCellReuseIdentifier:DesignerDeclineHomeOwnerIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DesignerMeasureHouseWithoutPlanIdentifier bundle:nil] forCellReuseIdentifier:DesignerMeasureHouseWithoutPlanIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DesignerRespondedWithoutMeasureHouseIdentifier bundle:nil] forCellReuseIdentifier:DesignerRespondedWithoutMeasureHouseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DesignerSubmittedPlanIdentifier bundle:nil] forCellReuseIdentifier:DesignerSubmittedPlanIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ExpiredAsDesignerDidNotRespondIdentifier bundle:nil] forCellReuseIdentifier:ExpiredAsDesignerDidNotRespondIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ExpiredAsDesignerDidNotProvidePlanInSpecifiedTimeIdentifier bundle:nil] forCellReuseIdentifier:ExpiredAsDesignerDidNotProvidePlanInSpecifiedTimeIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:HomeOwnerOrderedWithoutResponseIdentifier bundle:nil] forCellReuseIdentifier:HomeOwnerOrderedWithoutResponseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanWasChoosedIdentifier bundle:nil] forCellReuseIdentifier:PlanWasChoosedIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanWasChoosedForDesignIdentifier bundle:nil] forCellReuseIdentifier:PlanWasChoosedForDesignIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanWasNotChoosedIdentifier bundle:nil] forCellReuseIdentifier:PlanWasNotChoosedIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanExpiredIdentifier bundle:nil] forCellReuseIdentifier:PlanExpiredIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshOrderedList];
    }];
    
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshOrderedList];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"我的设计师";
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requirementDataManager.orderedDesigners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithDesigner:self.requirementDataManager.orderedDesigners[indexPath.row] withTableView:tableView forIndex:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Designer *orderedDesigner = self.requirementDataManager.orderedDesigners[indexPath.row];
    NSString *status = orderedDesigner.plan.status;
    
    __block NSInteger height = 146;
    [StatusBlock matchPlan:status actions:
     @[[PlanHomeOwnerOrdered action:^{
            height = 96;
        }],
       [PlanExpired action:^{
            height = 96;
        }],
       [PlanDesignerDeclined action:^{
            height = 96;
        }],
      ]];
    
    return height;
}

#pragma mark - send request
- (void)refreshOrderedList {
    GetOrderedDesignder *request = [[GetOrderedDesignder alloc] init];
    request.requirementid = self.requirement._id;
    
    [API getOrderedDesigner:request success:^{
        [self.tableView.header endRefreshing];
        [self.requirementDataManager refreshOrderedDesigners];
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - get specified cell
- (DesignerPlanStatusBaseCell *)loadCellWithDesigner:(Designer *)orderedDesigner withTableView:(UITableView *)tableView forIndex:(NSIndexPath *)path {
    NSString *status = orderedDesigner.plan.status;
    
    __block NSString *cellIdentifier;
    [StatusBlock matchPlan:status actions:
     @[[PlanHomeOwnerOrdered action:^{
            cellIdentifier = HomeOwnerOrderedWithoutResponseIdentifier;
        }],
       [PlanDesignerResponded action:^{
            cellIdentifier = DesignerRespondedWithoutMeasureHouseIdentifier;
        }],
       [PlanDesignerSubmittedPlan action:^{
            cellIdentifier = DesignerSubmittedPlanIdentifier;
        }],
       [PlanWasChoosed action:^{
            cellIdentifier = [RequirementBusiness isDesignRequirement:self.requirement.work_type] ? PlanWasChoosedForDesignIdentifier : PlanWasChoosedIdentifier;
        }],
       [PlanDesignerDeclined action:^{
            cellIdentifier = DesignerDeclineHomeOwnerIdentifier;
        }],
       [PlanWasNotChoosed action:^{
            cellIdentifier = PlanWasNotChoosedIdentifier;
        }],
       [PlanDesignerMeasuredHouse action:^{
            cellIdentifier = DesignerMeasureHouseWithoutPlanIdentifier;
        }],
       [PlanDesignerRespondExpired action:^{
            cellIdentifier = ExpiredAsDesignerDidNotRespondIdentifier;
        }],
       [PlanDesignerSubmitPlanExpired action:^{
            cellIdentifier = ExpiredAsDesignerDidNotProvidePlanInSpecifiedTimeIdentifier;
        }],
       [ElseStatus action:^{
            cellIdentifier = PlanExpiredIdentifier;
        }],
       ]];
    
    DesignerPlanStatusBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:path];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self);
    [self.requirement merge:orderedDesigner.requirement];
    [cell initWithDesigner:orderedDesigner withRequirement:self.requirement withBlock:^{
        @strongify(self);
        [self refreshOrderedList];
    }];
    return cell;
}

@end
