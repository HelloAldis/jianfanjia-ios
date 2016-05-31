//
//  ProductViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductInfoCell.h"
#import "ProductImageCell.h"
#import "HorizontalImageCell.h"
#import "ViewControllerContainer.h"
#import "ProductPageData.h"

@interface ProductViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ProductPageData *productPageData;

@end

@implementation ProductViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:@"ProductInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductImageCell" bundle:nil] forCellReuseIdentifier:@"ProductImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HorizontalImageCell" bundle:nil] forCellReuseIdentifier:@"HorizontalImageCell"];
    
    self.needRefreshProductViewController = YES;
    self.productPageData = [[ProductPageData alloc] init];
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefreshProductViewController) {
        [self refresh];
    }
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"作品详情";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.productPageData.product.images.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductInfoCell"];
        [cell initWithProduct:self.productPageData.product];
        return cell;
    } else if (indexPath.section == 1) {
        HorizontalImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HorizontalImageCell"];
        [cell initWithImages:[self.productPageData.product.plan_images map:^id(id obj) {
            return obj[@"imageid"];
        }]];
        return cell;
    } else if (indexPath.section == 2) {
        ProductImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProductImageCell"];
        [cell initWithProductImage:[self.productPageData.product imageAtIndex:indexPath.row]
                          andIndex:indexPath.row
                         andImages:self.productPageData.product.images];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return self.productPageData.product.plan_images.count > 0 ? kHorizontalImageCellHeight + 20 : 0.0;
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDecelerating) {
        if (self.presentingViewController && scrollView.contentOffset.y < -(scrollView.contentInset.top + 30)) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - user action
- (void)onClickBack {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [super onClickBack];
    }
}

- (void)onClickEdit {
    [ViewControllerContainer showProductAuthUploadPart1:self.productPageData.product];
}

#pragma mark - Util
- (void)refresh {
    ProductHomePage *request = [[ProductHomePage alloc] init];
    request._id = self.productid;
    
    @weakify(self);
    [API designerGetOneProduct:request success:^{
        @strongify(self);
        [self.productPageData refresh];
        [self initRightNavItem];
        self.needRefreshProductViewController = NO;
        [self.tableView reloadData];
    } failure:^{
    } networkError:^{
        
    }];
}

#pragma mark - other 
- (void)initRightNavItem {
    if (![self.productPageData.product.auth_type isEqualToString:kProductAuthTypeUnsubmitVerify]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    }
}

@end
