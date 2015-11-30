//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "OrderDesignerViewController.h"
#import "MatchDesignerCell.h"
#import "IntentDesignerCell.h"
#import "MatchDesignerSection.h"
#import "IntentDesignerSection.h"
#import "RequirementDataManager.h"

typedef NS_ENUM(NSInteger, OrderDesignerOrderType) {
    NormalOrder,
    ReplaceOrder,
};

@interface OrderDesignerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *orderableDesigners;
@property (strong, nonatomic) Requirement *requirement;
@property (strong, nonatomic) NSString *toBeReplacedDesignerId;
@property (strong, nonatomic) RequirementDataManager *requirementDataManager;
@property (assign, nonatomic) OrderDesignerOrderType orderType;
@property (assign, nonatomic) NSInteger orderableCount;

@property (assign, nonatomic) BOOL isChooseAll;

@end

@implementation OrderDesignerViewController

#pragma mark - init method
- (id)initWithRequirement:(Requirement *)requirement withOrderType:(OrderDesignerOrderType)type {
    if (self = [super init]) {
        _requirement = requirement;
        _orderType = type;
        _requirementDataManager = [[RequirementDataManager alloc] init];
    }
    
    return self;
}

- (id)initWithRequirement:(Requirement *)requirement {
    return [self initWithRequirement:requirement withOrderType:NormalOrder];
}

- (id)initWithRequirement:(Requirement *)requirement withToBeReplacedDesigner:(NSString *)designerid {
    if ([self initWithRequirement:requirement withOrderType:ReplaceOrder]) {
        _toBeReplacedDesignerId = designerid;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"MatchDesignerCell" bundle:nil] forCellReuseIdentifier:@"MatchDesignerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntentDesignerCell" bundle:nil] forCellReuseIdentifier:@"IntentDesignerCell"];
    
    [self initData];
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshOrderableList];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
    
    UIView *customeTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    lblCount.text = [NSString stringWithFormat:@"%ld", (long)self.orderableCount];
    lblCount.textAlignment = NSTextAlignmentRight;
    lblCount.textColor = kFinishedColor;
    lblCount.font = [UIFont systemFontOfSize:17];
    UILabel *fixedString = [[UILabel alloc] initWithFrame:CGRectMake(lblCount.frame.size.width, 0, 100, 44)];
    fixedString.text = @" 位可预约";
    fixedString.textColor = kThemeTextColor;
    fixedString.font = [UIFont systemFontOfSize:17];
    [customeTitleView addSubview:lblCount];
    [customeTitleView addSubview:fixedString];
    self.navigationItem.titleView = customeTitleView;
}

#pragma mark - init data 
- (void)initData {
    [self.requirementDataManager refreshOrderedDesigners:self.requirement];
    if (self.orderType == NormalOrder) {
        self.orderableCount = kMaxOrderableDesignerCount - self.requirementDataManager.orderedDesigners.count;
    } else {
        self.orderableCount = 1;
    }
}


#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.requirementDataManager.recommendedDesigners.count;
    } else {
        return self.requirementDataManager.favoriteDesigners.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MatchDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchDesignerCell" forIndexPath:indexPath];
        [cell initWithDesigner:self.requirementDataManager.recommendedDesigners[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        IntentDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntentDesignerCell" forIndexPath:indexPath];
        [cell initWithDesigner:self.requirementDataManager.favoriteDesigners[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.requirementDataManager.recommendedDesigners.count > 0) {
            return 44;
        }
    } else {
        if (self.requirementDataManager.favoriteDesigners.count > 0) {
            return 44;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MatchDesignerSection *section = [MatchDesignerSection sectionView];
        [section.btnChooseAll addTarget:self action:@selector(onChooseAll) forControlEvents:UIControlEventTouchUpInside];
        return section;
    } else {
        IntentDesignerSection *section = [IntentDesignerSection sectionView];
        return section;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableView indexPathsForSelectedRows].count == self.orderableCount
        && ![[self.tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        return nil;
    }
    
    return indexPath;
}

#pragma mark - user action
- (void)onChooseAll {
    self.isChooseAll = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onClickDone {
    NSInteger selectedCount = [self.tableView indexPathsForSelectedRows].count;
    
    if (selectedCount == 0) {
        return;
    }
    
    __block NSMutableArray *arr = [NSMutableArray arrayWithCapacity:selectedCount];
    @weakify(self);
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:obj];
        
        NSString *designerId;
        if (obj.section == 0) {
            MatchDesignerCell *matchCell = (MatchDesignerCell *)cell;
            designerId = matchCell.designer._id;
        } else {
            IntentDesignerCell *intentCell = (IntentDesignerCell *)cell;
            designerId = intentCell.designer._id;
        }
        
        [arr addObject:designerId];
    }];
    
    
    if (self.orderType == NormalOrder) {
        OrderDesignder *orderDesigner = [[OrderDesignder alloc] init];
        orderDesigner.requirementid = self.requirement._id;
        orderDesigner.designerids = arr;
        
        [API orderDesigner:orderDesigner success:^{
            [self clickBack];
        } failure:^{
            
        }];
    } else {
        ReplaceOrderedDesigner *request = [[ReplaceOrderedDesigner alloc] init];
        request.requirementid = self.requirement._id;
        request.old_designerid = self.toBeReplacedDesignerId;
        request.replaced_designerid = arr[0];
        
        [API replaceOrderedDesigner:request success:^{
            [self clickBack];
        } failure:^{
            
        }];
    }
}

#pragma mark - send request 
- (void)refreshOrderableList {
    GetOrderableDesigners *request = [[GetOrderableDesigners alloc] init];
    request.requirementid = self.requirement._id;
    
    [API getOrderableDesigners:request success:^{
        [self.requirementDataManager refreshOrderableDesigners];
        [self.tableView reloadData];
    } failure:^{
    
    }];
}

@end
