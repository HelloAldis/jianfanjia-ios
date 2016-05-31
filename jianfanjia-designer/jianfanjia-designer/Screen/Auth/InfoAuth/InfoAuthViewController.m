//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "InfoAuthViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"
#import "AvtarImageCell.h"
#import "InfoAuthImageHeaderView.h"
#import "ProductAuthImageFooterView.h"
#import "InfoAuthDiplomaImageCell.h"
#import "InfoAuthAwardImageCell.h"

static NSString *AvtarImageCellIdentifier = @"AvtarImageCell";
static NSString *InfoAuthDiplomaImageCellIdentifier = @"InfoAuthDiplomaImageCell";
static NSString *InfoAuthAwardImageCellIdentifier = @"InfoAuthAwardImageCell";

@interface InfoAuthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ProductAuthImageFooterView *addDiplomaView;
@property (nonatomic, strong) ProductAuthImageFooterView *addAwardView;

@property (nonatomic, strong) Designer *designer;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, strong) NSString *avatarImageid;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr2;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr3;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr5;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr6;

@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@end

@implementation InfoAuthViewController

- (instancetype)initWithDesigner:(Designer *)designer canEdit:(BOOL)canEdit {
    if (self = [super init]) {
        _designer = [[Designer alloc] init];
        [_designer merge:designer];
        _canEdit = canEdit;
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
    self.title = @"基本资料认证";
    
    if (self.canEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    }
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:AvtarImageCellIdentifier bundle:nil] forCellReuseIdentifier:AvtarImageCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:InfoAuthDiplomaImageCellIdentifier bundle:nil] forCellReuseIdentifier:InfoAuthDiplomaImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:InfoAuthAwardImageCellIdentifier bundle:nil] forCellReuseIdentifier:InfoAuthAwardImageCellIdentifier];
    [EditCellItem registerCells:self.tableView];
    
    @weakify(self);
    self.addDiplomaView = [ProductAuthImageFooterView productAuthImageFooterView];
    self.addDiplomaView.tapBlock = ^{
        @strongify(self);
        [self onTapAddDiplomaImg];
    };
    
    self.addAwardView = [ProductAuthImageFooterView productAuthImageFooterView];
    self.addAwardView.tapBlock = ^{
        @strongify(self);
        [self onTapAddAwardImg];
    };
    
    self.avatarImageid = self.designer.imageid;
    
    self.sectionArr2 = @[
                         [EditCellItem createField:@"姓名" value:self.designer.username placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.username = curItem.value;
                             }
                         }],
                         [EditCellItem createSelection:@"性别" value:[NameDict nameForSexType:self.designer.sex] placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectSexTypeViewController *controller = [[SelectSexTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForSexType:value];
                                 self.designer.sex = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.designer.sex];
                             controller.selectSexType = SelectSexTypeUserSex;
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"所在地区" value:self.designer.province && self.designer.city && self.designer.district ? [NSString stringWithFormat:@"%@ %@ %@", self.designer.province, self.designer.city, self.designer.district] : nil placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectCityViewController *controller = [[SelectCityViewController alloc] initWithAddress:nil valueBlock:^(id value) {
                                 curItem.value = value;
                                 NSArray *addressArr = [value componentsSeparatedByString:@" "];
                                 self.designer.province = addressArr[0];
                                 self.designer.city = addressArr[1];
                                 self.designer.district = addressArr[2];
                                 
                                 [self.tableView reloadData];
                             } limitCity:YES];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createText:@"邮寄详细地址" value:self.designer.address placeholder:nil itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.address = curItem.value;
                             }
                         }],
                         [EditCellItem createText:@"设计理念" value:self.designer.philosophy placeholder:nil itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.philosophy = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createField:@"毕业院校" value:self.designer.university placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.university = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr5 = @[
                         [EditCellItem createField:@"曾就职公司" value:self.designer.company placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.company = curItem.value;
                             }
                         }],
                         [EditCellItem createField:@"工作年限" value:[self.designer.work_year stringValue] placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.work_year = @([curItem.value integerValue]);
                             }
                         }],
                         ];
    
    self.sectionArr6 = @[
                         [EditCellItem createText:@"设计成就" value:self.designer.achievement placeholder:nil itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.achievement = curItem.value;
                             }
                         }],
                         ];
    
    self.totalArr = [NSMutableArray array];
    [self.totalArr addObjectsFromArray:self.sectionArr2];
    [self.totalArr addObjectsFromArray:self.sectionArr3];
    [self.totalArr addObjectsFromArray:self.sectionArr5];
    [self.totalArr addObjectsFromArray:self.sectionArr6];
    [self refreshNextButtonStatus];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0.1;
    }
    
    if (section == 0 || section == 2 || section == 4 || section == 5) {
        return 10;
    }
    
    return kInfoAuthImageHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 4 || section == 5) {
        return 0.1;
    }
    
    if (section == 3) {
        return [self isDiplomaImgEmpty] ? kProductAuthImageFooterViewHeight : 0.1;
    }
    
    return kProductAuthImageFooterViewHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        InfoAuthImageHeaderView *header = [InfoAuthImageHeaderView infoAuthImageHeaderView];
        header.lblTitle.text = @"上传学历照片";
        return header;
    } else if (section == 6) {
        InfoAuthImageHeaderView *header = [InfoAuthImageHeaderView infoAuthImageHeaderView];
        header.lblTitle.text = @"上传获奖照片及描述";
        return header;
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 3) {
        self.addDiplomaView.userInteractionEnabled = self.isEdit;
        return [self isDiplomaImgEmpty] ? self.addDiplomaView : nil;
    } else if (section == 6) {
        self.addAwardView.userInteractionEnabled = self.isEdit;
        return self.addAwardView;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.sectionArr2.count;
    } else if (section == 2) {
        return self.sectionArr3.count;
    } else if (section == 3) {
        return [self isDiplomaImgEmpty] ? 0 : 1;
    } else if (section == 4) {
        return self.sectionArr5.count;
    } else if (section == 5) {
        return self.sectionArr6.count;
    } else if (section == 6) {
        return self.designer.award_details.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AvtarImageCell *cell = [tableView dequeueReusableCellWithIdentifier:AvtarImageCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = self.isEdit;
            [cell initWithDesigner:self.designer updateBlock:^(NSString *imageid) {
                self.avatarImageid = imageid;
            }];
            
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        cell.userInteractionEnabled = self.isEdit;
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        cell.userInteractionEnabled = self.isEdit;
        return cell;
    } else if (indexPath.section == 3) {
        InfoAuthDiplomaImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InfoAuthDiplomaImageCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithDesigner:self.designer diploma:self.designer.diploma_imageid isEdit:self.isEdit actionBlock:^(ProductAuthImageAction action) {
            [self onTapAction:action indexPath:indexPath];
        }];
        
        return cell;
    } else if (indexPath.section == 4) {
        UITableViewCell *cell = [self.sectionArr5[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        cell.userInteractionEnabled = self.isEdit;
        return cell;
    } else if (indexPath.section == 5) {
        UITableViewCell *cell = [self.sectionArr6[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        cell.userInteractionEnabled = self.isEdit;
        return cell;
    } else if (indexPath.section == 6) {
        InfoAuthAwardImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:InfoAuthAwardImageCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithDesigner:self.designer award:[self.designer awardAtIndex:indexPath.row] isEdit:self.isEdit actionBlock:^(ProductAuthImageAction action) {
            [self onTapAction:action indexPath:indexPath];
        }];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return kAvtarImageCellHeight;
        }
    } else if (indexPath.section == 1) {
        return [self.sectionArr2[indexPath.row] cellheight];
    } else if (indexPath.section == 2) {
        return [self.sectionArr3[indexPath.row] cellheight];
    } else if (indexPath.section == 3) {
        return kInfoAuthDiplomaImageCellHeight;
    } else if (indexPath.section == 4) {
        return [self.sectionArr5[indexPath.row] cellheight];
    } else if (indexPath.section == 5) {
        return [self.sectionArr6[indexPath.row] cellheight];
    } else if (indexPath.section == 6) {
        return kInfoAuthAwardImageCellHeight;
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onTapAction:(ProductAuthImageAction)action indexPath:(NSIndexPath *)indexPath {
    if (action == ProductAuthImageActionDelete) {
        if (indexPath.section == 3) {
            [self onTapDeleteDiplomaImg:indexPath];
        } else if (indexPath.section == 6) {
            [self onTapDeleteAwardImg:indexPath];
        }
    } else if (action == ProductAuthImageActionEdit) {
        if (indexPath.section == 6) {
            [self onTapReplaceAwardImg:indexPath];
        }
    }
}

- (void)onTapDeleteDiplomaImg:(NSIndexPath *)indexPath {
    self.designer.diploma_imageid = @"";
    [self.tableView reloadData];
}

- (void)onTapDeleteAwardImg:(NSIndexPath *)indexPath {
    [self.designer.award_details removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (void)onTapReplaceAwardImg:(NSIndexPath *)indexPath {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addAwardView max:1 withBlock:^(NSArray *imageIds) {
        AwardDetail *img = [self.designer awardAtIndex:indexPath.row];
        img.award_imageid = imageIds[0];
        
        [self.tableView reloadData];
    }];
}

- (void)onTapAddDiplomaImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addDiplomaView max:1 withBlock:^(NSArray *imageIds) {
        self.designer.diploma_imageid = imageIds[0];
        [self.tableView reloadData];
    }];
}

- (void)onTapAddAwardImg {
    [PhotoUtil showUploadProductImageSelector:self inView:self.addAwardView max:NSIntegerMax withBlock:^(NSArray *imageIds) {
        NSArray *arr = [imageIds map:^id(id obj) {
            AwardDetail *img = [[AwardDetail alloc] init];
            img.award_imageid = obj;
            
            return img.data;
        }];
        
        [self.designer.award_details addObjectsFromArray:arr];
        [self.tableView reloadData];
    }];
}

- (BOOL)isDiplomaImgEmpty {
    return self.designer.diploma_imageid == nil || [self.designer.diploma_imageid isEqualToString:@""];
}

- (void)onClickEdit {
    self.isEdit = YES;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)onClickDone {
    [self.view endEditing:YES];
    DesignerUpdateInfo *request = [[DesignerUpdateInfo alloc] initWithDesigner:self.designer];
    
    [HUDUtil showWait];
    [API designerUpdateInfo:request success:^{
        [HUDUtil hideWait];
        [self.navigationController popViewControllerAnimated:YES];
        [HUDUtil showSuccessText:@"提交成功"];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

#pragma mark - other
- (void)refreshNextButtonStatus {
    @weakify(self);
    [[RACObserve(self, totalArr) flattenMap:^RACStream *(NSArray *items) {
        @strongify(self)
        NSMutableArray *signals = [NSMutableArray array];
        [signals addObject:RACObserve(self, avatarImageid)];
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

        if (self.canEdit && self.isEdit) {
            self.navigationItem.rightBarButtonItem.enabled = isAllInputed;
        }
    }];
    
    [RACObserve(self, isEdit) subscribeNext:^(id x) {
        if (self.canEdit && ![x boolValue]) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

@end
