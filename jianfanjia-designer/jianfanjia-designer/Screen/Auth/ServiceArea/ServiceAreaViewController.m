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
                         [EditCellItem createSelection:@"装修类型" value:[NameDict nameForSexType:self.designer.sex] placeholder:nil tapBlock:^(EditCellItem *curItem) {
                             SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] initWithValueBlock:^(id value) {
//                                 curItem.value = [NameDict nameForSexType:value];
//                                 self.designer.sex = value;
                                 
                                 [self.tableView reloadData];
                             } curValues:[NSMutableArray arrayWithObjects:@"0", @"2", nil]];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"装修类型" value:[NameDict nameForSexType:self.designer.sex] placeholder:nil tapBlock:^(EditCellItem *curItem) {
                             SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] initWithValueBlock:^(id value) {
                                 //                                 curItem.value = [NameDict nameForSexType:value];
                                 //                                 self.designer.sex = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:@"1"];
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         
                         ];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.sectionArr1[indexPath.row] cellheight];
    }
    
    return 0.0;
}

@end
