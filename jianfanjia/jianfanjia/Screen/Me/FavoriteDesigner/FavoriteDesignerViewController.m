//
//  FavoriteDesignerViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriteDesignerViewController.h"
#import "FavoriteDesignerCell.h"
#import "FavoriteDesignerData.h"

@interface FavoriteDesignerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) FavoriteDesignerData *favoriateDesignerPageData;
@property (strong, nonatomic) NSArray *rowAction;

@end

@implementation FavoriteDesignerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FavoriteDesignerCell" bundle:nil] forCellReuseIdentifier:@"FavoriteDesignerCell"];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreDesigner];
    }];
    self.favoriateDesignerPageData = [[FavoriteDesignerData alloc] init];
    
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self refreshDesigner];
    
    @weakify(self);
    self.rowAction = @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                        title:@"删除"
                                                      handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                          @strongify(self);
                                                          [self deleteFavoriateDesigner:indexPath];
    }]];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"我的意向设计师";
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favoriateDesignerPageData.designers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteDesignerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FavoriteDesignerCell"];
    [cell initWithDesigner:[self.favoriateDesignerPageData.designers objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rowAction;
}

#pragma mark - Util
- (void)refreshDesigner {
    ListFavoriteDesigner *request = [[ListFavoriteDesigner alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateDesigner:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateDesignerPageData refreshDesigner];
        if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        };
        
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

- (void)loadMoreDesigner {
    ListFavoriteDesigner *request = [[ListFavoriteDesigner alloc] init];
    request.from = @(self.favoriateDesignerPageData.designers.count);
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateDesigner:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateDesignerPageData loadMoreDesigner];
        [self.tableView.footer endRefreshing];
        if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        };
        
        [self.tableView reloadData];
    } failure:^{
        
    }];
}

- (void)deleteFavoriateDesigner:(NSIndexPath *)index {
    DeleteFavoriteDesigner *request = [[DeleteFavoriteDesigner alloc] init];
    request._id = [[self.favoriateDesignerPageData.designers objectAtIndex:index.row] _id];
    
    @weakify(self);
    [API deleteFavoriateDesigner:request success:^{
        @strongify(self);
        [self.favoriateDesignerPageData.designers removeObjectAtIndex:index.row];
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^{
        
    }];
}


@end
