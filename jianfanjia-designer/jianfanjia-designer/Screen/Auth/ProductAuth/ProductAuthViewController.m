//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductAuthViewController.h"
#import "ProductUploadCell.h"
#import "ProductAuthCell.h"
#import "ProductCountTipSection.h"
#import "ProductAuthDataManager.h"

static NSString *ProductUploadCellIdentifier = @"ProductUploadCell";
static NSString *ProductAuthCellIdentifier = @"ProductAuthCell";

@interface ProductAuthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ProductAuthDataManager *dataManager;
@property (assign, nonatomic) BOOL isEditing;

@end

@implementation ProductAuthViewController

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
    self.title = @"我的作品";
    [self initLeftBackInNav];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.dataManager = [[ProductAuthDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:ProductUploadCellIdentifier bundle:nil] forCellReuseIdentifier:ProductUploadCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ProductAuthCellIdentifier bundle:nil] forCellReuseIdentifier:ProductAuthCellIdentifier];
    
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
    if (section == 0) {
        return 0.1;
    }
    
    return [self.dataManager authedProductCount] < kMinAuthedProductCount ? kProductCountTipSectionHeight : 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        NSInteger totalCount = self.dataManager.products.count;
        NSInteger authedCount = [self.dataManager authedProductCount];
        if (totalCount == 0) {
            ProductCountTipSection *header = [ProductCountTipSection productCountTipSection];
            header.lblTitle.text = [NSString stringWithFormat:@"认证条件：您至少需要认证%@个以上的作品，才可以被预约", @(kMinAuthedProductCount)];
            return header;
        } else if (authedCount < kMinAuthedProductCount) {
            ProductCountTipSection *header = [ProductCountTipSection productCountTipSection];
            header.lblTitle.text = [NSString stringWithFormat:@"您还需要认证%@个作品", @(kMinAuthedProductCount - authedCount)];
            return header;
        }
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.dataManager.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductUploadCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductUploadCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    ProductAuthCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductAuthCellIdentifier forIndexPath:indexPath];
    [cell initWithProduct:self.dataManager.products[indexPath.row] edit:self.isEditing deleteBlock:^{
        [self.dataManager.products removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kProductUploadCellHeight;
    }
    
    return kProductAuthCellHeight;
}

#pragma mark - api request
- (void)refresh {
    [self.tableView.footer resetNoMoreData];
    
    DesignerGetProducts *request = [[DesignerGetProducts alloc] init];
    request.from = @0;
    request.limit = @20;
    
    [API designerGetProducts:request success:^{
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
    DesignerGetProducts *request = [[DesignerGetProducts alloc] init];
    request.from = @(self.dataManager.products.count);
    request.limit = @20;
    
    [API designerGetProducts:request success:^{
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
