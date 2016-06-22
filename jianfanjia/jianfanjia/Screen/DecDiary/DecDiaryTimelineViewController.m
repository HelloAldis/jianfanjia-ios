//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecDiaryTimelineViewController.h"
#import "DecDiaryStatusCell.h"
#import "DecDiaryDataManager.h"
#import "ViewControllerContainer.h"

static NSString *DecDiaryStatusCellIdentifier = @"DecDiaryStatusCell";

@interface DecDiaryTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DecDiaryDataManager *dataManager;
@property (assign, nonatomic) BOOL wasFirstRefresh;

@end

@implementation DecDiaryTimelineViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.wasFirstRefresh) {
        self.wasFirstRefresh = YES;
        [self.tableView.header beginRefreshing];
    } else {
        [self refresh];
    }
}

#pragma mark - UI
- (void)initNav {
    self.title = @"装修日记";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_write_diary"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickAdd)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
}

- (void)initUI {
    self.dataManager = [[DecDiaryDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:DecDiaryStatusCellIdentifier bundle:nil] forCellReuseIdentifier:DecDiaryStatusCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.dataManager.diarys.count == 0) {
            [self loadMore];
        } else {
            [self refresh];
            [self updateDiarysChange];
        }
    }];
    
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.diarys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Diary *diary = self.dataManager.diarys[indexPath.row];
    DecDiaryStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithDiary:diary diarys:self.dataManager.diarys tableView:self.tableView];
    return cell;
}

#pragma mark - api request
- (void)refresh {
    [self.tableView reloadData];
    [self.tableView.footer resetNoMoreData];
    
    SearchDiary *request = [[SearchDiary alloc] init];
    request.query = [request queryConGTTime:[self.dataManager findLatestRefreshTimeDiary]];
    
    [API searchDiary:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refresh];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        if (count > 0) {
            [self.tableView reloadData];
        }
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)updateDiarysChange {
    NSMutableDictionary *dict = [self.dataManager findNeedUpdatedDiarys];
    NSArray *allKeys = dict.allKeys;
    if (allKeys.count == 0) {
        return;
    }
    
    GetDiaryUpdation *request = [[GetDiaryUpdation alloc] init];
    request.diaryids = allKeys;
    
    [API getDiaryUpdation:request success:^{
        [self.dataManager updateChangedDiarys:dict];
        [self.tableView reloadData];
    } failure:^{
    } networkError:^{
    }];
}

- (void)loadMore {
    SearchDiary *request = [[SearchDiary alloc] init];
    request.query = [request queryConLTTime:[self.dataManager findOldestRefreshTimeDiary]];
    request.limit = @50;
    
    [API searchDiary:request success:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - user action
- (void)onClickAdd {
    SearchDiarySet *request = [[SearchDiarySet alloc] init];
    request.from = @0;
    request.limit = @10000;
    request.sort = @{@"lastupdate":@-1};
    
    [HUDUtil showWait];
    [API getMyDiarySet:request success:^{
        [self.dataManager refreshDiarySets];
        if (self.dataManager.diarySets.count == 0) {
            [ViewControllerContainer showDiarySetUpload:nil done:nil];
        } else {
            [ViewControllerContainer showDiaryAdd:self.dataManager.diarySets];
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
