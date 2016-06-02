//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductAuthUploadPart1ViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"

#define kBottomInsert 80

@interface ProductAuthUploadPart1ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr2;
@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@property (nonatomic, strong) Product *product;

@end

@implementation ProductAuthUploadPart1ViewController

- (instancetype)initWithProduct:(Product *)product {
    if (self = [super init]) {
        if (product) {
            _product = [[Product alloc] init];
            [_product merge:product];
        } else {
            _product = [[Product alloc] init];
            _product._id = @"";
            _product.plan_images = [[NSMutableArray alloc] init];
            _product.images = [[NSMutableArray alloc] init];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
        @strongify(self);
        if (isShowing) {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert + keyboardRect.size.height, 0);
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
            UIView *view = [self.tableView getFirstResponder];
            CGRect rect = [self.tableView convertRect:view.bounds fromView:view.superview];
            [self.tableView scrollRectToVisible:rect animated:YES];
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
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
    label.attributedText = [@"上传作品(1/2)" attrSubStr:@"(1/2)" font:nil color:kThemeColor];
    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [EditCellItem registerCells:self.tableView];
    
    @weakify(self);
    self.sectionArr1 = @[
                         [EditCellItem createSelection:@"所在城市" value:[self isNewProd] ? nil : [NSString stringWithFormat:@"%@ %@ %@", self.product.province, self.product.city, self.product.district] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectCityViewController *controller = [[SelectCityViewController alloc] initWithAddress:nil valueBlock:^(id value) {
                                 curItem.value = value;
                                 NSArray *addressArr = [value componentsSeparatedByString:@" "];
                                 self.product.province = addressArr[0];
                                 self.product.city = addressArr[1];
                                 self.product.district = addressArr[2];
                                 
                                 [self.tableView reloadData];
                             } limitCity:NO];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createField:@"小区名字" value:self.product.cell placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.product.cell = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createSelection:@"装修类型" value:[NameDict nameForDecType:self.product.dec_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForDecType:value];
                                 self.product.dec_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.dec_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"装修户型" value:[NameDict nameForDecStyle:self.product.house_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectHouseTypeViewController *controller = [[SelectHouseTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForHouseType:value];
                                 self.product.house_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.house_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }],
                         [EditCellItem createAttrField:[@"建筑面积 (m²)" attrSubStr:@"(m²)" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:self.product.house_area ? [[NSMutableAttributedString alloc] initWithString:[self.product.house_area stringValue]] : nil placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.product.house_area = @([curItem.value integerValue]);
                             }
                         } length:6 keyboard:UIKeyboardTypeNumberPad],
                         [EditCellItem createSelection:@"装修风格" value:[NameDict nameForDecStyle:self.product.dec_style] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectDecorationStyleViewController *controller = [[SelectDecorationStyleViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForDecStyle:value];
                                 self.product.dec_style = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.dec_style];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }],
                         [EditCellItem createSelection:@"包工类型" value:[NameDict nameForWorkType:self.product.work_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectWorkTypeViewController *controller = [[SelectWorkTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForWorkType:value];
                                 self.product.work_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.work_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }],
                         [EditCellItem createAttrField:[@"装修造价 (万元)" attrSubStr:@"(万元)" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:self.product.total_price ? [[NSMutableAttributedString alloc] initWithString:[self.product.total_price stringValue]] : nil placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.product.total_price = @([curItem.value floatValue]);
                             }
                         } length:6 keyboard:UIKeyboardTypeDecimalPad],
                         ];
    
    self.totalArr = [NSMutableArray array];
    [self.totalArr addObjectsFromArray:self.sectionArr1];
    [self.totalArr addObjectsFromArray:self.sectionArr2];
    [self refreshNextButtonStatus];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionArr1.count;
    } else if (section == 1) {
        return self.sectionArr2.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - user action
- (void)onClickNext {
    [ViewControllerContainer showProductAuthUploadPart2:self.product];
}

#pragma mark - other
- (BOOL)isNewProd {
    return self.product == nil || self.product._id == nil || [self.product._id isEqualToString:@""];
}

- (void)refreshNextButtonStatus {
    [[RACObserve(self, totalArr) flattenMap:^RACStream *(NSArray *items) {
        NSMutableArray *signals = [NSMutableArray array];
        for (EditCellItem *item in items) {
            [signals addObject:RACObserve(item, value)];
        }
        
        return [RACSignal combineLatest:(signals)];
    }] subscribeNext:^(RACTuple *tuple) {
        __block BOOL isAllInputed = YES;
        [tuple.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]|| [obj length] == 0) {
                isAllInputed = NO;
                *stop = YES;
            }
        }];
        
        self.navigationItem.rightBarButtonItem.enabled = isAllInputed;
    }];
}

@end
