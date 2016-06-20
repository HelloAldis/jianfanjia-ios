//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetDetailViewController.h"
#import "DiarySetAvtarInfoCell.h"
#import "DecDiary1StatusCell.h"
#import "DiarySetDetailDataManager.h"
#import "AddDiarySectionView.h"
#import "ViewControllerContainer.h"

static NSString *DiarySetAvtarInfoCellIdentifier = @"DiarySetAvtarInfoCell";
static NSString *DecDiaryStatusCellIdentifier = @"DecDiary1StatusCell";

@interface DiarySetDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) AddDiarySectionView *addDiarySectionView;

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
    [self initTransparentNavBar:UIBarStyleBlack];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share_1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)initUI {
    self.dataManager = [[DiarySetDetailDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:DiarySetAvtarInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DiarySetAvtarInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DecDiaryStatusCellIdentifier bundle:nil] forCellReuseIdentifier:DecDiaryStatusCellIdentifier];
    
    self.addDiarySectionView = [AddDiarySectionView addDiarySectionView];
    [self.addDiarySectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAddDiary)]];
    
    [self refresh:YES];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return kAddDiarySectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    return self.addDiarySectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.dataManager.diarys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DiarySetAvtarInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiarySetAvtarInfoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    DecDiary1StatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithDiary:self.dataManager.diarys[indexPath.row] diarys:self.dataManager.diarys tableView:self.tableView truncate:NO];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kDiarySetAvtarInfoCellHeight;
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = [UIColor blueColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((kNavWithStatusBarHeight - offsetY) / kNavWithStatusBarHeight);
        self.krs_FakeNavigationBar.backgroundColor = [color colorWithAlphaComponent:alpha];
    } else {
        self.krs_FakeNavigationBar.backgroundColor = [color colorWithAlphaComponent:0];
    }
}

#pragma mark - api request
- (void)refresh:(BOOL)showPlsWait {
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    GetDiarySetDetail *request = [[GetDiarySetDetail alloc] init];
    request.diarySetid = self.diarySet._id;
    [API getDiarySetDetail:request success:^{
        [self.dataManager refresh];
        self.diarySet.view_count = self.dataManager.diarySet.view_count;
        [self.tableView reloadData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

#pragma mark - user action
- (void)onTapAddDiary {
    [ViewControllerContainer showDiaryAdd:@[self.diarySet] completion:^(BOOL completion) {
        if (completion) {
            [self refresh:NO];
        }
    }];
}

- (void)onClickShare {
    
}

@end
