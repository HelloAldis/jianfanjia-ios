//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetDetailViewController.h"
#import "DecDiary1StatusCell.h"
#import "DiarySetDetailDataManager.h"

static NSString *DecDiaryStatusCellIdentifier = @"DecDiary1StatusCell";

@interface DiarySetDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) DiarySetDetailDataManager *dataManager;
@property (strong, nonatomic) DiarySet *diarySet;

@end

@implementation DiarySetDetailViewController

- (instancetype)initWithDiarySet:(DiarySet *)diarySet {
    if (self = [super init]) {
        _diarySet = diarySet;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftWhiteBackInNav];
}

- (void)initUI {
    self.dataManager = [[DiarySetDetailDataManager alloc] init];
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
    DecDiary1StatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
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

@end
