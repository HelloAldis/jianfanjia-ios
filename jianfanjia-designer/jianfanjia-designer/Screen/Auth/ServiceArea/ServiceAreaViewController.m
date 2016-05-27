//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ServiceAreaViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"


@interface ServiceAreaViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Designer *designer;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr2;

@end

@implementation ServiceAreaViewController

- (instancetype)initWithDesigner:(Designer *)designer {
    if (self = [super init]) {
        _designer = designer;
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
    self.title = @"接单范围";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [EditCellItem registerCells:self.tableView];

    self.sectionArr1 = @[
                         [EditCellItem createSelection:@"装修类型" value:[self decTypesStr] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.dec_types = value;
                                 curItem.value = [self decTypesStr];
                                 [self.tableView reloadData];
                             } curValues:self.designer.dec_types];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"包工类型" value:[self workTypeStr] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectWorkTypeViewController *controller = [[SelectWorkTypeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.work_types = value;
                                 curItem.value = [self workTypeStr];
                                 [self.tableView reloadData];
                             } curValues:self.designer.work_types];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createAttrSelection:[@"擅长风格 最多三项" attrSubStr:@"最多三项" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:[[NSMutableAttributedString alloc] initWithString:[self decStyleStr]] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectDecorationStyleViewController *controller = [[SelectDecorationStyleViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.dec_styles = value;
                                 curItem.attrValue.mutableString.string = [self decStyleStr];
                                 [self.tableView reloadData];
                             } curValues:self.designer.dec_styles];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createSelection:@"接单区域" value:[self serviceAreaStr] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectServiceAreaViewController *controller = [[SelectServiceAreaViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.dec_districts = value;
                                 curItem.value = [self serviceAreaStr];
                                 [self.tableView reloadData];
                             } curValues:self.designer.dec_districts];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"意向接单户型" value:[self houseTypeStr] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectHouseTypeViewController *controller = [[SelectHouseTypeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.dec_house_types = value;
                                 curItem.value = [self houseTypeStr];
                                 [self.tableView reloadData];
                             } curValues:self.designer.dec_house_types];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createAttrSelection:[@"设计费报价 元/m²" attrSubStr:@"元/m²" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:[[NSMutableAttributedString alloc] initWithString:[NameDict nameForDesignerFee:self.designer.design_fee_range]] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectDesignFeeViewController *controller = [[SelectDesignFeeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.design_fee_range = value;
                                 curItem.attrValue.mutableString.string = [NameDict nameForDesignerFee:self.designer.design_fee_range];
                                 [self.tableView reloadData];
                             } curValue:self.designer.design_fee_range];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createAttrSelection:[@"施工费报价 元/m²" attrSubStr:@"元/m²" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:[[NSMutableAttributedString alloc] initWithString:[self workFeeStr]] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectWorkFeeViewController *controller = [[SelectWorkFeeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.dec_fee_half = @([value[0] integerValue]);
                                 self.designer.dec_fee_all = @([value[1] integerValue]);
                                 curItem.attrValue.mutableString.string = [self workFeeStr];
                                 [self.tableView reloadData];
                             } curValues:@[[self.designer.dec_fee_half stringValue], [self.designer.dec_fee_all stringValue]]];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"习惯沟通方式" value:[NameDict nameForCommunicationType:self.designer.communication_type] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectCommunicationTypeViewController *controller = [[SelectCommunicationTypeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.communication_type = value;
                                 curItem.value = [NameDict nameForCommunicationType:self.designer.communication_type];
                                 [self.tableView reloadData];
                             } curValue:self.designer.communication_type];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         
                         ];
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.sectionArr1[indexPath.row] cellheight];
    } else if (indexPath.section == 1) {
        return [self.sectionArr2[indexPath.row] cellheight];
    }
    
    return 0.0;
}

#pragma mark - other
- (NSString *)decTypesStr {
    return [[self.designer.dec_types map:^id(id obj) {
        return [NameDict nameForDecType:obj];
    }] join:@" "];
}

- (NSString *)decStyleStr {
    if (self.designer.dec_styles.count <= 4) {
        return [[self.designer.dec_styles map:^id(id obj) {
            return [NameDict nameForDecStyle:obj];
        }] join:@" "];
    }
    
    return @"点击查看";
}

- (NSString *)workTypeStr {
    return [[self.designer.work_types map:^id(id obj) {
        return [NameDict nameForWorkType:obj];
    }] join:@" "];
}

- (NSString *)houseTypeStr {
    if (self.designer.dec_house_types.count <= 6) {
        return [[self.designer.dec_house_types map:^id(id obj) {
            return [NameDict nameForHouseType:obj];
        }] join:@" "];
    }
    
    return @"点击查看";
}

- (NSString *)serviceAreaStr {
    return self.designer.dec_districts.count <= 4 ? [self.designer.dec_districts join:@" "] : @"点击查看";
}

- (NSString *)workFeeStr {
    return [NSString stringWithFormat:@"%@ / %@", self.designer.dec_fee_half ? self.designer.dec_fee_half : @"0", self.designer.dec_fee_all ? self.designer.dec_fee_all : @"0"];
}

@end
