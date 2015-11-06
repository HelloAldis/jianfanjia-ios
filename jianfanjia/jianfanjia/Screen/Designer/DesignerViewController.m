//
//  DesignerViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerViewController.h"
#import "DesignerInfoCell.h"
#import "DesignerSectionCell.h"
#import "DesignerDetailCell.h"
#import "DesignerProductCell.h"

@interface DesignerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DesignerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerInfoCell" bundle:nil] forCellReuseIdentifier:@"DesignerInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerSectionCell" bundle:nil] forCellReuseIdentifier:@"DesignerSectionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerDetailCell" bundle:nil] forCellReuseIdentifier:@"DesignerDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerProductCell" bundle:nil] forCellReuseIdentifier:@"DesignerProductCell"];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([DataManager shared].designerPageDesigner) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if ([DataManager shared].designerPageDesigner) {
            if ([DataManager shared].isShowProductList) {
                return [DataManager shared].designerPageProducts.count;
            } else {
                return 1;
            }
        } else {
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DesignerInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerInfoCell"];
        [cell initWithDesigner:[DataManager shared].designerPageDesigner];
        return cell;
    } else {
        if ([DataManager shared].isShowProductList) {
            DesignerDetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerDetailCell"];
            return cell;
        } else {
            DesignerProductCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DesignerProductCell"];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 260;
    } else {
        return kItemCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        if ([DataManager shared].isShowProductList) {
            return 284;
        } else {
            return 310;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return [self.tableView dequeueReusableCellWithIdentifier:@"DesignerSectionCell"];
    }
}


@end
