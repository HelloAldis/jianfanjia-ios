//
//  DesignerViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerViewController.h"
#import "DesignerInfoCell.h"
#import "DesignerSectionCell.h"
#import "DesignerDetailCell.h"
#import "DesignerProductCell.h"
#import "DesignerPageData.h"

@interface DesignerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DesignerPageData *designerPageData;
@property (weak, nonatomic) DesignerSectionCell *section;
@property (assign, nonatomic) BOOL isShowProductList;


@end

@implementation DesignerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerInfoCell" bundle:nil] forCellReuseIdentifier:@"DesignerInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerDetailCell" bundle:nil] forCellReuseIdentifier:@"DesignerDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerProductCell" bundle:nil] forCellReuseIdentifier:@"DesignerProductCell"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.needRefreshDesignerViewController = YES;
    self.isShowProductList = NO;
    self.designerPageData = [[DesignerPageData alloc] init];
    
    [self initLeftBackInNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefreshDesignerViewController) {
        [self refreshDesigner];
        [self refreshProduct];
    }
}

#pragma mark - UI


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.designerPageData.designer) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (self.designerPageData.designer) {
            if (self.isShowProductList) {
                return self.designerPageData.products.count;
            } else {
                return 1;
            }
        } else {
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DesignerInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerInfoCell"];
        [cell initWithDesigner:self.designerPageData.designer];
        return cell;
    } else {
        if (self.isShowProductList) {
            DesignerProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerProductCell"];
            [cell initWithProduct:[self.designerPageData.products objectAtIndex:indexPath.row]];
            return cell;
        } else {
            DesignerDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerDetailCell"];
            [cell initWithDesigner:self.designerPageData.designer];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 260;
    } else {
        if (self.isShowProductList) {
            return 284;
        } else {
            return 310;
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
        if (self.section) {
            return self.section;
        } else {
            self.section = [DesignerSectionCell sectionView];
            [self.section.btnProduct addTarget:self action:@selector(onClickProduct) forControlEvents:UIControlEventTouchUpInside];
            [self.section.btnDetail addTarget:self action:@selector(onClickDetail) forControlEvents:UIControlEventTouchUpInside];
        }
   
        
        return self.section;
    }
}

#pragma mark - User Action
- (void)onClickDetail {
    if (self.isShowProductList) {
        self.isShowProductList = NO;
        [self.section.btnDetail setTitleColor:[UIColor colorWithR:52 g:74 b:93] forState:UIControlStateNormal];
        [self.section.btnProduct setTitleColor:[UIColor colorWithR:170 g:177 b:182] forState:UIControlStateNormal];
        self.tableView.footer = nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)onClickProduct {
    if (!self.isShowProductList) {
        self.isShowProductList = YES;
        [self.section.btnProduct setTitleColor:[UIColor colorWithR:52 g:74 b:93] forState:UIControlStateNormal];
        [self.section.btnDetail setTitleColor:[UIColor colorWithR:170 g:177 b:182] forState:UIControlStateNormal];
        
        @weakify(self);
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreProduct];
        }];
        
        if (!self.designerPageData.products) {
            [self loadMoreProduct];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Util
- (void)refreshDesigner {
    DesignerHomePage *request = [[DesignerHomePage alloc] init];
    request._id = self.designerid;
    
    @weakify(self);
    [API designerHomePage:request success:^{
        @strongify(self);
        [self.designerPageData refreshDesigner];
        self.needRefreshDesignerViewController = NO;
        [self.tableView reloadData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)refreshProduct {
    QueryProduct *request = [[QueryProduct alloc] init];
    request.query = @{@"designerid":self.designerid};
    request.from = @0;
    request.limit = @10;
    
    @weakify(self);
    [API queryProduct:request success:^{
        @strongify(self);
        [self.designerPageData refreshProduct];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)loadMoreProduct {
    QueryProduct *request = [[QueryProduct alloc] init];
    request.query = @{@"designerid":self.designerid};
    request.from = @(self.designerPageData.products.count);
    request.limit = @10;
    
    @weakify(self);
    [API queryProduct:request success:^{
        @strongify(self);
        [self.designerPageData loadMoreProduct];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}


@end
