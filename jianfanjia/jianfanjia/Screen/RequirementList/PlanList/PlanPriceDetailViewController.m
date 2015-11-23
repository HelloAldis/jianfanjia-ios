//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanPriceDetailViewController.h"
#import "RequirementDataManager.h"
#import "PlanPriceItemCell.h"
#import "PlanPriceItemSection.h"

static NSString *PlanCellIdentifier = @"PlanPriceItemCell";

@interface PlanPriceDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectTotalPriceVal;
@property (weak, nonatomic) IBOutlet UILabel *lblProgramTotalPriceVal;
@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@end

@implementation PlanPriceDetailViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan {
    if (self = [super init]) {
        _plan = plan;
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
    [self loadData];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"方案报价";
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requirementDataManager.planPriceItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlanPriceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanCellIdentifier forIndexPath:indexPath];
    [cell initWithPriceItem:self.requirementDataManager.planPriceItems[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [PlanPriceItemSection sectionView];
}

#pragma mark - load data
- (void)loadData {
    [self.requirementDataManager refreshPlanPriceItems:self.plan];
    [self.tableView reloadData];
    self.lblProjectTotalPriceVal.text = [NSString stringWithFormat:@"%@", self.plan.project_price_after_discount];
    self.lblProgramTotalPriceVal.text = [NSString stringWithFormat:@"%@", self.plan.total_price];
}

@end
