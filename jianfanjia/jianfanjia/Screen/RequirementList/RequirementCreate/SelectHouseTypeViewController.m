//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectHouseTypeViewController.h"

static NSString* cellId = @"cityCell";

@interface SelectHouseTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;

@end

@implementation SelectHouseTypeViewController

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

    self.title = @"户型";
}

#pragma mark - UI
- (void)initUI {
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    if (self.curValue) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.data indexOfObject:self.curValue] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - init data 
- (void)initData {
    self.data = [[NameDict getAllHouseType] sortedKeyWithOrder:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = [NameDict getAllHouseType][self.data[indexPath.row]];
    cell.selectionStyle = cell.isSelected ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    cell.accessoryType = cell.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ValueBlock) {
        self.ValueBlock(self.data[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
