//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessViewController.h"
#import "BannerCell.h"
#import "SectionView.h"
#import "ItemCell.h"
#import "ItemExpandImageCell.h"
#import "ItemExpandCheckCell.h"
#import "API.h"
#import "ProcessDataManager.h"
#import "ViewControllerContainer.h"
#import "ItemsBackgroundView.h"

typedef NS_ENUM(NSInteger, WorkSiteMode) {
    WorkSiteModePreview,
    WorkSiteModeReal,
};

static NSString *ItemExpandCellIdentifier = @"ItemExpandImageCell";
static NSString *ItemExpandCheckCellIdentifier = @"ItemExpandCheckCell";
static NSString *ItemCellIdentifier = @"ItemCell";

@interface ProcessViewController ()

@property (strong, nonatomic) UIScrollView *sectionScrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sectionViewArray;

@property (strong, nonatomic) NSArray *scrollViewToSuperTop64Constraint;
@property (strong, nonatomic) NSArray *scrollViewBottomEqualsSuperBottomConstraint;

@property (strong, nonatomic) NSString *processid;
@property (assign, nonatomic) WorkSiteMode workSiteMode;
@property (strong, nonatomic) ProcessDataManager *processDataManager;

@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (assign, nonatomic) BOOL isHeaderHidden;
@property (assign, nonatomic) BOOL isFirstEnter;

@end

@implementation ProcessViewController

#pragma mark - init method
- (id)initWithProcess:(NSString *)processid withMode:(WorkSiteMode)mode {
    if (self = [super init]) {
        _workSiteMode = mode;
        _processid = processid;
        _processDataManager = [[ProcessDataManager alloc] init];
    }
    
    return self;
}

- (id)initWithProcess:(NSString *)processid {
    return [self initWithProcess:processid withMode:WorkSiteModeReal];
}

- (id)initWithProcessPreview {
    return [self initWithProcess:nil withMode:WorkSiteModePreview];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self refreshProcess:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    @weakify(self);
    [[NotificationDataManager shared] subscribeUnreadCountForProcess:self.processid observer:^(id value) {
        @strongify(self);
        DDLogDebug(@"subscribeUnreadCountForProcess");
        self.navigationItem.rightBarButtonItem.badgeValue = [value intValue] > 0 ? [value stringValue] : nil;
    }];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"工地管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notification-bell"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickReminder)];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sectionScrollView = [[UIScrollView alloc] init];
//    self.sectionScrollView.bounces = NO;
    self.sectionScrollView.showsHorizontalScrollIndicator = NO;
    self.sectionScrollView.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundView = [ItemsBackgroundView itemsBackgroundView];
    
    self.sectionScrollView.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    [self.tableView registerNib:[UINib nibWithNibName:ItemCellIdentifier bundle:nil] forCellReuseIdentifier:ItemCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCheckCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCheckCellIdentifier];
    
    [self configureHeaderToTableView:YES];

    [self.view addSubview:self.sectionScrollView];
    [self.view addSubview:self.tableView];
    
    self.sectionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{
                            @"scrollView":self.sectionScrollView,
                            @"tableView":self.tableView,
                            };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics: 0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics: 0 views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[scrollView(==%f)][tableView]|", SectionViewHeight]  options:0 metrics: 0 views:views]];
    
    self.scrollViewToSuperTop64Constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[scrollView]" options:0 metrics: 0 views:views];
    //52 = 116(SectionViewHeight) - 64
    self.scrollViewBottomEqualsSuperBottomConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-52)-[scrollView]" options:0 metrics: 0 views:views];
    [self.view addConstraints:self.scrollViewToSuperTop64Constraint];
    self.isFirstEnter = YES;
}

#pragma mark - scroll view delegate
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset {
    CGFloat pageSize = SectionViewWidth;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.sectionScrollView) {
        NSInteger page = roundf(scrollView.contentOffset.x / SectionViewWidth);
        [self reloadItemsForSection:page];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        static CGFloat minScroll = 30;
        if (scrollView.contentOffset.y < -minScroll) {
            //下滑
            [self showScrollView];
        } else if (scrollView.contentOffset.y > minScroll) {
            //上滑
            [self hideScrollView];
        }
    }
}

#pragma mark - scroll view move 
- (void)hideScrollView {
    if (!self.isHeaderHidden) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view removeConstraints:self.scrollViewToSuperTop64Constraint];
            [self.view addConstraints:self.scrollViewBottomEqualsSuperBottomConstraint];
            [self configureHeaderToTableView:NO];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isHeaderHidden = YES;
        }];
    }
}

