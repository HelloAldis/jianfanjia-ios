//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerAuthViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"

@interface DesignerAuthViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *sectionArr;

@end

@implementation DesignerAuthViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"设计师认证";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 10, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    [EditCellItem registerCells:self.tableView];
    
    self.sectionArr = @[
                        [EditCellItem createAttrSelection:[[NSAttributedString alloc] initWithString:@"基本资料认证"] attrValue:[@"已通过认证" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeColor] placeholder:nil image:nil tapBlock:^(EditCellItem *curItem) {
                            [ViewControllerContainer showInfoAuth];
                        }],
                        [EditCellItem createAttrSelection:[[NSAttributedString alloc] initWithString:@"身份认证"] attrValue:[@"正在认证中" attrStrWithFont:[UIFont systemFontOfSize:14] color:kExcutionStatusColor] placeholder:nil image:nil tapBlock:^(EditCellItem *curItem) {
                            
                        }],
                        [EditCellItem createSelection:@"作品认证" value:nil placeholder:nil image:nil tapBlock:^(EditCellItem *curItem) {
                            [ViewControllerContainer showProductAuth];
                        }],
                        [EditCellItem createSelection:@"施工团队认证" value:nil placeholder:nil image:nil tapBlock:^(EditCellItem *curItem) {
                            [ViewControllerContainer showTeamAuth];
                        }],
                        [EditCellItem createSelection:@"邮箱认证" value:nil placeholder:nil image:nil tapBlock:^(EditCellItem *curItem) {
                            
                        }],
                        ];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 6;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = tableView.backgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.sectionArr[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
    return cell;
}

@end
