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
    
    @weakify(self);
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreDesigner];
    }];
    self.favoriateDesignerPageData = [[FavoriteDesignerData alloc] init];
    
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self refreshDesigner];
    
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
    @weakify(self);
    return @[[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                          title:@"删除"
                                                        handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                            @strongify(self);
                                                            [self deleteFavoriateDesigner:indexPath];
                                                        }]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
    } networkError:^{
        
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
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
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
        
    } networkError:^{
        
    }];
}


@end
