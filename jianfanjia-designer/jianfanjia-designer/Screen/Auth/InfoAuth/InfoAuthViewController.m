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

static NSString *AvtarImageCellIdentifier = @"AvtarImageCell";

@interface InfoAuthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionArr2;
@property (nonatomic, strong) NSArray *sectionArr3;
@property (nonatomic, strong) NSArray *sectionArr4;
@property (nonatomic, strong) NSArray *sectionArr5;

@end

@implementation InfoAuthViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"基本资料认证";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:AvtarImageCellIdentifier bundle:nil] forCellReuseIdentifier:AvtarImageCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    [EditCellItem registerCells:self.tableView];
    
    self.sectionArr2 = @[
                         [EditCellItem createField:@"姓名" value:nil placeholder:@"请输入真实姓名"],
                         [EditCellItem createSelection:@"性别" value:nil placeholder:nil tapBlock:^(EditCellItem *curItem) {
                             
                         }],
                         [EditCellItem createSelection:@"所在地区" value:nil placeholder:nil tapBlock:^(EditCellItem *curItem) {
                             
                         }],
                         [EditCellItem createText:@"邮寄详细地址" value:nil placeholder:nil],
                         ];
    
    self.sectionArr3 = @[
                         [EditCellItem createField:@"毕业院校" value:nil placeholder:@"请输入"],
                         [EditCellItem createSelection:@"工作年限" value:nil placeholder:nil tapBlock:^(EditCellItem *curItem) {
                         
                         }],
                         [EditCellItem createField:@"曾就职装修公司" value:nil placeholder:@"请输入"],
                         [EditCellItem createText:@"设计成就" value:nil placeholder:nil],
                         [EditCellItem createText:@"设计理念" value:nil placeholder:nil],
                         ];
    
    self.sectionArr4 = @[
                         [EditCellItem createGroupImage:@"上传学历图片" value:nil],
                         ];
    self.sectionArr5 = @[
                         [EditCellItem createGroupImage:@"上传获奖照片及描述" value:nil],
                         ];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }
    
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = tableView.backgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.sectionArr2.count;
    } else if (section == 2) {
        return self.sectionArr3.count;
    } else if (section == 3) {
        return self.sectionArr4.count;
    } else if (section == 4) {
        return self.sectionArr5.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AvtarImageCell *cell = [tableView dequeueReusableCellWithIdentifier:AvtarImageCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell initUI];
            return cell;
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [self.sectionArr3[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [self.sectionArr4[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    } else if (indexPath.section == 4) {
        UITableViewCell *cell = [self.sectionArr5[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - user action
- (void)onClickNext {
    
}

@end
