//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectWorkTypeViewController.h"
#import "MultipleLineTextTableViewCell.h"
#import "SelectAllCell.h"

static NSString* SelectAllCellId = @"SelectAllCell";
static NSString* cellId = @"MultipleLineTextTableViewCell";

static NSDictionary *work_type;

@interface SelectWorkTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSMutableArray *selectedData;

@end

@implementation SelectWorkTypeViewController

+ (void)initialize {
    if ([self class] == [SelectWorkTypeViewController class]) {
        work_type = @{@"0":@"半包（包工包辅料，主料由您采购，用的最多的装修方式）",
                      @"1":@"全包（一条龙服务，包工包主辅材，最省心的装修）",
                      @"2":@"纯设计（我们不生产设计师，我们只是设计师的搬运工）"};
    }
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

    self.title = @"包工类型";
    
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
    self.data = [[NameDict getAllWorkType] sortedKeyWithOrder:YES];
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
        cell.lblText.text = work_type[key];
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
