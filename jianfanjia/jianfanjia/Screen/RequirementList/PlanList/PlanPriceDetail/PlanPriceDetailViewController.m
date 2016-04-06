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
#import "PlanPriceItemExpandCell.h"
#import "PlanPriceTotalCell.h"
#import "PlanPriceTotalPkg365Cell.h"

static NSString *PlanCellIdentifier = @"PlanPriceItemCell";
static NSString *PlanPriceItemExpandCellIdentifier = @"PlanPriceItemExpandCell";
static NSString *PlanPriceTotalCellIdentifier = @"PlanPriceTotalCell";
static NSString *PlanPriceTotalPkg365CellIdentifier = @"PlanPriceTotalPkg365Cell";

@interface PlanPriceDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation PlanPriceDetailViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan requirement:(Requirement *)requirement {
    if (self = [super init]) {
        _plan = plan;
        _requirement = requirement;
        _requirementDataManager = [[RequirementDataManager alloc] init];
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:PlanCellIdentifier bundle:nil] forCellReuseIdentifier:PlanCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanPriceItemExpandCellIdentifier bundle:nil] forCellReuseIdentifier:PlanPriceItemExpandCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanPriceTotalCellIdentifier bundle:nil] forCellReuseIdentifier:PlanPriceTotalCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:PlanPriceTotalPkg365CellIdentifier bundle:nil] forCellReuseIdentifier:PlanPriceTotalPkg365CellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 8, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self initNav];
    [self loadData];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"方案报价";
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.requirementDataManager.planPriceItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([RequirementBusiness isPkg365ByType:self.requirement.package_type]) {
            PlanPriceTotalPkg365Cell *cell = [tableView dequeueReusableCellWithIdentifier:PlanPriceTotalPkg365CellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell initWithPlan:self.plan];
            
            return cell;
        } else {
            PlanPriceTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanPriceTotalCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell initWithPlan:self.plan];

            return cell;
        }
    } else {
        if ([indexPath isEqual:self.selectedIndexPath]) {
            PlanPriceItemExpandCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanPriceItemExpandCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell initWithPriceItem:self.requirementDataManager.planPriceItems[indexPath.row]];
            
            return cell;
        } else {
            PlanPriceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:PlanCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell initWithPriceItem:self.requirementDataManager.planPriceItems[indexPath.row]];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return [PlanPriceItemSection sectionView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *preSeleted = self.selectedIndexPath;
    if ([self.selectedIndexPath isEqual:indexPath]) {
        self.selectedIndexPath = nil;
    } else {
        self.selectedIndexPath = indexPath;
    }

    if (indexPath.section == 0) {
        //do nothing
    } else {
        PriceItem *item = self.requirementDataManager.planPriceItems[indexPath.row];
        if ([item.price_description trim].length > 0) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:preSeleted ? @[indexPath, preSeleted] : @[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
}

#pragma mark - load data
- (void)loadData {
    [self.requirementDataManager refreshPlanPriceItems:self.plan];
    [self.tableView reloadData];
}

@end
