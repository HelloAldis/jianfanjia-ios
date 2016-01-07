//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectWorkTypeViewController.h"

static NSString* cellId = @"cityCell";

static NSDictionary *work_type;

@interface SelectWorkTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;

@end

@implementation SelectWorkTypeViewController

+ (void)initialize {
    if ([self class] == [SelectWorkTypeViewController class]) {
        work_type = @{@"0":@"半包（包工包辅料，主料由您采购，用的最多的装修方式）",
                      @"1":@"全包（一条龙服务，包工包主辅材，最省心的装修）",
                      @"2":@"设计（我们不生产设计师，我们只是设计师的搬运工）"};
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
}

#pragma mark - UI
- (void)initUI {
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - init data 
- (void)initData {
    self.data = [[NameDict getAllWorkType] sortedKeyWithOrder:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSString *key = self.data[indexPath.row];
    cell.textLabel.text = work_type[key];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ValueBlock) {
        self.ValueBlock(self.data[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
