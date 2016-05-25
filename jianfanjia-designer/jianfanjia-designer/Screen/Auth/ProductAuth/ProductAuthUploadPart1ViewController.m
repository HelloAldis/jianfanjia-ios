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
            _product = product;
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
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [EditCellItem registerCells:self.tableView];

    self.sectionArr1 = @[
                         [EditCellItem createSelection:@"所在城市" value:[self isNewProd] ? nil : [NSString stringWithFormat:@"%@ %@ %@", self.product.province, self.product.city, self.product.district] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             
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
                         [EditCellItem createField:@"小区名字" value:self.product.cell placeholder:@"请输入"],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createSelection:@"装修类型" value:[NameDict nameForDecType:self.product.dec_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             
                             SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForDecType:value];
                                 self.product.dec_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.dec_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"装修户型" value:[NameDict nameForDecStyle:self.product.house_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             
                             SelectHouseTypeViewController *controller = [[SelectHouseTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForHouseType:value];
                                 self.product.house_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.house_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }],
                         [EditCellItem createAttrField:[@"建筑面积 (m²)" attrSubStr:@"(m²)" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:self.product.house_area ? [[NSMutableAttributedString alloc] initWithString:[self.product.house_area stringValue]] : nil placeholder:@"请输入" length:6 isNumber:YES],
                         [EditCellItem createSelection:@"装修风格" value:[NameDict nameForDecStyle:self.product.dec_style] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                         
                             SelectDecorationStyleViewController *controller = [[SelectDecorationStyleViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForDecStyle:value];
                                 self.product.dec_style = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.dec_style];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }],
                         [EditCellItem createSelection:@"包工类型" value:[NameDict nameForWorkType:self.product.work_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             
                             SelectWorkTypeViewController *controller = [[SelectWorkTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForWorkType:value];
                                 self.product.work_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.product.work_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }],
                         [EditCellItem createAttrField:[@"装修造价 (万元)" attrSubStr:@"(万元)" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:self.product.total_price ? [[NSMutableAttributedString alloc] initWithString:[self.product.total_price stringValue]] : nil placeholder:@"请输入" length:3 isNumber:YES],
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
