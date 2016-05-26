//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TeamAuthViewController.h"
#import "TeamUploadCell.h"
#import "TeamAuthCell.h"
#import "TeamAuthDataManager.h"

static const NSInteger COUNT_IN_ONE_ROW = 2;
static const NSInteger CELL_SPACE = 8;
static const NSInteger SECTION_LEFT = 10;

static NSString *TeamUploadCellIdentifier = @"TeamUploadCell";
static NSString *TeamAuthCellIdentifier = @"TeamAuthCell";

@interface TeamAuthViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (strong, nonatomic) TeamAuthDataManager *dataManager;
@property (assign, nonatomic) BOOL isEditing;
@property (assign, nonatomic) CGFloat cellWidth;

@end

@implementation TeamAuthViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"我的施工团队";
    [self initLeftBackInNav];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.dataManager = [[TeamAuthDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:TeamUploadCellIdentifier bundle:nil] forCellWithReuseIdentifier:TeamUploadCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:TeamAuthCellIdentifier bundle:nil] forCellWithReuseIdentifier:TeamAuthCellIdentifier];
    
    self.collectionLayout.minimumLineSpacing = CELL_SPACE;
    self.collectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.cellWidth = (kScreenWidth - SECTION_LEFT * 2 - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    
    @weakify(self);
    self.collectionView.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    self.collectionView.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
}

#pragma mark - collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }

    return self.dataManager.teams.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TeamUploadCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TeamUploadCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    TeamAuthCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:TeamAuthCellIdentifier forIndexPath:indexPath];
    [cell initWithTeam:self.dataManager.teams[indexPath.row] edit:self.isEditing deleteBlock:^{
        [self.dataManager.teams removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, kTeamUploadCellHeight);
    }
    
    return CGSizeMake(self.cellWidth, kTeamAuthCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, SECTION_LEFT, SECTION_LEFT, SECTION_LEFT);
}

#pragma mark - api request
- (void)refresh {
    [self.collectionView.footer resetNoMoreData];
    
    DesignerGetTeams *request = [[DesignerGetTeams alloc] init];
    request.from = @0;
    request.limit = @20;
    
    [API designerGetTeams:request success:^{
        [self.collectionView.header endRefreshing];
        NSInteger count = [self.dataManager refresh];
        if (request.limit.integerValue > count) {
            [self.collectionView.footer endRefreshingWithNoMoreData];
        }
        
        [self.collectionView reloadData];
    } failure:^{
        [self.collectionView.header endRefreshing];
    } networkError:^{
        [self.collectionView.header endRefreshing];
    }];
}

- (void)loadMore {
    DesignerGetTeams *request = [[DesignerGetTeams alloc] init];
    request.from = @(self.dataManager.teams.count);
    request.limit = @20;
    
    [API designerGetTeams:request success:^{
        [self.collectionView.footer endRefreshing];
        NSInteger count = [self.dataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.collectionView.footer endRefreshingWithNoMoreData];
        }
        
        [self.collectionView reloadData];
    } failure:^{
        [self.collectionView.footer endRefreshing];
    } networkError:^{
        [self.collectionView.footer endRefreshing];
    }];
}

#pragma mark - user action
- (void)onClickEdit {
    self.isEditing = !self.isEditing;
    
    if (self.isEditing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
    [self.collectionView reloadData];
}

@end
