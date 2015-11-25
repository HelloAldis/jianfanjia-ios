//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessViewController.h"
#import "BannerCell.h"
#import "SectionCell.h"
#import "ItemCell.h"
#import "ItemExpandImageCell.h"
#import "API.h"
#import "ProcessDataManager.h"

typedef NS_ENUM(NSInteger, WorkSiteMode) {
    WorkSiteModePreview,
    WorkSiteModeReal,
};

typedef NS_ENUM(NSInteger, SectionOperationStatus) {
    SectionOperationStatusRefresh,
    SectionOperationStatusSwitchItemCell,
};

static NSString *ItemExpandCellIdentifier = @"ItemExpandImageCell";
static NSString *ItemCellIdentifier = @"ItemCell";

@interface ProcessViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *WorkProcedureScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *processid;
@property (assign, nonatomic) SectionOperationStatus currentSectionOperationStatus;
@property (assign, nonatomic) WorkSiteMode workSiteMode;
@property (strong, nonatomic) ProcessDataManager *processDataManager;

@end

@implementation ProcessViewController

#pragma mark - init method
- (id)initWithProcess:(NSString *)processid withMode:(WorkSiteMode)mode {
    if (self = [super init]) {
        _workSiteMode = mode;
        _processid = processid;
        _processDataManager = [[ProcessDataManager alloc] init];
    }
    
    return self;
}

- (id)initWithProcess:(NSString *)processid {
    return [self initWithProcess:processid withMode:WorkSiteModeReal];
}

- (id)initWithProcessPreview {
    return [self initWithProcess:nil withMode:WorkSiteModePreview];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"工地管理";
}

- (void)initUI {
    [self.tableView registerNib:[UINib nibWithNibName:ItemCellIdentifier bundle:nil] forCellReuseIdentifier:ItemCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    if (self.workSiteMode == WorkSiteModeReal) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refresh];
        }];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.processDataManager.selectedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentSectionOperationStatus == SectionOperationStatusRefresh) {
        ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ItemExpandImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemExpandCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSectionOperationStatus = SectionOperationStatusSwitchItemCell;
    Item *item = self.processDataManager.selectedItems[indexPath.row];
    [item switchItemCellStatus];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.processDataManager.selectedItems[indexPath.row];
    [item switchItemCellStatus];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)refresh {
    if (self.workSiteMode == WorkSiteModePreview) {
        [self.processDataManager refreshSections:[ProcessBusiness defaultProcess]];
        [self.processDataManager switchToSelectedSection:0];
        [self.tableView reloadData];
    } else {
        GetProcess *request = [[GetProcess alloc] init];
        request.processid = [GVUserDefaults standardUserDefaults].processid;
        
        [API getProcess:request success:^{
            [self.tableView.header endRefreshing];
            self.currentSectionOperationStatus = SectionOperationStatusRefresh;
            [self.processDataManager refreshProcess];
            [self.tableView reloadData];
        } failure:^{
            
        }];
    }
}


@end
