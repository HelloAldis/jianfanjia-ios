//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessViewController.h"
#import "BannerCell.h"
#import "SectionCell.h"
#import "ItemCell.h"
#import "Business.h"

@interface ProcessViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCell" bundle:nil] forCellReuseIdentifier:@"SectionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self initNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}


- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"translucent"] forBarMetrics:UIBarMetricsDefault];
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [left setImageWithId:@"55f681f72d78361a6106bc5f" placeholderImage:[Business defaultAvatar]];
    [left addTarget:self action:@selector(onClickMe) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"配置工地" style:UIBarButtonItemStylePlain target:self action:@selector(onClickConfig)];
    self.navigationItem.rightBarButtonItem = item;
    self.title = @"简繁家";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

}


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BannerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BannerCell"];
        return cell;
    } else if (indexPath.row == 1) {
        SectionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SectionCell"];
        return cell;
    } else {
        ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return BANNER_CELL_HEIGHT;
    } else if (indexPath.row == 1) {
        return SECTION_CELL_HEIGHT;
    } else {
        return ITEM_CELL_HEIGHT;
    }
}

#pragma mark - actions
- (void)onClickMe {
    
}

- (void)onClickConfig {
    
}


@end
