//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MyProcessViewController.h"
#import "RequirementCreateViewController.h"
#import "ProcessDataManager.h"
#import "ProcessCell.h"
#import "ViewControllerContainer.h"

static NSString *ProcessCellId = @"ProcessCell";

@interface MyProcessViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *noProcessImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoProcessDesc;

@property (strong, nonatomic) ProcessDataManager *dataManager;

@end

@implementation MyProcessViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [[ProcessDataManager alloc] init];
    
    [self initUI];
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshProcessList:NO];
}

#pragma mark - init ui
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:ProcessCellId bundle:nil] forCellReuseIdentifier:ProcessCellId];
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshProcessList:NO];
    }];
    
    self.noProcessImageView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshProcessList:NO];
    }];
}

#pragma mark - nav
- (void)initNav {
    self.title = @"工地管理";
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataManager.processList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:ProcessCellId forIndexPath:indexPath];
    [cell initWithProcess:self.dataManager.processList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 246;
}

#pragma mark - user action
- (IBAction)onClickPreviewWorksite:(id)sender {
    [ViewControllerContainer showProcessPreview];
}

#pragma mark - send request 
- (void)refreshProcessList:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }

    GetDesignerProcess *getProcesss = [[GetDesignerProcess alloc] init];
    
    [API getDesignerProcess:getProcesss success:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
        [self.noProcessImageView.header endRefreshing];
        [self.dataManager refreshProcessList];
        [self showNoProcessImage:self.dataManager.processList.count == 0];
        [self.tableView reloadData];
    } failure:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
        [self.noProcessImageView.header endRefreshing];
    } networkError:^{
        [HUDUtil hideWait];
        [self.tableView.header endRefreshing];
        [self.noProcessImageView.header endRefreshing];
    }];
}

- (void)showNoProcessImage:(BOOL)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.lblNoProcessDesc.text = @"由于您的工地还没有开工，请及时查看需求状态，\n如果您想查看装修流程，我们已为您精心准备了工地模版";
        self.noProcessImageView.alpha = show ? 1 : 0;
        self.tableView.alpha = !show ? 1 : 0;
    } completion:nil];
}


@end
