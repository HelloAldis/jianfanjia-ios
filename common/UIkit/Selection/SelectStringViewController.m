//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectStringViewController.h"
#import "MultipleLineTextTableViewCell.h"
#import "SelectAllCell.h"

static NSString* SelectAllCellId = @"SelectAllCell";
static NSString* cellId = @"MultipleLineTextTableViewCell";

@interface SelectStringViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSMutableArray *selectedData;

@end

@implementation SelectStringViewController

- (id)initWithTitle:(NSString *)title options:(NSArray *)data curValue:(NSString *)curValue valueBlock:(ValueBlock)ValueBlock {
    if (self = [super initWithValueBlock:ValueBlock curValue:curValue]) {
        _titleStr = title;
        _data = data;
    }
    
    return self;
}

- (id)initWithValueBlock:(ValueBlock)ValueBlock curValues:(NSArray *)curValues {
    if (self = [super initWithValueBlock:ValueBlock curValues:curValues]) {
        
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - init Nav
- (void)initNav {
    [self initLeftBackInNav];

    self.title = self.titleStr;
    
    if (self.selectionType == SelectionTypeMultiple) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickOk)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    }
}

#pragma mark - UI
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:SelectAllCellId bundle:nil] forCellReuseIdentifier:SelectAllCellId];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
}

#pragma mark - init data 
- (void)initData {
    self.selectedData = [self.curValues mutableCopy];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectionType == SelectionTypeMultiple ? 10 : 0.1;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectionType == SelectionTypeMultiple ? 1 : 0;
    }
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SelectAllCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectAllCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        @weakify(self);
        [cell initWithValue:self.selectedData.count == self.data.count selectBlock:^(BOOL isAll) {
            @strongify(self);
            if (isAll) {
                self.selectedData = [self.data mutableCopy];
            } else {
                [self.selectedData removeAllObjects];
            }
            
            [self.tableView reloadData];
        }];
        
        return cell;
    } else if (indexPath.section == 1) {
        NSString *key = self.data[indexPath.row];
        
        MultipleLineTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        cell.lblText.text = key;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.selectedData containsObject:key]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if ([self.curValue isEqualToString:key]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    if (self.selectionType == SelectionTypeMultiple) {
        if (self.selectedData && [self.selectedData containsObject:self.data[indexPath.row]]) {
            [self.selectedData removeObject:self.data[indexPath.row]];
        } else if (self.selectedData.count < self.data.count) {
            [self.selectedData addObject:self.data[indexPath.row]];
        }
        
        [self.tableView reloadData];
    } else {
        self.curValue = self.data[indexPath.row];
        [self onClickOk];
    }
}

- (void)onClickOk {
    if (self.selectionType == SelectionTypeMultiple) {
        if (self.ValueBlock) {
            self.ValueBlock(self.selectedData);
        }
    } else {
        if (self.ValueBlock) {
            self.ValueBlock(self.curValue);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
