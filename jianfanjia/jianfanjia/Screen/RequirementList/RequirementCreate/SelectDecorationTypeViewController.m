//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectDecorationTypeViewController.h"

static NSString* cellId = @"cityCell";

@interface SelectDecorationTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;

@end

@implementation SelectDecorationTypeViewController

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

    self.title = @"装修类型";
}

#pragma mark - UI
- (void)initUI {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - init data 
- (void)initData {
    self.data = [[NameDict getAllDecorationType].allKeys sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
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
    cell.textLabel.text = [NameDict getAllDecorationType][self.data[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DataManager shared].requirementPageSelectedDecorationType = self.data[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
