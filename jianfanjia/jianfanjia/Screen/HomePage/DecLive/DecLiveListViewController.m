//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecLiveListViewController.h"
#import "DecLiveCell.h"
#import "DecLiveListDataManager.h"
#import "ViewControllerContainer.h"

typedef NS_ENUM(NSInteger, DecLiveFilterType) {
    DecLiveFilterTypeOngoing,
    DecLiveFilterTypeFinish,
};

static NSString *DecLiveCellIdentifier = @"DecLiveCell";

@interface DecLiveListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblChooseTypes;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateMyWorksite;

@property (assign, nonatomic) DecLiveFilterType devLiveFilterType;
@property (strong, nonatomic) DecLiveListDataManager *dataManager;

@end

@implementation DecLiveListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"装修直播";
    [self initLeftBackInNav];
}

- (void)initUI {
    self.dataManager = [[DecLiveListDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.btnCreateMyWorksite setCornerRadius:self.btnCreateMyWorksite.frame.size.height / 2];
    self.tableView.contentInset = UIEdgeInsetsMake(64+45, 0, CGRectGetHeight(self.actionView.frame), 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:DecLiveCellIdentifier bundle:nil] forCellReuseIdentifier:DecLiveCellIdentifier];
    
    @weakify(self);
    self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    [self onClickButton:self.btnChooseTypes[self.devLiveFilterType]];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.devLiveFilterType == DecLiveFilterTypeOngoing) {
        return self.dataManager.ongoingDeclives.count;
    } else if (self.devLiveFilterType == DecLiveFilterTypeFinish) {
        return self.dataManager.finishDeclives.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.devLiveFilterType == DecLiveFilterTypeOngoing) {
        DecLiveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecLiveCellIdentifier];
        [cell initWithDecLive:self.dataManager.ongoingDeclives[indexPath.row]];
        return cell;
    } else if (self.devLiveFilterType == DecLiveFilterTypeFinish) {
        DecLiveCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecLiveCellIdentifier];
        [cell initWithDecLive:self.dataManager.finishDeclives[indexPath.row]];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kDecLiveCellHeight;
}

#pragma mark - user action
- (void)onClickButton:(UIButton *)button {
    @weakify(self);
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self highlightTypeButton:idx highlight:obj == button title:nil];
    }];
    
    NSInteger buttonIndex = [self.btnChooseTypes indexOfObject:button];
    self.devLiveFilterType = buttonIndex;
    
    if (self.devLiveFilterType == DecLiveFilterTypeOngoing) {
        if (self.dataManager.ongoingDeclives.count > 0) {
            [self.tableView reloadData];
        } else {
            [self refresh];
        }
    } else if (self.devLiveFilterType == DecLiveFilterTypeFinish) {
        if (self.dataManager.finishDeclives.count > 0) {
            [self.tableView reloadData];
        } else {
            [self refresh];
        }
    }
}

- (void)highlightTypeButton:(NSInteger)idx highlight:(BOOL)highlight title:(NSString *)title {
    UILabel *label = self.lblChooseTypes[idx];
    if (title) {
        [label setText:title];
    }
    
    [label setTextColor:highlight ? kThemeTextColor : kUntriggeredColor];
}

- (IBAction)onClickCreateMyWorksite:(id)sender {
    if (![GVUserDefaults standardUserDefaults].phone) {
        [ViewControllerContainer showBindPhone:BindPhoneEventPublishRequirement callback:^{
            [ViewControllerContainer showRequirementCreate:nil];
        }];
        return;
    }
    
    [ViewControllerContainer showRequirementCreate:nil];
}

#pragma mark - api request
- (void)refresh {
    if (self.devLiveFilterType == DecLiveFilterTypeOngoing) {
        [self refreshOngoing];
    } else if (self.devLiveFilterType == DecLiveFilterTypeFinish) {
        [self refreshFinish];
    }
}

- (void)loadMore {
    if (self.devLiveFilterType == DecLiveFilterTypeOngoing) {
        [self loadMoreOngoing];
    } else if (self.devLiveFilterType == DecLiveFilterTypeFinish) {
        [self loadMoreFinish];
    }
}

#pragma mark - ongoing
- (void)refreshOngoing {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
    SearchDecLive *request = [[SearchDecLive alloc] init];
    request.query = @{@"progress":@0};
    request.from = @0;
    request.limit = @20;
    
    [API searchDecLive:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refreshOngoingDeclives];
        
        if (count == 0) {
            [self handleNoOngoingDecLive];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreOngoing {
    SearchDecLive *request = [[SearchDecLive alloc] init];
    request.query = @{@"progress":@0};
    request.from = @(self.dataManager.ongoingDeclives.count);
    request.limit = @20;
    
    [API searchDecLive:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMoreOngoingDeclives];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - finish
- (void)refreshFinish {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
    SearchDecLive *request = [[SearchDecLive alloc] init];
    request.query = @{@"progress":@1};
    request.from = @0;
    request.limit = @20;
    
    [API searchDecLive:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.dataManager refreshFinishDeclives];
        
        if (count == 0) {
            [self handleNoFinishDecLive];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreFinish {
    SearchDecLive *request = [[SearchDecLive alloc] init];
    request.query = @{@"progress":@1};
    request.from = @(self.dataManager.finishDeclives.count);
    request.limit = @20;
    
    [API searchDecLive:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMoreFinishDeclives];
        if (request.limit.integerValue > count) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
    
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoOngoingDecLive {
    self.lblNoData.text = @"当前没有进行中的直播";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_product"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

- (void)handleNoFinishDecLive {
    self.lblNoData.text = @"当前没有已竣工的直播";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_product"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
