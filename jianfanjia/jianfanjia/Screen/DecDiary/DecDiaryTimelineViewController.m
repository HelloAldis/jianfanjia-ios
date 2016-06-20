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

@end

@implementation DecDiaryTimelineViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
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
        [self refresh];
    }];
    
    self.tableView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];

    [self refresh];
}

- (void)initData {
    NSString *content = @"撒地方就拉屎；大家来看；烦；监控；就看电视剧看到就看到健康；劳动节快乐；大家快来加凯迪拉克家里的；就看到了；就看了；但快乐；简单就快乐的；就看到了；都看见了；都看见了；大家快乐；大家快乐大家快乐；简单快乐；宽带连接；都看见了；djkljdkljdkldkljkldjlkdjdkljkdj 撒地方就拉屎；大家来看；烦；监控；就看电视剧看到就看到健康；劳动节快乐；大家快来加凯迪拉克家里的；就看到了；就看了；但快乐；简单就快乐的；就看到了；都看见了；都看见了；大家快乐；大家快乐大家快乐；简单快乐；宽带连接；都看见了；djkljdkljdkldkljkldjlkdjdkljkdjl撒地方就拉屎；大家来看；烦；监控；就看电视剧看到就看到健康；劳动节快乐；大家快来加凯迪拉克家里的；就看到了；就看了；但快乐；简单就快乐的；就看到了；都看见了；都看见了；大家快乐；大家快乐大家快乐；简单快乐；宽带连接；都看见了；djkljdkljdkldkljkldjlkdjdkljkdjll";
    
    NSMutableArray *diarys = [@[
                                @{
                                    @"content":content,
                                    @"images":@[
                                        @{@"imageid":@"55ed283ddfdb3ad44813bbdf",
                                          @"width":@300,
                                          @"height":@200,
                                        }
                                    ]
                                },
                                @{
                                    @"content":content,
                                    @"images":@[
                                        @{@"imageid":@"55ed283ddfdb3ad44813bbdf",
                                          @"width":@300,
                                          @"height":@500,
                                          }
                                        ]
                                },
                                @{
                                    @"content":content,
                                    @"images":@[
                                        @{@"imageid":@"55ed283ddfdb3ad44813bbdf",
                                          @"width":@300,
                                          @"height":@200,
                                          },
                                        @{@"imageid":@"55ed283ddfdb3ad44813bbdf",
                                          @"width":@300,
                                          @"height":@200,
                                          },
                                        ]
                                },
                                @{
                                    @"content":content,
                                    @"images":@[
                                        @{@"imageid":@"55ed283ddfdb3ad44813bbdf",
                                          @"width":@300,
                                          @"height":@200,
                                          },
                                        @{@"imageid":@"55ed283ddfdb3ad44813bbdf",
                                          @"width":@300,
                                          @"height":@200,
                                          },
                                        ]
                                },
                                
                                ] mutableCopy];
    
    [DataManager shared].data = @{
                                  @"diarys":diarys
                                };
    [self.dataManager refresh];
    [self.tableView reloadData];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.diarys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DecDiaryStatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithDiary:self.dataManager.diarys[indexPath.row] truncate:YES];
    return cell;
}

#pragma mark - api request
- (void)refresh {
    [self initData];
    [self.tableView.header endRefreshing];
}

- (void)loadMore {

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
        [ViewControllerContainer showDiaryAdd:self.dataManager.diarySets completion:^(BOOL completion) {
            if (completion) {
                [self refresh];
            }
        }];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
