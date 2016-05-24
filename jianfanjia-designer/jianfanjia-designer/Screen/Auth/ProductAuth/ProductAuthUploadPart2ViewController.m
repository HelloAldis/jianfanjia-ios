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
#import "ProductAuthPlanImageCell.h"
#import "ProductAuthImpressionImageCell.h"
#import "ReorderTableView.h"

static NSString *ProductAuthProductDescriptionCellIdentifier = @"ProductAuthProductDescriptionCell";
static NSString *ProductAuthPlanImageCellIdentifier = @"ProductAuthPlanImageCell";
static NSString *ProductAuthImpressionImageCellIdentifier = @"ProductAuthImpressionImageCell";

@interface ProductAuthUploadPart2ViewController ()

@property (weak, nonatomic) IBOutlet ReorderTableView *tableView;

@property (strong, nonatomic) ProductAuthDataManager *dataManager;
@property (nonatomic, strong) Product *product;

@property (nonatomic, strong) ProductAuthImageFooterView *addPlanView;
@property (nonatomic, strong) ProductAuthImageFooterView *addImpressionView;
@property (nonatomic, strong) ProductAuthProductDescriptionCell *productDescCell;

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -200, kScreenWidth, 200)];
    view.bgColor = [UIColor colorWithR:0xF1 g:0xF2 b:0xF4];
    [self.tableView addSubview:view];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:ProductAuthProductDescriptionCellIdentifier bundle:nil] forCellReuseIdentifier:ProductAuthProductDescriptionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ProductAuthPlanImageCellIdentifier bundle:nil] forCellReuseIdentifier:ProductAuthPlanImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ProductAuthImpressionImageCellIdentifier bundle:nil] forCellReuseIdentifier:ProductAuthImpressionImageCellIdentifier];
    
    @weakify(self);
    self.addPlanView = [ProductAuthImageFooterView productAuthImageFooterView];
    self.addPlanView.tapBlock = ^{
        @strongify(self);
        [self onTapAddPlanImg];
    };
    
    self.addImpressionView = [ProductAuthImageFooterView productAuthImageFooterView];
    self.addImpressionView.tapBlock = ^{
        @strongify(self);
        [self onTapAddImpressionImg];
    };
    
    [self refresh];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
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
        return self.product.plan_images.count;
    } else if (section == 2) {
        return self.product.images.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.productDescCell) {
            self.productDescCell = [self.tableView dequeueReusableCellWithIdentifier:ProductAuthProductDescriptionCellIdentifier forIndexPath:indexPath];
            [self.productDescCell initWithProduct:self.product];
            self.productDescCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return self.productDescCell;
    } else if (indexPath.section == 1) {
        ProductAuthPlanImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductAuthPlanImageCellIdentifier forIndexPath:indexPath];
        [cell initWithProduct:self.product image:[self.product planImageAtIndex:indexPath.row] actionBlock:^(ProductAuthImageAction action) {
            [self onTapAction:action indexPath:indexPath];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        ProductAuthImpressionImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductAuthImpressionImageCellIdentifier forIndexPath:indexPath];
        [cell initWithProduct:self.product image:[self.product imageAtIndex:indexPath.row] actionBlock:^(ProductAuthImageAction action) {
            [self onTapAction:action indexPath:indexPath];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kProductAuthProductDescriptionCellHeight;
    } else if (indexPath.section == 1) {
        return kProductAuthPlanImageCellHeight;
    } else if (indexPath.section == 2) {
        return kProductAuthImpressionImageCellHeight;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section == 1) {
        [self.product.plan_images exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    } else if (sourceIndexPath.section == 2) {
        [self.product.images exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    }
}

- (CGRect)orderTableView:(UITableView *)tableView dragViewRectAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectMake(20, 24, kScreenWidth - 20 * 2, 40);
}

- (BOOL)orderTableView:(UITableView *)tableView canDragAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else if (indexPath.section == 1) {
        return YES;
    } else if (indexPath.section == 2) {
        return YES;
    }
    
    return NO;
}

#pragma mark - api request
- (void)refresh {
//    [self.tableView reloadData];
}

#pragma mark - user action
- (void)onTapAction:(ProductAuthImageAction)action indexPath:(NSIndexPath *)indexPath {
    if (action == ProductAuthImageActionDelete) {
        if (indexPath.section == 1) {
            [self onTapDeletePlanImg:indexPath];
        } else if (indexPath.section == 2) {
            [self onTapDeleteImpressionImg:indexPath];
        }
    } else if (action == ProductAuthImageActionEdit) {
        if (indexPath.section == 1) {
            [self onTapReplacePlanImg:indexPath];
        } else if (indexPath.section == 2) {
            [self onTapReplaceImpressionImg:indexPath];
        }
    } else if (action == ProductAuthImageActionSetCover) {
        if (indexPath.section == 1) {
        } else if (indexPath.section == 2) {
            [self onTapSetCoverImg:indexPath];
        }
    }
}

- (void)onTapSetCoverImg:(NSIndexPath *)indexPath {
    ProductImage *img = [self.product imageAtIndex:indexPath.row];
    self.product.cover_imageid = img.imageid;
    [self.tableView reloadData];
}

- (void)onTapDeletePlanImg:(NSIndexPath *)indexPath {
    [self.product.plan_images removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)onTapDeleteImpressionImg:(NSIndexPath *)indexPath {
    [self.product.images removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)onTapReplacePlanImg:(NSIndexPath *)indexPath {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:1 withBlock:^(NSArray *imageIds) {
        ProductImage *img = [self.product planImageAtIndex:indexPath.row];
        img.imageid = imageIds[0];
        [self.tableView reloadData];
    }];
}

- (void)onTapReplaceImpressionImg:(NSIndexPath *)indexPath {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:1 withBlock:^(NSArray *imageIds) {
        ProductImage *img = [self.product imageAtIndex:indexPath.row];
        img.imageid = imageIds[0];
        [self.tableView reloadData];
    }];
}

- (void)onTapAddPlanImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        NSArray *arr = [imageIds map:^id(id obj) {
            ProductImage *img = [[ProductImage alloc] init];
            img.imageid = obj;
            
            return img;
        }];
        
        [self.product.plan_images insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndex:self.product.plan_images.count]];
        [self.tableView reloadData];
    }];
}

- (void)onTapAddImpressionImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addImpressionView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        NSArray *arr = [imageIds map:^id(id obj) {
            ProductImage *img = [[ProductImage alloc] init];
            img.section = @"客厅";
            img.imageid = obj;
            
            return img;
        }];
        
        [self.product.images insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndex:self.product.images.count]];
        [self.tableView reloadData];
    }];
}

- (void)onClickNext {
    DesignerUploadProduct *request = [[DesignerUploadProduct alloc] initWithProduct:self.product];
}

@end
