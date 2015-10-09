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
#import "API.h"
#import "ProcessCD.h"

@interface ProcessViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Process *process;
@property (assign, nonatomic) NSInteger sectionIndex;

@end

@implementation ProcessViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionCell" bundle:nil] forCellReuseIdentifier:@"SectionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"ItemCell"];
    [self initNav];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refresh];
    }];
    
    self.sectionIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.process = [ProcessBusiness defaultProcess];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    ProcessCD *processCD = [ProcessCD findFirstByAttribute:@"processid" withValue:[GVUserDefaults standardUserDefaults].processid];
//    DDLogDebug(@"%@", [Business defaultProcess]);
}

#pragma mark - UI
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"translucent"] forBarMetrics:UIBarMetricsDefault];
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [left setImageWithId:@"55f681f72d78361a6106bc5f" placeholderImage:[AccountBusiness defaultAvatar]];
    [left addTarget:self action:@selector(onClickMe) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"配置工地" style:UIBarButtonItemStylePlain target:self action:@selector(onClickConfig)];
    self.navigationItem.rightBarButtonItem = item;
    self.title = @"简繁家";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}



#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if ([ProcessBusiness hasYs:self.sectionIndex]) {
            return [self.process sectionAtIndex:self.sectionIndex].items.count + 1;
        } else {
            return [self.process sectionAtIndex:self.sectionIndex].items.count;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BannerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BannerCell"];
        return cell;
    } else {
        if ([ProcessBusiness hasYs:self.sectionIndex]) {
            return nil;
        } else {
            
        }
        ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return BANNER_CELL_HEIGHT;
    } else {
        return ITEM_CELL_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return SECTION_CELL_HEIGHT;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return [self.tableView dequeueReusableCellWithIdentifier:@"SectionCell"];
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= (BANNER_CELL_HEIGHT - 64)) {
        if (self.navigationController.navigationBar.translucent) {
            self.navigationController.navigationBar.translucent = NO;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.navigationController.navigationBar.barTintColor = THEME_COLOR;
        }
    } else {
        if (!self.navigationController.navigationBar.translucent) {
            self.navigationController.navigationBar.translucent = YES;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
        }
    }
    
    if (scrollView.contentOffset.y < 0) {
        if (!self.navigationController.navigationBarHidden) {
            self.navigationController.navigationBarHidden = YES;
        }
    } else {
        if (self.navigationController.navigationBarHidden) {
            self.navigationController.navigationBarHidden = NO;
        }
    }
}

#pragma mark - actions
- (void)onClickMe {
    
}

- (void)onClickConfig {
    
}

- (void)refresh {
    GetProcess *request = [[GetProcess alloc] init];
    request.processid = [GVUserDefaults standardUserDefaults].processid;
    
//    [API getProcess:request success:^{
//        [self.tableView.header endRefreshing];
//        NSArray *arry = [ProcessCDDao find];
//        for (ProcessCD *processCD in arry) {
//            DDLogDebug(@"%@ what 1", processCD.process);
//            DDLogDebug(@"%@ what 1", processCD.userid);
//        }
//        
//    } failure:^{
//        
//    }];
    
    ProcessCD *processCD = [ProcessCD findFirstByAttribute:@"processid" withValue:[GVUserDefaults standardUserDefaults].processid];
    DDLogDebug(@"%@", processCD.process);
    
//    [API getUserRequirement:[[GetUserRequirement alloc] init] success:^{
//        NSArray *arry = [ProcessCDDao find];
//        for (ProcessCD *processCD in arry) {
//            DDLogDebug(@"%@ what 4", processCD.process);
//        }
//    } failure:^{
//        NSArray *arry = [ProcessCDDao find];
//        for (ProcessCD *processCD in arry) {
//            DDLogDebug(@"%@ what 5", processCD.process);
//        }
//    }];
}


@end
