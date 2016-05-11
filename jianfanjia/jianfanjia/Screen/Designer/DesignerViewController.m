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
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) DesignerPageData *designerPageData;
@property (weak, nonatomic) DesignerSectionCell *section;
@property (assign, nonatomic) BOOL isShowProductList;
@property (assign, nonatomic) BOOL isJiangXinDingZhi;
@property (assign, nonatomic) BOOL wasMovedInfoCellToTop;
@property (strong, nonatomic) DesignerInfoCell *infoCell;


@end

@implementation DesignerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

- (void)initNav {
    [self initLeftBackInNav];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerInfoCell" bundle:nil] forCellReuseIdentifier:@"DesignerInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerDetailCell" bundle:nil] forCellReuseIdentifier:@"DesignerDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerProductCell" bundle:nil] forCellReuseIdentifier:@"DesignerProductCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.estimatedRowHeight = kDesignerInfoCellHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
  
    self.needRefreshDesignerViewController = YES;
    self.isShowProductList = NO;
    self.designerPageData = [[DesignerPageData alloc] init];
}

- (void)reLayoutUI {
    self.wasMovedInfoCellToTop = NO;
    if (self.isJiangXinDingZhi) {
        [self configFullScreenStyle];
        [self configTransparentNavStyle];
    } else {
        [self configDefaultStyle];
        [self configDefaultNavStyle];
    }
}

- (void)configFullScreenStyle {
    CGFloat extraHeight = kScreenHeight - kDesignerInfoCellHeight - 50;
    self.tableView.contentInset = UIEdgeInsetsMake(extraHeight, 0, 0, 0);
    self.backgroundImage.alpha = 1;
    self.tableView.scrollEnabled = NO;
    [self enableInfoCellTransparent:YES];
}

- (void)configDefaultStyle {
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.backgroundImage.alpha = 0;
    self.tableView.scrollEnabled = YES;
    [self enableInfoCellTransparent:NO];
}

- (void)configTransparentNavStyle {
    [self initTranslucentNavBar];
    [self initLeftWhiteBackInNav];
}

- (void)configDefaultNavStyle {
    [self initDefaultNavBarStyle];
    [self initLeftBackInNav];
}

- (void)moveDesignerInfoToTop {
    if (self.isJiangXinDingZhi && !self.wasMovedInfoCellToTop) {
        self.wasMovedInfoCellToTop = YES;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self configDefaultStyle];
        } completion:^(BOOL finished) {
            [self configDefaultNavStyle];
        }];
    }
}

- (void)initInfoCell {
    DesignerInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerInfoCell"];
    [cell initWithDesigner:self.designerPageData.designer];
    self.infoCell = cell;
}

- (void)initSectionView {
    self.section = [DesignerSectionCell sectionView];
    [self.section.btnDetail addTarget:self action:@selector(onClickDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.section.btnProduct addTarget:self action:@selector(onClickProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.section.btnDetail setNormTitleColor:[UIColor colorWithR:52 g:74 b:93]];
    [self.section.btnProduct setNormTitleColor:self.isJiangXinDingZhi ? [UIColor colorWithR:52 g:74 b:93] : [UIColor colorWithR:170 g:177 b:182]];
}

- (void)enableInfoCellTransparent:(BOOL)trans {
    if (self.infoCell) {
        [self.infoCell enableTransaparent:trans];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefreshDesignerViewController) {
        self.needRefreshDesignerViewController = NO;
        self.tableView.hidden = YES;
        [self refreshDesigner];
        [self refreshProduct];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self initDefaultNavBarStyle];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self adjustTopView];
    
    if (!scrollView.isDecelerating) {
        if (self.presentingViewController && scrollView.contentOffset.y < -(kNavWithStatusBarHeight + 30)) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)adjustTopView {
    if (self.tableView.contentOffset.y >= -kNavWithStatusBarHeight && self.tableView.contentOffset.y <= 200) {
        CGFloat dy = self.tableView.contentOffset.y - 110;
        self.title = dy > 0 ? self.designerPageData.designer.username : nil;
    }
}

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
        return self.infoCell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        if (self.section) {
            return self.section;
        } else {
            [self initSectionView];
            return self.section;
        }
    }
}

#pragma mark - User Action
- (void)onClickDetail {
    [self moveDesignerInfoToTop];
    [self.section.btnDetail setNormTitleColor:[UIColor colorWithR:52 g:74 b:93]];
    [self.section.btnProduct setNormTitleColor:[UIColor colorWithR:170 g:177 b:182]];
    
    if (self.isShowProductList) {
        self.isShowProductList = NO;
        self.tableView.footer = nil;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)onClickProduct {
    [self moveDesignerInfoToTop];
    [self.section.btnProduct setNormTitleColor:[UIColor colorWithR:52 g:74 b:93]];
    [self.section.btnDetail setNormTitleColor:[UIColor colorWithR:170 g:177 b:182]];
    
    if (!self.isShowProductList) {
        self.isShowProductList = YES;
        @weakify(self);
        self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreProduct];
        }];
        
        if (!self.designerPageData.products) {
            [self loadMoreProduct];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - Util
- (void)refreshDesigner {
    DesignerHomePage *request = [[DesignerHomePage alloc] init];
    request._id = self.designerid;
    
    [HUDUtil showWait];
    @weakify(self);
    [API designerHomePage:request success:^{
        @strongify(self);
        [self.designerPageData refreshDesigner];
        self.isJiangXinDingZhi = [DesignerBusiness containsJiangXinDingZhiTag:self.designerPageData.designer.tags];
        [self initInfoCell];
        [self reLayoutUI];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        [HUDUtil hideWait];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
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
        NSInteger count = [self.designerPageData refreshProduct];
        [self.tableView.footer endRefreshing];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
        NSInteger count = [self.designerPageData loadMoreProduct];
        [self.tableView.footer endRefreshing];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        };
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}


@end
