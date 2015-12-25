//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectBusinessTypeViewController.h"

static NSString* cellId = @"businessCell";

@interface SelectBusinessTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;

@end

@implementation SelectBusinessTypeViewController

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
}

#pragma mark - init data 
- (void)initData {
    self.data = [[NameDict getAllBusinessType].allKeys sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        if ([obj1 compare:obj2] == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if ([obj1 compare:obj2] == NSOrderedDescending) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = [NameDict getAllBusinessType][self.data[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ValueBlock) {
        self.ValueBlock(self.data[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
