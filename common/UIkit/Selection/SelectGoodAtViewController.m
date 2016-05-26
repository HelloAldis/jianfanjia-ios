//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectGoodAtViewController.h"
#import "MultipleLineTextTableViewCell.h"

static NSString* cellId = @"MultipleLineTextTableViewCell";

@interface SelectGoodAtViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (assign, nonatomic) NSInteger curValueIndex;

@end

@implementation SelectGoodAtViewController

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

    self.title = @"擅长工种";
}

#pragma mark - UI
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
}

#pragma mark - init data 
- (void)initData {
    self.data = [NameDict getAllGoodAt];
    if (self.curValue) {
        self.curValueIndex = [self.data indexOfObject:self.curValue];
    } else {
        self.curValueIndex = -1;
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultipleLineTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.lblText.text = self.data[indexPath.row];
    cell.accessoryType = indexPath.row == self.curValueIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ValueBlock) {
        self.ValueBlock(self.data[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
