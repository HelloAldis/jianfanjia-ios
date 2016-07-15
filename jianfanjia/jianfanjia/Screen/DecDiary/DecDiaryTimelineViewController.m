//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecDiaryTimelineViewController.h"
#import "DecDiaryStatusCell.h"
#import "TopDiarySetsCell.h"
#import "DecDiaryDataManager.h"
#import "ViewControllerContainer.h"
#import "AlbumBrowerViewController.h"

static NSString *DecDiaryStatusCellIdentifier = @"DecDiaryStatusCell";
static NSString *TopDiarySetsCellIdentifier = @"TopDiarySetsCell";

@interface DecDiaryTimelineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DecDiaryDataManager *dataManager;

@end

@implementation DecDiaryTimelineViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self setupFPS];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self refresh];
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
    [self.tableView registerNib:[UINib nibWithNibName:TopDiarySetsCellIdentifier bundle:nil] forCellReuseIdentifier:TopDiarySetsCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        if (self.dataManager.diarys.count == 0) {
            [self loadOldData];
        } else {
            [self loadLatestData];
            [self updateDiarysChange];
        }
        
        [self asyncLoadTopDiarySets];
    }];
    
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadOldData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRestartRefresh) name:kLogoutNotification object:nil];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.diarys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Diary *diary = self.dataManager.diarys[indexPath.row];
    
    if (diary.topDiarySets) {
        TopDiarySetsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TopDiarySetsCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initWithDiarySets:diary.topDiarySets];
        return cell;
    } else {
        DecDiaryStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell initWithDiary:diary diarys:self.dataManager.diarys tableView:self.tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - api request
- (void)refresh {
    if (self.dataManager.diarys.count == 0) {
        [self.tableView.footer resetNoMoreData];
        [self.tableView.header beginRefreshing];
    } else {
        [self loadLatestData];
        [self updateDiarysChange];
    }
}

- (void)loadLatestData {
    [self.tableView.footer resetNoMoreData];
    
    SearchDiary *request = [[SearchDiary alloc] init];
    request.query = [request queryConGTTime:[self.dataManager findLatestCreateTimeDiary]];
    
    [API searchDiary:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager loadLatest];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        if (count > 0) {
            [self.tableView reloadData];
        }
        
        [self syncLoadTopDiarySets];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)updateDiarysChange {
    NSMutableDictionary *dict = [self.dataManager findNeedUpdatedDiarys];
    NSArray *allKeys = dict.count > 0 ? dict.allKeys : nil;
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

- (void)loadOldData {
    SearchDiary *request = [[SearchDiary alloc] init];
    request.query = [request queryConLTTime:[self.dataManager findOldestCreateTimeDiary]];
    request.limit = @50;
    
    [API searchDiary:request success:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadOld];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
        [self syncLoadTopDiarySets];
    } failure:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}

- (void)syncLoadTopDiarySets {
    BOOL needSyncGetTopDiarySets = self.dataManager.topDiary == nil;
    if (needSyncGetTopDiarySets) {
        [self loadTopDiarySets];
    }
}

- (void)asyncLoadTopDiarySets {
    BOOL needAsyncGetTopDiarySets = self.dataManager.topDiary != nil;
    if (needAsyncGetTopDiarySets) {
        [self loadTopDiarySets];
    }
}

- (void)loadTopDiarySets {
    GetTopDiarySet *request = [[GetTopDiarySet alloc] init];
    request.limit = @10;
    
    [API getTopDiarySet:request success:^{
        [self.dataManager loadTopDiarySets];
        [self.tableView reloadData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

#pragma mark - user action
- (void)onClickAdd {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
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
    }];
}

- (void)handleRestartRefresh {
    [self.dataManager.diarys removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.header beginRefreshing];
}

@end
