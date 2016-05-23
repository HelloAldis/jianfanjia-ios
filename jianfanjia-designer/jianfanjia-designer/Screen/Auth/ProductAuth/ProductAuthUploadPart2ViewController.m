//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductAuthUploadPart2ViewController.h"
#import "ViewControllerContainer.h"
#import "ProductAuthDataManager.h"
#import "ProductAuthImageHeaderView.h"
#import "ProductAuthImageFooterView.h"
#import "ProductAuthProductDescriptionCell.h"

static NSString *ProductAuthProductDescriptionCellIdentifier = @"ProductAuthProductDescriptionCell";

@interface ProductAuthUploadPart2ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ProductAuthDataManager *dataManager;
@property (nonatomic, strong) Product *product;

@property (nonatomic, strong) ProductAuthImageFooterView *addPlanView;
@property (nonatomic, strong) ProductAuthImageFooterView *addImpressionView;

@end

@implementation ProductAuthUploadPart2ViewController

- (instancetype)initWithProduct:(Product *)product {
    if (self = [super init]) {
        if (product) {
            _product = product;
        } else {
            _product = [[Product alloc] init];
            _product._id = @"";
        }
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kThemeTextColor;
    label.font = [UIFont systemFontOfSize:17];
    label.attributedText = [@"上传作品(2/2)" attrSubStr:@"(2/2)" font:nil color:kThemeColor];
    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.dataManager = [[ProductAuthDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:ProductAuthProductDescriptionCellIdentifier bundle:nil] forCellReuseIdentifier:ProductAuthProductDescriptionCellIdentifier];
    
    @weakify(self);
    self.addPlanView = [ProductAuthImageFooterView productAuthImageFooterView];
    self.addPlanView.tapBlock = ^{
        @strongify(self);
        [self onTapAddPlanImg];
    };
    
    self.addImpressionView = [ProductAuthImageFooterView productAuthImageFooterView];
    self.addImpressionView.tapBlock = ^{
        @strongify(self);
        [self onTapAddImpressoinImg];
    };
    
    [self refresh];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    
    return kProductAuthImageHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    }
    
    return kProductAuthImageFooterViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        ProductAuthImageHeaderView *header = [ProductAuthImageHeaderView productAuthImageHeaderView];
        header.lblTitle.text = @"上传平面图";
        return header;
    } else if (section == 2) {
        ProductAuthImageHeaderView *header = [ProductAuthImageHeaderView productAuthImageHeaderView];
        header.lblTitle.text = @"上传效果图";
        return header;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return self.addPlanView;
    } else if (section == 2) {
        return self.addImpressionView;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductAuthProductDescriptionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductAuthProductDescriptionCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
//    if (indexPath.section == 0) {
//        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
//        return cell;
//    } else if (indexPath.section == 1) {
//        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
//        return cell;
//    }
//    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kProductAuthProductDescriptionCellHeight;
    }
    
    return 0;
}

#pragma mark - api request
- (void)refresh {
    [self.tableView reloadData];
}

#pragma mark - user action
- (void)onTapAddPlanImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        
    }];
}

- (void)onTapAddImpressoinImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addImpressionView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        
    }];
}

- (void)onClickNext {
    DesignerUploadProduct *request = [[DesignerUploadProduct alloc] initWithProduct:self.product];
}

@end
