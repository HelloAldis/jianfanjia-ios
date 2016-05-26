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

@property (nonatomic, strong) NSArray *sectionArr1;
@property (nonatomic, strong) NSArray *sectionArr3;

@end

@implementation IDAuthViewController

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
    self.title = @"身份认证";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交认证" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:IDAuthIDCardImageCellIdentifier bundle:nil] forCellReuseIdentifier:IDAuthIDCardImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:IDAuthBankCardImageCellIdentifier bundle:nil] forCellReuseIdentifier:IDAuthBankCardImageCellIdentifier];
    [EditCellItem registerCells:self.tableView];
    
    self.sectionArr1 = @[
                         [EditCellItem createField:@"真实姓名" value:nil placeholder:@"请输入真实姓名" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
//                                 self.designer.university = curItem.value;
                             }
                         }],
                         [EditCellItem createField:@"身份证号" value:nil placeholder:@"请输入15位或18位或带x身份证号码" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
//                                 self.designer.university = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createField:@"银行卡号" value:nil placeholder:@"请输入16或19位银行卡号" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             if (itemEditType ==  EditCellItemEditTypeChange) {
//                                 self.designer.university = curItem.value;
                             }
                         }],
                         [EditCellItem createSelection:@"开户银行" value:nil placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             
                         }],
                         ];
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
        return cell;
    } else if (indexPath.section == 1) {
        IDAuthIDCardImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IDAuthIDCardImageCellIdentifier forIndexPath:indexPath];
        [cell initWithDesigner:self.designer actionBlock:^(CardImageAction action, CardImageType type) {
            [self.tableView reloadData];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 3) {
        IDAuthBankCardImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:IDAuthBankCardImageCellIdentifier forIndexPath:indexPath];
        [cell initWithDesigner:self.designer actionBlock:^(CardImageAction action, CardImageType type) {
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
        return kIDAuthIDCardImageCellHeight;
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onClickNext {
    
}

@end
