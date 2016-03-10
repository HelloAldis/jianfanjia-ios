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

@property (weak, nonatomic) IBOutlet InfiniteScrollView *sectionScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopToSuper;

@property (strong, nonatomic) NSString *processid;
@property (assign, nonatomic) WorkSiteMode workSiteMode;
@property (strong, nonatomic) ProcessDataManager *processDataManager;

@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (assign, nonatomic) BOOL isHeaderHidden;
@property (assign, nonatomic) BOOL isFirstEnter;
@property (assign, nonatomic) BOOL wasEnterMyNotification;

@property (strong, nonatomic) UIView *minDistanceFromLeftEdgeView;

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
    
    if (self.wasEnterMyNotification) {
        self.wasEnterMyNotification = NO;
        [self refreshProcess:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"工地管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notification-bell"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickReminder)];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sectionScrollView.showsHorizontalScrollIndicator = NO;
    self.sectionScrollView.delegate = self;
    self.sectionScrollView.infiniteDelegate = self;
//    self.sectionScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = [ItemsBackgroundView itemsBackgroundView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    [self.tableView registerNib:[UINib nibWithNibName:ItemCellIdentifier bundle:nil] forCellReuseIdentifier:ItemCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCheckCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCheckCellIdentifier];
    
    [self configureHeaderToTableView:YES];
    self.isFirstEnter = YES;
}

#pragma mark - scroll view delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.sectionScrollView) {
        CGPoint targetOffset = [self getLeftestViewToLeftEdge];
        
        targetContentOffset->x = targetOffset.x;
        targetContentOffset->y = targetOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.sectionScrollView) {
        if (!decelerate) {
            NSInteger index = [self getIndexInScrollViewForSubview:self.minDistanceFromLeftEdgeView];
            [self reloadItemsForSection:index];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.sectionScrollView) {
        NSInteger index = [self getIndexInScrollViewForSubview:self.minDistanceFromLeftEdgeView];
        [self reloadItemsForSection:index];
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

#pragma mark - scroll view operation
- (CGPoint)getLeftestViewToLeftEdge {
    CGPoint offset = self.sectionScrollView.contentOffset;
    
    __block CGFloat minDistanceFromLeftEdge = MAXFLOAT;
    __block UIView *minDistanceFromLeftEdgeView;
    
    @weakify(self);
    [self.sectionScrollView.visibleViews enumerateObjectsUsingBlock:^(id  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if (idx == self.sectionScrollView.visibleViews.count / 2)
            *stop = YES;
        
        CGFloat distanceToLeftEdge = [self.sectionScrollView getDistanceToLeftEdgeForSubview:view];
        if (distanceToLeftEdge > -SectionViewWidth / 2 && distanceToLeftEdge < minDistanceFromLeftEdge) {
            minDistanceFromLeftEdge = distanceToLeftEdge;
            minDistanceFromLeftEdgeView = view;
        }
    }];
    
    self.minDistanceFromLeftEdgeView = minDistanceFromLeftEdgeView;
    CGFloat targetX = offset.x + minDistanceFromLeftEdge;
    CGPoint targetOffset = CGPointMake(targetX, offset.y);
    
    return targetOffset;
}

- (void)hideScrollView {
    if (!self.isHeaderHidden) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.scrollViewTopToSuper.constant = -52;
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
            self.scrollViewTopToSuper.constant = 64;
            [self configureHeaderToTableView:YES];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isHeaderHidden = NO;
        }];
    }
}

#pragma mark - getures
- (void)handleTapSectionViewGesture:(UITapGestureRecognizer *)gesture {
    SectionView *sectionView = (SectionView *)gesture.view;
    NSInteger index = [self getIndexInScrollViewForSubview:sectionView];
    CGPoint currentOffset = self.sectionScrollView.contentOffset;
    CGFloat distanceFromLeftEdge = [self.sectionScrollView getDistanceToLeftEdgeForSubview:sectionView];
    
    [self.sectionScrollView setContentOffset:CGPointMake(currentOffset.x + distanceFromLeftEdge, 0) animated:YES];
    [self reloadItemsForSection:index];
}