- (void)showScrollView {
    if (self.isHeaderHidden) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view removeConstraints:self.scrollViewBottomEqualsSuperBottomConstraint];
            [self.view addConstraints:self.scrollViewToSuperTop64Constraint];
            [self configureHeaderToTableView:YES];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isHeaderHidden = NO;
        }];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.processDataManager.selectedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.processDataManager.selectedItems[indexPath.row];
    
    if (item.itemCellStatus == ItemCellStatusClosed) {
        ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier forIndexPath:indexPath];
        [cell initWithItem:item withDataManager:self.processDataManager];
        [self configureCellProperties:cell];
        return cell;
    } else {
        if ([item.name isEqualToString:DBYS]) {
            ItemExpandCheckCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemExpandCheckCellIdentifier forIndexPath:indexPath];
            @weakify(self);
            [cell initWithItem:item withDataManager:self.processDataManager withBlock:^{
                @strongify(self);
                [self refreshForIndexPath:indexPath isExpand:YES];
            }];
            [self configureCellProperties:cell];
            return cell;
        } else {
            ItemExpandImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemExpandCellIdentifier forIndexPath:indexPath];
            @weakify(self);
            [cell initWithItem:item withDataManager:self.processDataManager withBlock:^(BOOL isNeedReload) {
                @strongify(self);
                if (isNeedReload) {
                    [self refreshForIndexPath:indexPath isExpand:YES];
                } else {
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                }
            }];
            [self configureCellProperties:cell];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.processDataManager.selectedSection.status isEqualToString:kSectionStatusUnStart]) {
        self.lastSelectedIndexPath = indexPath;
        return;
    }
    
    if (self.lastSelectedIndexPath && self.lastSelectedIndexPath.row != indexPath.row) {
        Item *item = self.processDataManager.selectedItems[indexPath.row];
        item.itemCellStatus = ItemCellStatusExpaned;
        
        Item *lastItem = self.processDataManager.selectedItems[self.lastSelectedIndexPath.row];
        lastItem.itemCellStatus = ItemCellStatusClosed;
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.lastSelectedIndexPath, indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    } else  {
        Item *item = self.processDataManager.selectedItems[indexPath.row];
        [item switchItemCellStatus];
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
    
    self.lastSelectedIndexPath = indexPath;
}

- (void)configureCellProperties:(UITableViewCell *)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - refresh
- (void)configureHeaderToTableView:(BOOL)needConfigure {
    if (self.workSiteMode == WorkSiteModeReal && needConfigure) {
        if (!self.tableView.header) {
            @weakify(self);
            self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self);
                [self refreshProcess:NO];
            }];
        }
    } else {
        self.tableView.header = nil;
    }
}

- (void)refreshProcess:(BOOL)showPlsWait {
    if (self.workSiteMode == WorkSiteModePreview) {
        [self.processDataManager refreshSections:[ProcessBusiness defaultProcess]];
        [self refreshSectionView];
        [self reloadItemsForSection:0];
    } else {
        if (showPlsWait) {
            [HUDUtil showWait];
        }
        GetProcess *request = [[GetProcess alloc] init];
        request.processid = self.processid;
        
        [API getProcess:request success:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
            [self.processDataManager refreshProcess];
            if (self.isFirstEnter) {
                self.title = self.processDataManager.process.cell;
                [self.processDataManager switchToSelectedSection:self.processDataManager.ongoingSectionIndex];
            }
            [self refreshSectionView];
            [self reloadItemsForSection:self.processDataManager.selectedSectionIndex];
        } failure:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
        } networkError:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
        }];
    }
}

