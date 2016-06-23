//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetListViewController.h"
#import "DiarySetUploadCell.h"
#import "DiarySetCell.h"
#import "DiarySetDataManager.h"

static NSString *DiarySetUploadCellIdentifier = @"DiarySetUploadCell";
static NSString *DiarySetCellIdentifier = @"DiarySetCell";

@interface DiarySetListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DiarySetDataManager *dataManager;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) BOOL wasFirstRefresh;

@end

@implementation DiarySetListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.wasFirstRefresh) {
        self.wasFirstRefresh = YES;
        [self.tableView.header beginRefreshing];
    } else {
        [self refresh];
    }
}

#pragma mark - UI
- (void)initNav {
    self.title = @"我的日记本";
    [self initLeftBackInNav];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
//    self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.dataManager = [[DiarySetDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:DiarySetUploadCellIdentifier bundle:nil] forCellReuseIdentifier:DiarySetUploadCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DiarySetCellIdentifier bundle:nil] forCellReuseIdentifier:DiarySetCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.dataManager.diarySets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DiarySetUploadCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiarySetUploadCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    DiarySetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiarySetCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithDiarySet:self.dataManager.diarySets[indexPath.row] edit:self.isEditing deleteBlock:^{
        [self.dataManager.diarySets removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kDiarySetUploadCellHeight;
    }
    
    return kDiarySetCellHeight;
}

#pragma mark - api request
- (void)refresh {
    [self.tableView.footer resetNoMoreData];
    
    SearchDiarySet *request = [[SearchDiarySet alloc] init];
    request.from = @0;
    request.limit = @20;
    
    [API getMyDiarySet:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refresh];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMore {
    SearchDiarySet *request = [[SearchDiarySet alloc] init];
    request.from = @(self.dataManager.diarySets.count);
    request.limit = @20;
    
    [API getMyDiarySet:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - user action
- (void)onClickEdit {
    self.isEditing = !self.isEditing;
    
    if (self.isEditing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
    [self.tableView reloadData];
}

@end
