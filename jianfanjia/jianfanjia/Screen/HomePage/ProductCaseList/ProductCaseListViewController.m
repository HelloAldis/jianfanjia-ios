//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProductCaseListViewController.h"
#import "ProductCaseCell.h"
#import "DropdownMenuView.h"
#import "ProductCaseListDataManager.h"

typedef NS_ENUM(NSInteger, ProductCaseFilterType) {
    ProductCaseFilterTypeHouseArea,
    ProductCaseFilterTypeDecType,
    ProductCaseFilterTypeHouseType,
    ProductCaseFilterTypeDecStyle,
};

static NSString *ProductCaseCellIdentifier = @"ProductCaseCell";
static NSString *UnlimitedValue = @"不限";
static NSMutableArray *houseAreaDS;
static NSMutableArray *decTypeDS;
static NSMutableArray *houseTypeDS;
static NSMutableArray *decStyleDS;

@interface ProductCaseListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

@property (strong, nonatomic) DropdownMenuView *dropdownMenu;
@property (assign, nonatomic) ProductCaseFilterType productCaseFilterType;
@property (strong, nonatomic) NSString *curProductCaseFilterTypeHouseArea;
@property (strong, nonatomic) NSString *curProductCaseFilterTypeDecType;
@property (strong, nonatomic) NSString *curProductCaseFilterTypeHouseType;
@property (strong, nonatomic) NSString *curProductCaseFilterTypeDecStyle;

@property (strong, nonatomic) ProductCaseListDataManager *dataManager;

@end

@implementation ProductCaseListViewController

#pragma mark - init
+ (void)initialize {
    if ([self class] == [ProductCaseListViewController class]) {
        houseAreaDS = [[NameDict getAllDisplayHouseArea] sortedValueWithOrder:YES];
        decTypeDS = [[NameDict getAllDecorationType] sortedValueWithOrder:YES];
        houseTypeDS = [[NameDict getAllHouseType] sortedValueWithOrder:YES];
        decStyleDS = [[NameDict getAllDecorationStyle] sortedValueWithOrder:YES];
        
        [houseAreaDS insertObject:UnlimitedValue atIndex:0];
        [decTypeDS insertObject:UnlimitedValue atIndex:0];
        [houseTypeDS insertObject:UnlimitedValue atIndex:0];
        [decStyleDS insertObject:UnlimitedValue atIndex:0];
    }
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"全部案例";
    [self initLeftBackInNav];
}

- (void)initUI {
    self.dataManager = [[ProductCaseListDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:ProductCaseCellIdentifier bundle:nil] forCellReuseIdentifier:ProductCaseCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.curProductCaseFilterTypeHouseArea = UnlimitedValue;
    self.curProductCaseFilterTypeDecType = UnlimitedValue;
    self.curProductCaseFilterTypeHouseType = UnlimitedValue;
    self.curProductCaseFilterTypeDecStyle = UnlimitedValue;
    
    [self refresh];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCaseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductCaseCellIdentifier];
    [cell initWithProduct:self.dataManager.products[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kProductCaseCellHeight;
}

#pragma mark - user action
- (void)onClickButton:(UIButton *)button {
    @weakify(self);
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self highlightTypeButton:idx highlight:obj == button title:nil];
    }];
    
    [self showDropdown:button];
}

