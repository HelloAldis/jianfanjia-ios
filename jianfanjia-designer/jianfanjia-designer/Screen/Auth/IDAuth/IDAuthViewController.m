//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "IDAuthViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"
#import "IDAuthIDCardImageCell.h"
#import "IDAuthBankCardImageCell.h"
#import "InfoAuthImageHeaderView.h"

static NSString *IDAuthIDCardImageCellIdentifier = @"IDAuthIDCardImageCell";
static NSString *IDAuthBankCardImageCellIdentifier = @"IDAuthBankCardImageCell";

@interface IDAuthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Designer *designer;
@property (nonatomic, strong) NSString *idCardFrontImageid;
@property (nonatomic, strong) NSString *idCardBackImageid;
@property (nonatomic, strong) NSString *bankCardFrontImageid;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr3;

@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@end

@implementation IDAuthViewController

- (instancetype)initWithDesigner:(Designer *)designer {
    if (self = [super init]) {
        _designer = [[Designer alloc] init];
        [_designer merge:designer];
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
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 30 + keyboardRect.size.height, 0);
            UIView *view = [self.tableView getFirstResponder];
            CGRect rect = [self.tableView convertRect:view.bounds fromView:view.superview];
            rect.size.height += 40;
            [self.tableView scrollRectToVisible:rect animated:YES];
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 30, 0);
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
    self.title = @"身份认证";
    
    if ([self.designer.uid_auth_type isEqualToString:kAuthTypeUnsubmitVerify]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
        self.isEdit = YES;
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
        
        if ([self.designer.uid_auth_type isEqualToString:kAuthTypeSubmitedVerifyButNotPass]) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 30, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:IDAuthIDCardImageCellIdentifier bundle:nil] forCellReuseIdentifier:IDAuthIDCardImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:IDAuthBankCardImageCellIdentifier bundle:nil] forCellReuseIdentifier:IDAuthBankCardImageCellIdentifier];
    [EditCellItem registerCells:self.tableView];
    
    self.idCardFrontImageid = self.designer.uid_image1;
    self.idCardBackImageid = self.designer.uid_image2;
    self.bankCardFrontImageid = self.designer.bank_card_image1;
    
    @weakify(self);
    self.sectionArr1 = @[
                         [EditCellItem createField:@"真实姓名" value:self.designer.realname placeholder:@"请输入真实姓名" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.realname = curItem.value;
                             }
                         }],
                         [EditCellItem createField:@"身份证号" value:self.designer.uid placeholder:@"请输入15位或18位或带x身份证号码" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.uid = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createField:@"银行卡号" value:self.designer.bank_card placeholder:@"请输入16或19位银行卡号" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.designer.bank_card = curItem.value;
                             }
                         }],
                         [EditCellItem createSelection:@"开户银行" value:self.designer.bank placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             SelectBankTypeViewController *controller = [[SelectBankTypeViewController alloc] initWithValueBlock:^(id value) {
                                 self.designer.bank = value;
                                 [self.tableView reloadData];
                             } curValue:self.designer.bank];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         ];
    self.totalArr = [NSMutableArray array];
    [self.totalArr addObjectsFromArray:self.sectionArr1];
    [self.totalArr addObjectsFromArray:self.sectionArr3];
    [self refreshNextButtonStatus];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 3) {
        return kInfoAuthImageHeaderViewHeight;
    }
    
    if (section == 0 || section == 2) {
        return 10;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        InfoAuthImageHeaderView *header = [InfoAuthImageHeaderView infoAuthImageHeaderView];
        header.lblTitle.text = @"上传身份证";
        return header;
    } else if (section == 3) {
        InfoAuthImageHeaderView *header = [InfoAuthImageHeaderView infoAuthImageHeaderView];
        header.lblTitle.text = @"银行卡正面照片";
        return header;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionArr1.count;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return self.sectionArr3.count;
    } else if (section == 3) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        cell.userInteractionEnabled = self.isEdit;
        return cell;
    } else if (indexPath.section == 1) {
        IDAuthIDCardImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IDAuthIDCardImageCellIdentifier forIndexPath:indexPath];
        [cell initWithDesigner:self.designer isEdit:self.isEdit actionBlock:^(CardImageAction action, CardImageType type) {
            if (type == CardImageTypeFront) {
                self.idCardFrontImageid = self.designer.uid_image1;
            } else {
                self.idCardBackImageid = self.designer.uid_image2;
            }
            
            [self.tableView reloadData];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        cell.userInteractionEnabled = self.isEdit;
        return cell;
    } else if (indexPath.section == 3) {
        IDAuthBankCardImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IDAuthBankCardImageCellIdentifier forIndexPath:indexPath];
        [cell initWithDesigner:self.designer isEdit:self.isEdit actionBlock:^(CardImageAction action, CardImageType type) {
            self.bankCardFrontImageid = self.designer.bank_card_image1;
            [self.tableView reloadData];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.sectionArr1[indexPath.row] cellheight];
    } else if (indexPath.section == 1) {
        return kIDAuthIDCardImageCellHeight;
    } else if (indexPath.section == 2) {
        return [self.sectionArr3[indexPath.row] cellheight];
    } else if (indexPath.section == 3) {
        return kIDAuthBankCardImageCellHeight;
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onClickEdit {
    self.isEdit = YES;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)onClickDone {
    [self.view endEditing:YES];
    DesignerUpdateUIDBankInfo *request = [[DesignerUpdateUIDBankInfo alloc] initWithDesigner:self.designer];
    
    [HUDUtil showWait];
    [API designerUpdateUIDBankInfo:request success:^{
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
        [signals addObject:RACObserve(self, idCardFrontImageid)];
        [signals addObject:RACObserve(self, idCardBackImageid)];
        [signals addObject:RACObserve(self, bankCardFrontImageid)];
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
        
        if (self.isEdit) {
            self.navigationItem.rightBarButtonItem.enabled = isAllInputed;
        }
    }];
    
    [RACObserve(self, isEdit) subscribeNext:^(id x) {
        if (![x boolValue]) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

@end
