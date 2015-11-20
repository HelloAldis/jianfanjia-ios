//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanListViewController.h"
#import "RequirementDataManager.h"
#import "PlanCell.h"

static NSString *PlanCellIdentifier = @"PlanCell";

@interface PlanListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) NSString *designerid;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@end

@implementation PlanListViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:PlanCellIdentifier bundle:nil] forCellReuseIdentifier:PlanCellIdentifier];
    
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshPlanList];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requirementDataManager.requirementPlans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanCellIdentifier forIndexPath:indexPath];
    [cell initWithPlan:self.requirementDataManager.requirementPlans[indexPath.row] withOrder:indexPath.row + 1 forRequirement:self.requirement];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}

#pragma mark - send request 
- (void)refreshPlanList {
    GetRequirementPlans *request = [[GetRequirementPlans alloc] init];
    request.designerid = self.designerid;
    request.requirementid = self.requirement._id;
    
    [API getRequirementPlans:request success:^{
        [self.requirementDataManager refreshRequirementPlans];
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

@end
