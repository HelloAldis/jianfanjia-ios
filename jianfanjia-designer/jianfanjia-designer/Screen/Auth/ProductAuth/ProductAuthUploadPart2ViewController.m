//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductAuthUploadPart2ViewController.h"
#import "ViewControllerContainer.h"
#import "ProductAuthImageHeaderView.h"
#import "ProductAuthImageFooterView.h"
#import "ProductAuthProductDescriptionCell.h"
#import "ProductAuthPlanImageCell.h"
#import "ProductAuthImpressionImageCell.h"
#import "ReorderTableView.h"
#import "ProductAuthViewController.h"

#define kBottomInsert 80

static NSString *ProductAuthProductDescriptionCellIdentifier = @"ProductAuthProductDescriptionCell";
static NSString *ProductAuthPlanImageCellIdentifier = @"ProductAuthPlanImageCell";
static NSString *ProductAuthImpressionImageCellIdentifier = @"ProductAuthImpressionImageCell";

@interface ProductAuthUploadPart2ViewController ()

@property (weak, nonatomic) IBOutlet ReorderTableView *tableView;

@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) ProductAuthImageFooterView *addPlanView;
@property (nonatomic, strong) ProductAuthImageFooterView *addImpressionView;
@property (nonatomic, strong) ProductAuthProductDescriptionCell *productDescCell;

@property (nonatomic, strong) NSNumber *impressionImageCount;

@end

@implementation ProductAuthUploadPart2ViewController

- (instancetype)initWithProduct:(Product *)product {
    if (self = [super init]) {
        _product = product;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
        @strongify(self);
        if (isShowing) {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert + keyboardRect.size.height, 0);
            UIView *view = [self.tableView getFirstResponder];
            CGRect rect = [self.tableView convertRect:view.bounds fromView:view.superview];
            [self.tableView scrollRectToVisible:rect animated:YES];
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
        }
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jfj_unsubscribeKeyboard];
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
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
    
    self.impressionImageCount = @(self.product.images.count);
    [self refreshNextButtonStatus];
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
    self.impressionImageCount = @(self.product.images.count);
    [self.tableView reloadData];
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
    [self refresh];
}

- (void)onTapDeletePlanImg:(NSIndexPath *)indexPath {
    ProductImage *img = [self.product planImageAtIndex:indexPath.row];
    BOOL isCover = [self isCoverImg:img];
    [self.product.plan_images removeObjectAtIndex:indexPath.row];
    
    if (isCover && self.product.plan_images.count > 0) {
        ProductImage *img = [self.product planImageAtIndex:0];
        self.product.cover_imageid = img.imageid;
    }
    
    [self refresh];
}

- (void)onTapDeleteImpressionImg:(NSIndexPath *)indexPath {
    ProductImage *img = [self.product imageAtIndex:indexPath.row];
    BOOL isCover = [self isCoverImg:img];
    [self.product.images removeObjectAtIndex:indexPath.row];
    
    if (isCover && self.product.images.count > 0) {
        ProductImage *img = [self.product imageAtIndex:0];
        self.product.cover_imageid = img.imageid;
    }
    
    [self refresh];
}

- (void)onTapReplacePlanImg:(NSIndexPath *)indexPath {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:1 withBlock:^(NSArray *imageIds) {
        ProductImage *img = [self.product planImageAtIndex:indexPath.row];
        if ([self isCoverImg:img]) {
            self.product.cover_imageid = imageIds[0];
        }
        img.imageid = imageIds[0];
        
        [self refresh];
    }];
}

- (void)onTapReplaceImpressionImg:(NSIndexPath *)indexPath {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:1 withBlock:^(NSArray *imageIds) {
        ProductImage *img = [self.product imageAtIndex:indexPath.row];
        if ([self isCoverImg:img]) {
            self.product.cover_imageid = imageIds[0];
        }
        img.imageid = imageIds[0];
        
        [self refresh];
    }];
}

- (void)onTapAddPlanImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addPlanView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        NSArray *arr = [imageIds map:^id(id obj) {
            ProductImage *img = [[ProductImage alloc] init];
            img.imageid = obj;
            
            return img.data;
        }];
        
        [self.product.plan_images addObjectsFromArray:arr];
        [self refresh];
    }];
}

- (void)onTapAddImpressionImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addImpressionView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        NSArray *arr = [imageIds map:^id(id obj) {
            ProductImage *img = [[ProductImage alloc] init];
            img.section = @"客厅";
            img.imageid = obj;
            
            return img.data;
        }];
        
        if (self.product.images.count == 0 && arr.count > 0) {
            self.product.cover_imageid = arr[0][@"imageid"];
        }
        
        [self.product.images addObjectsFromArray:arr];
        [self refresh];
    }];
}

- (void)onClickNext {
    if ([self isNewProd]) {
        [HUDUtil showWait];
        DesignerUploadProduct *request = [[DesignerUploadProduct alloc] initWithProduct:self.product];
        
        [API designerUploadProduct:request success:^{
            [HUDUtil hideWait];
            [self navigateToOriginController];
            [HUDUtil showSuccessText:@"提交成功"];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    } else {
        [HUDUtil showWait];
        DesignerUploadProduct *request = [[DesignerUploadProduct alloc] initWithProduct:self.product];
        
        [API designerUpdateProduct:request success:^{
            [HUDUtil hideWait];
            [self navigateToOriginController];
            [HUDUtil showSuccessText:@"提交成功"];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    }
}

- (void)navigateToOriginController {
    UIViewController *popTo = nil;
    for (UIViewController *controller in [self.navigationController.viewControllers reverseObjectEnumerator]) {
        if ([controller isKindOfClass:[ProductAuthViewController class]]) {
            popTo = controller;
            break;
        }
    }
    
    [self.navigationController popToViewController:popTo animated:YES];
}

#pragma mark - other
- (BOOL)isNewProd {
    return self.product == nil || self.product._id == nil || [self.product._id isEqualToString:@""];
}

- (BOOL)isCoverImg:(ProductImage *)img {
    return [self.product.cover_imageid isEqualToString:img.imageid];
}

- (void)refreshNextButtonStatus {
    [[RACSignal combineLatest:@[
                               RACObserve(self, impressionImageCount),
                               RACObserve(self.product, product_description),
                               ]
                      reduce:^id(NSNumber *impressionImageCount, NSString *desc) {
                          if ([impressionImageCount integerValue] >= 1 && desc.length > 0) {
                              return @YES;
                          }
        
                          return @NO;
                      }] subscribeNext:^(id x) {
                          self.navigationItem.rightBarButtonItem.enabled = [x boolValue];
                      }];
}

@end
