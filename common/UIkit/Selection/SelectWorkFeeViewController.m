//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectWorkFeeViewController.h"
#import "InputTextTableViewCell.h"

static NSString* InputTextTableViewCellId = @"InputTextTableViewCell";

static NSArray *titleArr = nil;

@interface SelectWorkFeeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation SelectWorkFeeViewController

+ (void)initialize {
    if ([self class] == [SelectWorkFeeViewController class]) {
        titleArr = @[@"半包最少",
                     @"全包最少",
                     ];
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

    self.title = @"施工费报价";
    
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
    [self.tableView registerNib:[UINib nibWithNibName:InputTextTableViewCellId bundle:nil] forCellReuseIdentifier:InputTextTableViewCellId];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
}

- (void)initData {
    self.data = [self.curValues mutableCopy];
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
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InputTextTableViewCellId forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithTitle:titleArr[indexPath.row] value:self.data[indexPath.row] inputEndBlock:^(NSString *value) {
        self.data[indexPath.row] = value;
    }];
    
    return cell;
}

- (void)onClickOk {
    if (self.ValueBlock) {
        self.ValueBlock(self.data);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

@end
