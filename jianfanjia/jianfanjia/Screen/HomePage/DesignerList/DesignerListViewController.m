//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerListViewController.h"
#import "DesignerSimpleInfoCell.h"
#import "DropdownMenuView.h"
#import "DesignerListDataManager.h"

typedef NS_ENUM(NSInteger, DesignFilterType) {
    DesignFilterTypeDecType,
    DesignFilterTypeHouseType,
    DesignFilterTypeStyle,
    DesignFilterTypeDesignFee,
};

static NSString *DesignerSimpleInfoCellIdentifier = @"DesignerSimpleInfoCell";
static NSString *UnlimitedValue = @"不限";
static NSMutableArray *decTypeDS;
static NSMutableArray *houseTypeDS;
static NSMutableArray *decStyleDS;
static NSMutableArray *designFeeDS;

@interface DesignerListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

@property (strong, nonatomic) DropdownMenuView *dropdownMenu;
@property (assign, nonatomic) DesignFilterType designFilterType;
@property (strong, nonatomic) NSString *curDesignFilterTypeDecType;
@property (strong, nonatomic) NSString *curDesignFilterTypeHouseType;
@property (strong, nonatomic) NSString *curDesignFilterTypeStyle;
@property (strong, nonatomic) NSString *curDesignFilterTypeDesignFee;

@property (strong, nonatomic) DesignerListDataManager *dataManager;

@end

@implementation DesignerListViewController

#pragma mark - init
+ (void)initialize {
    if ([self class] == [DesignerListViewController class]) {
        decTypeDS = [[NameDict getAllDecorationType] sortedValueWithOrder:YES];
        houseTypeDS = [[NameDict getAllHouseType] sortedValueWithOrder:YES];
        decStyleDS = [[NameDict getAllDecorationStyle] sortedValueWithOrder:YES];
        designFeeDS = [[NameDict getAllDesignFee] sortedValueWithOrder:YES];
        
        [decTypeDS insertObject:UnlimitedValue atIndex:0];
        [houseTypeDS insertObject:UnlimitedValue atIndex:0];
        [decStyleDS insertObject:UnlimitedValue atIndex:0];
        [designFeeDS insertObject:UnlimitedValue atIndex:0];
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
    self.title = @"全部设计师";
    [self initLeftBackInNav];
}

- (void)initUI {
    self.dataManager = [[DesignerListDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight + CGRectGetHeight(self.headerView.frame), 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:DesignerSimpleInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DesignerSimpleInfoCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
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
    
    self.curDesignFilterTypeDecType = UnlimitedValue;
    self.curDesignFilterTypeHouseType = UnlimitedValue;
    self.curDesignFilterTypeStyle = UnlimitedValue;
    self.curDesignFilterTypeDesignFee = UnlimitedValue;
    
    [self refresh];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.designers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DesignerSimpleInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DesignerSimpleInfoCellIdentifier];
    [cell initWithDesigner:self.dataManager.designers[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDesignerSimpleInfoCellHeight;
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
    if (self.designFilterType == buttonIndex && self.dropdownMenu && self.dropdownMenu.isShowing) {
        [self highlightTypeButton:self.designFilterType highlight:NO title:nil];
        [self.dropdownMenu dismiss:YES];
        return;
    }
    
    self.designFilterType = buttonIndex;
    
    NSMutableArray *datasource = nil;
    NSString *defaultValue = nil;
    if (self.designFilterType == DesignFilterTypeDecType) {
        datasource = decTypeDS;
        defaultValue = self.curDesignFilterTypeDecType;
    } else if (self.designFilterType == DesignFilterTypeHouseType) {
        datasource = houseTypeDS;
        defaultValue = self.curDesignFilterTypeHouseType;
    } else if (self.designFilterType == DesignFilterTypeStyle) {
        datasource = decStyleDS;
        defaultValue = self.curDesignFilterTypeStyle;
    } else if (self.designFilterType == DesignFilterTypeDesignFee) {
        datasource = designFeeDS;
        defaultValue = self.curDesignFilterTypeDesignFee;
    }
    
    @weakify(self);
    if (self.dropdownMenu && self.dropdownMenu.isShowing) {
        [self.dropdownMenu refreshDatasource:datasource defaultValue:defaultValue];
    } else {
        self.dropdownMenu = [DropdownMenuView showIn:self.view belowTo:self.headerView.frame datasource:datasource defaultValue:defaultValue block:^(id value) {
            @strongify(self);
            if (value) {
                if (self.designFilterType == DesignFilterTypeDecType) {
                    self.curDesignFilterTypeDecType = value;
                } else if (self.designFilterType == DesignFilterTypeHouseType) {
                    self.curDesignFilterTypeHouseType = value;
                } else if (self.designFilterType == DesignFilterTypeStyle) {
                    self.curDesignFilterTypeStyle = value;
                } else if (self.designFilterType == DesignFilterTypeDesignFee) {
                    self.curDesignFilterTypeDesignFee = value;
                }
                
                //update fall flow data
                [self refresh];
            }
            
            if ([value isEqualToString:UnlimitedValue]) {
                [self highlightTypeButton:self.designFilterType highlight:NO title:[self getDefaultTypeButtonTitle]];
            } else {
                [self highlightTypeButton:self.designFilterType highlight:NO title:value];
            }
        }];
    }
}

- (NSString *)getDefaultTypeButtonTitle {
    NSString *buttonTitle;
    switch (self.designFilterType) {
        case DesignFilterTypeDecType:
            buttonTitle = @"类型";
            break;
        case DesignFilterTypeHouseType:
            buttonTitle = @"户型";
            break;
        case DesignFilterTypeStyle:
            buttonTitle = @"风格";
            break;
        case DesignFilterTypeDesignFee:
            buttonTitle = @"报价";
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
    
    SearchDesigner *request = [[SearchDesigner alloc] init];
    request.query = [self getQueryDic];
    request.from = @0;
    request.limit = @20;
    
    [API searchDesigner:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refresh];
        
        if (count == 0) {
            [self handleNoDesigner];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMore {
    SearchDesigner *request = [[SearchDesigner alloc] init];
    request.query = [self getQueryDic];
    request.from = @(self.dataManager.designers.count);
    request.limit = @20;
    
    [API searchDesigner:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
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
    if (![self.curDesignFilterTypeDecType isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllDecorationType] allKeysForObject:self.curDesignFilterTypeDecType] lastObject] forKey:@"dec_types"];
    }
    if (![self.curDesignFilterTypeHouseType isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllHouseType] allKeysForObject:self.curDesignFilterTypeHouseType] lastObject] forKey:@"dec_house_types"];
    }
    if (![self.curDesignFilterTypeStyle isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllDecorationStyle] allKeysForObject:self.curDesignFilterTypeStyle] lastObject] forKey:@"dec_styles"];
    }
    if (![self.curDesignFilterTypeDesignFee isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllDesignFee] allKeysForObject:self.curDesignFilterTypeDesignFee] lastObject] forKey:@"design_fee_range"];
    }
    
    return dic;
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoDesigner {
    self.lblNoData.text = @"没有找到任何匹配的设计师";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_designer"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
