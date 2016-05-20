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

@interface IDAuthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionArr1;
@property (nonatomic, strong) NSArray *sectionArr2;

@end

@implementation IDAuthViewController

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
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    [EditCellItem registerCells:self.tableView];
    
    self.sectionArr1 = @[
                         [EditCellItem createField:@"真实姓名" value:nil placeholder:@"请输入真实姓名"],
                         [EditCellItem createField:@"身份证号" value:nil placeholder:@"请输入15位或18位或带x身份证号码"],
                         [EditCellItem createCompareImage:@"上传身份证正面照" compareImage:[UIImage imageNamed:@"img_uid_foreground"] uploadImage:nil],
                         [EditCellItem createCompareImage:@"上传身份证背面照" compareImage:[UIImage imageNamed:@"img_uid_background"] uploadImage:nil],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createField:@"银行卡号" value:nil placeholder:@"请输入16或19位银行卡号"],
                         [EditCellItem createSelection:@"开户银行" value:nil placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                         
                         }],
                         [EditCellItem createCompareImage:@"银行卡正面照" compareImage:[UIImage imageNamed:@"img_uid_background"] uploadImage:nil],
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

#pragma mark - user action
- (void)onClickNext {
    
}

@end