#pragma mark - util
- (NSInteger)getIndexInScrollViewForSubview:(UIView *)subview {
    NSInteger indexInScrollView = [self.sectionScrollView.allViews indexOfObject:subview];
    NSInteger sectionsCount = self.processDataManager.sections.count;
    NSInteger index = indexInScrollView < sectionsCount ? indexInScrollView : indexInScrollView % sectionsCount;
    
    return index;
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

#pragma mark - infiniteScrollView delegate
/*
 获取需要显示的一组view的数目
 */
- (NSInteger)numberOfGroupInInfiniteScrollView:(InfiniteScrollView *)scrollView {
    return self.processDataManager.sections.count;
}

/*
 获取需要显示的view， 必须要创建一个新的view当回调发生时
 */
- (UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView viewAtIndex:(NSInteger)index {
    NSArray *sections = self.processDataManager.sections;
    Section *section = sections[index];
    SectionView *sectionView = [SectionView sectionView];
    [sectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSectionViewGesture:)]];
    
    [self updateSection:section forView:sectionView index:index total:sections.count];
    return sectionView;
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
            [self refreshSectionView];
            [self scrollToOngoingSection];
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
        [self refreshSectionView];
        BOOL goToNextSection = [self scrollToOngoingSection];
        if (goToNextSection) {
            [self reloadItemsForSection:self.processDataManager.selectedSectionIndex];
        } else {
            [self.processDataManager switchToSelectedSection:self.processDataManager.selectedSectionIndex];
            Item *item = self.processDataManager.selectedItems[indexPath.row];
            if (isExpand) {
                item.itemCellStatus = ItemCellStatusExpaned;
            } else {
                item.itemCellStatus = ItemCellStatusClosed;
            }
            
            [self refreshSectionBackground];
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)refreshSectionView {
    if (self.isFirstEnter) {
        self.isFirstEnter = NO;
        self.title = self.processDataManager.process.cell;
        [self.sectionScrollView reloadData];
    } else {
        NSArray *sections = self.processDataManager.sections;
        for (NSInteger i = 0; i < self.sectionScrollView.allViews.count; i++) {
            SectionView *view = self.sectionScrollView.allViews[i];
            NSInteger index = [self getIndexInScrollViewForSubview:view];
            Section *section = sections[index];
            [self updateSection:section forView:view index:index total:sections.count];
        }
    }
}

- (BOOL)scrollToOngoingSection {
    if (self.processDataManager.preOngoingSectionIndex == self.processDataManager.ongoingSectionIndex) {
        return NO;
    }
    
    self.processDataManager.selectedSectionIndex = self.processDataManager.ongoingSectionIndex;
    [self showScrollView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint currentOffset = self.sectionScrollView.contentOffset;
        [self.sectionScrollView setContentOffset:CGPointMake(currentOffset.x + (self.processDataManager.ongoingSectionIndex - self.processDataManager.preOngoingSectionIndex) * SectionViewWidth, 0) animated:YES];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    });
    
    return YES;
}

- (void)updateSection:(Section *)section forView:(SectionView *)sectionView index:(NSInteger)index total:(NSInteger)total {
    if (index == 0) {
        sectionView.leftLine.hidden = YES;
    } else if (index == (total - 1)) {
        sectionView.rightLine.hidden = YES;
    }
    
    Section *preSection = self.processDataManager.sections[index - 1 < 0 ? 0 : index - 1];
    Section *nextSection = self.processDataManager.sections[index + 1 > total - 1 ? total - 1 : index + 1];
    if ([preSection.status isEqualToString:kSectionStatusAlreadyFinished] && [section.status isEqualToString:kSectionStatusAlreadyFinished]) {
        sectionView.leftLine.backgroundColor = kFinishedColor;
    }
    
    if ([section.status isEqualToString:kSectionStatusAlreadyFinished] && [nextSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        sectionView.rightLine.backgroundColor = kFinishedColor;
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
    [self refreshSectionBackground];
    
    self.lastSelectedIndexPath = nil;
    if ([self.processDataManager.selectedSection.status isEqualToString:kSectionStatusUnStart]) {
        return;
    }
    
    __block NSTimeInterval latestUpdateTime = 0;
    __block NSInteger latestUpdateItem = -1;
    __block NSInteger dbysItem = -1;
    __block NSInteger subSectionsFinishedCount = 0;
    [self.processDataManager.selectedItems enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Item *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTimeInterval itemTime = item.date.doubleValue;
        if (itemTime > latestUpdateTime) {
            latestUpdateTime = itemTime;
            latestUpdateItem = idx;
        }
        
        if ([item.name isEqualToString:DBYS]) {
            dbysItem = idx;
        }
        
        if ([item.status isEqualToString:kSectionStatusAlreadyFinished]) {
            subSectionsFinishedCount++;
        }
    }];
    
    // 如果当前工序下的子工序都完工了，进入工地管理时，就要展开对比验收子工序。
    if (dbysItem >= 0 && subSectionsFinishedCount + 1 == self.processDataManager.selectedItems.count) {
        latestUpdateItem = dbysItem;
    }
    
    [self.processDataManager.selectedItems enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(Item *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        if (latestUpdateItem == idx) {
            item.itemCellStatus = ItemCellStatusExpaned;
        } else {
            item.itemCellStatus = ItemCellStatusClosed;
        }
    }];
    
    if (latestUpdateItem > -1) {
        self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:latestUpdateItem inSection:0];
    }
}

- (void)refreshSectionBackground {
    id backgroundView = self.tableView.backgroundView;
    if ([self.processDataManager.selectedSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        [backgroundView statusLine].backgroundColor = kFinishedColor;
    } else {
        [backgroundView statusLine].backgroundColor = kUntriggeredColor;
    }
}

#pragma mark - user action
- (void)onClickReminder {
    self.wasEnterMyNotification = YES;
    [ViewControllerContainer showMyNotification];
}

#pragma mark - notification 
- (void)receiveNotification:(NSNotification *)notification {
    Notification *noti = notification.object;
    if ([noti.processid isEqualToString:self.processid]) {
        [self refreshForIndexPath:self.lastSelectedIndexPath isExpand:YES];
    }
}

@end
