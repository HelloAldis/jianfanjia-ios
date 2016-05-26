//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TeamAuthUpdateViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"
#import "IDAuthIDCardImageCell.h"
#import "InfoAuthImageHeaderView.h"

static NSString *IDAuthIDCardImageCellIdentifier = @"IDAuthIDCardImageCell";

@interface TeamAuthUpdateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Team *team;
@property (nonatomic, strong) NSString *idCardFrontImageid;
@property (nonatomic, strong) NSString *idCardBackImageid;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr2;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr3;

@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@end

@implementation TeamAuthUpdateViewController

- (instancetype)initWithTeam:(Team *)team {
    if (self = [super init]) {
        if (team) {
            _team = team;
        } else {
            _team = [[Team alloc] init];
            _team._id = @"";
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
    self.title = [self isNewTeam] ? @"添加施工团队" : @"更新施工团队";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:IDAuthIDCardImageCellIdentifier bundle:nil] forCellReuseIdentifier:IDAuthIDCardImageCellIdentifier];
    [EditCellItem registerCells:self.tableView];
    
    self.idCardFrontImageid = self.team.uid_image1;
    self.idCardBackImageid = self.team.uid_image2;
    self.sectionArr1 = @[
                         [EditCellItem createField:@"项目经理" value:self.team.manager placeholder:@"请输入真实姓名" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.team.manager = curItem.value;
                             }
                         }],
                         [EditCellItem createSelection:@"性别" value:[NameDict nameForSexType:self.team.sex] placeholder:nil tapBlock:^(EditCellItem *curItem) {
                             SelectSexTypeViewController *controller = [[SelectSexTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForSexType:value];
                                 self.team.sex = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.team.sex];
                             controller.selectSexType = SelectSexTypeUserSex;
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"所在地区" value:[self isNewTeam] ? nil : [NSString stringWithFormat:@"%@ %@ %@", self.team.province, self.team.city, self.team.district] placeholder:nil tapBlock:^(EditCellItem *curItem) {
                             SelectCityViewController *controller = [[SelectCityViewController alloc] initWithAddress:nil valueBlock:^(id value) {
                                 curItem.value = value;
                                 NSArray *addressArr = [value componentsSeparatedByString:@" "];
                                 self.team.province = addressArr[0];
                                 self.team.city = addressArr[1];
                                 self.team.district = addressArr[2];
                                 
                                 [self.tableView reloadData];
                             } limitCity:YES];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createField:@"身份证号" value:self.team.uid placeholder:@"请输入15位或18位或带x身份证号码" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.team.uid = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createField:@"曾就职公司" value:self.team.company placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.team.company = curItem.value;
                             }
                         }],
                         [EditCellItem createField:@"工作年限" value:[self.team.work_year stringValue] placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.team.work_year = @([curItem.value integerValue]);
                             }
                         }],
                         [EditCellItem createSelection:@"擅长工种" value:self.team.good_at placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             SelectGoodAtViewController *controller = [[SelectGoodAtViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = value;
                                 self.team.good_at = value;
                                 [self.tableView reloadData];
                             } curValue:self.team.good_at];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createField:@"正在施工工地" value:self.team.working_on placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.team.working_on = curItem.value;
                             }
                         }],
                         ];
    
    self.totalArr = [NSMutableArray array];
    [self.totalArr addObjectsFromArray:self.sectionArr1];
    [self.totalArr addObjectsFromArray:self.sectionArr2];
    [self.totalArr addObjectsFromArray:self.sectionArr3];
    [self refreshNextButtonStatus];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return kInfoAuthImageHeaderViewHeight;
    }
    
    if (section == 0 || section == 1 || section == 3) {
        return 10;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        InfoAuthImageHeaderView *header = [InfoAuthImageHeaderView infoAuthImageHeaderView];
        header.lblTitle.text = @"上传身份证";
        return header;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionArr1.count;
    } else if (section == 1) {
        return self.sectionArr2.count;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return self.sectionArr3.count;;
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
    } else if (indexPath.section == 2) {
        IDAuthIDCardImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IDAuthIDCardImageCellIdentifier forIndexPath:indexPath];
        [cell initWithTeam:self.team actionBlock:^(CardImageAction action, CardImageType type) {
            if (type == CardImageTypeFront) {
                self.idCardFrontImageid = self.team.uid_image1;
            } else {
                self.idCardBackImageid = self.team.uid_image2;
            }
            
            [self.tableView reloadData];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.sectionArr1[indexPath.row] cellheight];
    } else if (indexPath.section == 1) {
        return [self.sectionArr2[indexPath.row] cellheight];
    } else if (indexPath.section == 2) {
        return kIDAuthIDCardImageCellHeight;
    } else if (indexPath.section == 3) {
        return [self.sectionArr3[indexPath.row] cellheight];
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onClickNext {
    [self.view endEditing:YES];
    
    if ([self isNewTeam]) {
        DesignerUpdateTeam *request = [[DesignerUpdateTeam alloc] initWithTeam:self.team];
        
        [HUDUtil showWait];
        [API designerAddTeam:request success:^{
            [HUDUtil hideWait];
            [self.navigationController popViewControllerAnimated:YES];
            [HUDUtil showSuccessText:@"添加成功"];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    } else {
        DesignerUpdateTeam *request = [[DesignerUpdateTeam alloc] initWithTeam:self.team];
        
        [HUDUtil showWait];
        [API designerUpdateTeam:request success:^{
            [HUDUtil hideWait];
            [self.navigationController popViewControllerAnimated:YES];
            [HUDUtil showSuccessText:@"更新成功"];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    }
}

#pragma mark - other
- (BOOL)isNewTeam {
    return self.team == nil || self.team._id == nil || [self.team._id isEqualToString:@""];
}

- (void)refreshNextButtonStatus {
    @weakify(self);
    [[RACObserve(self, totalArr) flattenMap:^RACStream *(NSArray *items) {
        @strongify(self)
        NSMutableArray *signals = [NSMutableArray array];
        [signals addObject:RACObserve(self, idCardFrontImageid)];
        [signals addObject:RACObserve(self, idCardBackImageid)];
        for (EditCellItem *item in items) {
            [signals addObject:RACObserve(item, value)];
        }
        
        return [RACSignal combineLatest:signals];
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