- (void)refreshForIndexPath:(NSIndexPath *)indexPath isExpand:(BOOL)isExpand {
    if (!indexPath) {
        return;
    }
    
    GetProcess *request = [[GetProcess alloc] init];
    request.processid = self.processid;
    
    [API getProcess:request success:^{
        [self.processDataManager refreshProcess];
        [self.processDataManager switchToSelectedSection:self.processDataManager.selectedSectionIndex];
        Item *item = self.processDataManager.selectedItems[indexPath.row];
        if (isExpand) {
            item.itemCellStatus = ItemCellStatusExpaned;
        } else {
            item.itemCellStatus = ItemCellStatusClosed;
        }
        
        [self refreshSectionView];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)refreshSectionView {
    NSArray *sections = self.processDataManager.sections;
    if (self.isFirstEnter) {
        self.isFirstEnter = NO;
        UIView *preSection = [[UIView alloc] init];
        
        self.sectionViewArray = [NSMutableArray arrayWithCapacity:sections.count];
        for (int i = 0; i < sections.count; i++) {
            Section *section = sections[i];
            SectionView *sectionView = [SectionView sectionView];
            [sectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSectionViewGesture:)]];
            
            [self updateSection:section for:sectionView index:i total:sections.count];
            [self.sectionViewArray addObject:sectionView];
            
            sectionView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.sectionScrollView addSubview:sectionView];
            
            NSDictionary *views = @{
                                    @"preSection":preSection,
                                    @"section":sectionView,
                                    @"scrollView":self.sectionScrollView,
                                    };
            
            if (i == 0){
                [self.sectionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[section(==%f)]", SectionViewWidth] options:0 metrics: 0 views:views]];
                preSection = sectionView;
            } else{
                [self.sectionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[preSection][section(==preSection)]" options:0 metrics: 0 views:views]];
                preSection = sectionView;
            }
            
            [self.sectionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[section(==%f)]", SectionViewHeight] options:0 metrics: 0 views:views]];
            
            if (i == sections.count - 1){
                CGFloat moreContentX = kScreenWidth - SectionViewWidth;
                [self.sectionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[section]-%f-|", moreContentX] options:0 metrics: 0 views:views]];
            }
        }
    }
    
    if (!self.isFirstEnter) {
        for (int i = 0; i < sections.count; i++) {
            Section *section = sections[i];
            [self updateSection:section for:self.sectionViewArray[i] index:i total:sections.count];
        }
    }
    self.isFirstEnter = NO;
    
    CGFloat purposeX = self.processDataManager.selectedSectionIndex * SectionViewWidth;
    if (self.sectionScrollView.contentOffset.x != purposeX) {
        [self.sectionScrollView setContentOffset:CGPointMake(purposeX, 0) animated:YES];
    }
}

- (void)updateSection:(Section *)section for:(SectionView *)sectionView index:(NSInteger)index total:(NSInteger)total {
    if (index == 0) {
        sectionView.leftLine.hidden = YES;
    } else if (index == (total - 1)) {
        sectionView.rightLine.hidden = YES;
    }
    
    sectionView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%@_%d", @(index), section.status.intValue < 3 ? section.status.intValue : 1]];
    sectionView.nameLabel.text = [ProcessBusiness nameForKey:section.name];
    sectionView.durationLabel.text = [NSString stringWithFormat:@"%@-%@", [NSDate M_dot_dd:section.start_at], [NSDate M_dot_dd:section.end_at]];
}

- (void)reloadItemsForSection:(NSInteger)sectionIndex {
    [self.processDataManager switchToSelectedSection:sectionIndex];
    [self initItemsStatus];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)initItemsStatus {
    __block NSTimeInterval latestUpdateTime;
    __block NSInteger latestUpdateItem;
    [self.processDataManager.selectedItems enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Item *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTimeInterval itemTime = item.date.doubleValue;
        if (itemTime > latestUpdateTime) {
            latestUpdateTime = itemTime;
            latestUpdateItem = idx;
        }
    }];
    
    [self.processDataManager.selectedItems enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Item *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (latestUpdateItem == idx) {
            item.itemCellStatus = ItemCellStatusExpaned;
        } else {
            item.itemCellStatus = ItemCellStatusClosed;
        }
    }];
    
    self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:latestUpdateItem inSection:0];
    
    id backgroundView = self.tableView.backgroundView;
    if ([self.processDataManager.selectedSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        [backgroundView statusLine].backgroundColor = kFinishedColor;
    } else {
        [backgroundView statusLine].backgroundColor = kUntriggeredColor;
    }
}

#pragma mark - getures
- (void)handleTapSectionViewGesture:(UITapGestureRecognizer *)gesture {
    SectionView *sectionView = (SectionView *)gesture.view;
    NSInteger index = [self.sectionViewArray indexOfObject:sectionView];
    [self.sectionScrollView setContentOffset:CGPointMake(index * SectionViewWidth, 0) animated:YES];
    [self reloadItemsForSection:index];
}

#pragma mark - user action
- (void)onClickReminder {
    @weakify(self);
    [ViewControllerContainer showReminder:self.processid refreshBlock:^{
        @strongify(self);
        [self refreshForIndexPath:self.lastSelectedIndexPath isExpand:YES];
    }];
}

@end