- (void)showDropdown:(UIButton *)button {
    NSInteger buttonIndex = [self.btnChooseTypes indexOfObject:button];
    if (self.productCaseFilterType == buttonIndex && self.dropdownMenu && self.dropdownMenu.isShowing) {
        [self highlightTypeButton:self.productCaseFilterType highlight:NO title:nil];
        [self.dropdownMenu dismiss];
        return;
    }
    
    self.productCaseFilterType = buttonIndex;
    
    NSMutableArray *datasource = nil;
    NSString *defaultValue = nil;
    if (self.productCaseFilterType == ProductCaseFilterTypeHouseArea) {
        datasource = houseAreaDS;
        defaultValue = self.curProductCaseFilterTypeHouseArea;
    } else if (self.productCaseFilterType == ProductCaseFilterTypeDecType) {
        datasource = decTypeDS;
        defaultValue = self.curProductCaseFilterTypeDecType;
    } else if (self.productCaseFilterType == ProductCaseFilterTypeHouseType) {
        datasource = houseTypeDS;
        defaultValue = self.curProductCaseFilterTypeHouseType;
    } else if (self.productCaseFilterType == ProductCaseFilterTypeDecStyle) {
        datasource = decStyleDS;
        defaultValue = self.curProductCaseFilterTypeDecStyle;
    }
    
    @weakify(self);
    if (self.dropdownMenu && self.dropdownMenu.isShowing) {
        [self.dropdownMenu refreshDatasource:datasource defaultValue:defaultValue];
    } else {
        self.dropdownMenu = [DropdownMenuView show:self.tableView datasource:datasource defaultValue:defaultValue block:^(id value) {
            @strongify(self);
            if (value) {
                if (self.productCaseFilterType == ProductCaseFilterTypeHouseArea) {
                    self.curProductCaseFilterTypeHouseArea = value;
                } else if (self.productCaseFilterType == ProductCaseFilterTypeDecType) {
                    self.curProductCaseFilterTypeDecType = value;
                } else if (self.productCaseFilterType == ProductCaseFilterTypeHouseType) {
                    self.curProductCaseFilterTypeHouseType = value;
                } else if (self.productCaseFilterType == ProductCaseFilterTypeDecStyle) {
                    self.curProductCaseFilterTypeDecStyle = value;
                }
                
                //update fall flow data
                [self refresh];
            }
            
            if ([value isEqualToString:UnlimitedValue]) {
                [self highlightTypeButton:self.productCaseFilterType highlight:NO title:[self getDefaultTypeButtonTitle]];
            } else {
                [self highlightTypeButton:self.productCaseFilterType highlight:NO title:value];
            }
        }];
    }
}

- (NSString *)getDefaultTypeButtonTitle {
    NSString *buttonTitle;
    switch (self.productCaseFilterType) {
        case ProductCaseFilterTypeHouseArea:
            buttonTitle = @"面积";
            break;
        case ProductCaseFilterTypeDecType:
            buttonTitle = @"类型";
            break;
        case ProductCaseFilterTypeHouseType:
            buttonTitle = @"户型";
            break;
        case ProductCaseFilterTypeDecStyle:
            buttonTitle = @"风格";
            break;
            
        default:
            break;
    }
    
    return buttonTitle;
}

- (void)highlightTypeButton:(NSInteger)idx highlight:(BOOL)highlight title:(NSString *)title {
    UILabel *label = self.lblChooseTypes[idx];
    UIImageView *imgView = self.angleImages[idx];
    if (title) {
        [label setText:title];
    }
    
    [label setTextColor:highlight ? kThemeTextColor : kUntriggeredColor];
    [imgView setImage:[UIImage imageNamed:highlight ? @"angle_expand" : @"angle_unexpand" ]];
}

#pragma mark - api request
- (void)refresh {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
    SearchProduct *request = [[SearchProduct alloc] init];
    request.query = [self getQueryDic];
    request.from = @0;
    request.limit = @20;
    
    [API searchProduct:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refresh];
        
        if (count == 0) {
            [self handleNoProduct];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMore {
    SearchProduct *request = [[SearchProduct alloc] init];
    request.query = [self getQueryDic];
    request.from = @(self.dataManager.products.count);
    request.limit = @20;
    
    [API searchProduct:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

- (NSDictionary *)getQueryDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (![self.curProductCaseFilterTypeHouseArea isEqualToString:UnlimitedValue]) {
        NSString *key = [[[NameDict getAllDisplayHouseArea] allKeysForObject:self.curProductCaseFilterTypeHouseArea] lastObject];
        NSString *value = [[NameDict getAllValueHouseArea] valueForKey:key];
        [dic setObject:value forKey:@"house_area"];
    }
    if (![self.curProductCaseFilterTypeDecType isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllDecorationType] allKeysForObject:self.curProductCaseFilterTypeDecType] lastObject] forKey:@"dec_type"];
    }
    
    if (![self.curProductCaseFilterTypeHouseType isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllHouseType] allKeysForObject:self.curProductCaseFilterTypeHouseType] lastObject] forKey:@"house_type"];
    }
    
    if (![self.curProductCaseFilterTypeDecStyle isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllDecorationStyle] allKeysForObject:self.curProductCaseFilterTypeDecStyle] lastObject] forKey:@"dec_style"];
    }
    
    return dic;
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoProduct {
    self.lblNoData.text = @"没有找到任何匹配的作品";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_product"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
