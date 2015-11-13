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

@interface DesignerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet DesignerSectionCell *section;
@property (assign, nonatomic) BOOL isShowProductList;

@end

@implementation DesignerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerInfoCell" bundle:nil] forCellReuseIdentifier:@"DesignerInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerDetailCell" bundle:nil] forCellReuseIdentifier:@"DesignerDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerProductCell" bundle:nil] forCellReuseIdentifier:@"DesignerProductCell"];
    
    [self initNav];
    [self refresh];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isShowProductList = NO;
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([DataManager shared].designerPageDesigner) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if ([DataManager shared].designerPageDesigner) {
            if (self.isShowProductList) {
                return [DataManager shared].designerPageProducts.count;
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
        [cell initWithDesigner:[DataManager shared].designerPageDesigner];
        return cell;
    } else {
        if (self.isShowProductList) {
            DesignerProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerProductCell"];
            [cell initWithProduct:[[DataManager shared].designerPageProducts objectAtIndex:indexPath.row]];
            return cell;
        } else {
            DesignerDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerDetailCell"];
            [cell initWithDesigner:[DataManager shared].designerPageDesigner];
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
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadProduct];
        }];
        
        if (![DataManager shared].designerPageProducts) {
            [self loadProduct];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Util
- (void)refresh {
    DesignerHomePage *request = [[DesignerHomePage alloc] init];
    request._id = self.designerid;
    
    [API designerHomePage:request success:^{
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

- (void)loadProduct {
    QueryProduct *request = [[QueryProduct alloc] init];
    request.query = @{@"designerid":self.designerid};
    request.from = @([DataManager shared].designerPageProducts.count);
    request.limit = @10;
    
    [API queryProduct:request success:^{
        [self.tableView.footer endRefreshing];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^{
        
    }];
}


@end
