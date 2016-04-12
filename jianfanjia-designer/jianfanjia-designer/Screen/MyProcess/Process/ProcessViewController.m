//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ProcessViewController.h"
#import "ViewControllerContainer.h"
#import "SectionView.h"
#import "UnexpandSectionActionView.h"
#import "SectionActionView.h"
#import "ItemCell.h"
#import "ItemExpandImageCell.h"
#import "ProcessDataManager.h"
#import "TouchDelegateView.h"

typedef NS_ENUM(NSInteger, WorkSiteMode) {
    WorkSiteModePreview,
    WorkSiteModeReal,
};

static NSString *ItemExpandCellIdentifier = @"ItemExpandImageCell";
static NSString *ItemExpandCheckCellIdentifier = @"ItemExpandCheckCell";
static NSString *ItemCellIdentifier = @"ItemCell";

@interface ProcessViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *statusLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLineTopConstraint;
@property (strong, nonatomic) TouchDelegateView *sectionContainerView;
@property (strong, nonatomic) UIScrollView *sectionScrollView;
@property (strong, nonatomic) UIImageView *sectionActionMark;

@property (strong, nonatomic) UnexpandSectionActionView *unexpandSectionActionView;
@property (strong, nonatomic) SectionActionView *sectionActionView;

@property (strong, nonatomic) NSMutableArray *sectionViewArr;

@property (strong, nonatomic) NSString *processid;
@property (assign, nonatomic) WorkSiteMode workSiteMode;
@property (strong, nonatomic) ProcessDataManager *dataManager;

@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (assign, nonatomic) BOOL wasFirstEnter;
@property (assign, nonatomic) BOOL wasExpandAction;

@end

@implementation ProcessViewController

#pragma mark - init method
- (id)initWithProcess:(NSString *)processid withMode:(WorkSiteMode)mode {
    if (self = [super init]) {
        _workSiteMode = mode;
        _processid = processid;
        _dataManager = [[ProcessDataManager alloc] init];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NotificationDataManager shared] refreshUnreadCount];
    
    if (self.wasFirstEnter) {
        [self refreshForIndexPath:self.lastSelectedIndexPath isExpand:YES];
    }
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    
    UIButton *bellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [bellButton setImage:[UIImage imageNamed:@"notification-bell"] forState:UIControlStateNormal];
    [bellButton addTarget:self action:@selector(onClickMyNotification) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bellButton];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureHeaderToTableView:YES];
    [self.tableView registerNib:[UINib nibWithNibName:ItemCellIdentifier bundle:nil] forCellReuseIdentifier:ItemCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ItemExpandCheckCellIdentifier bundle:nil] forCellReuseIdentifier:ItemExpandCheckCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.header.backgroundColor = self.view.backgroundColor;
    
    //init container view
    self.sectionContainerView = [[TouchDelegateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionViewHeight)];
    self.sectionContainerView.backgroundColor = [UIColor whiteColor];
    
    //init section scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSectionViewWidth, kSectionViewHeight)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    
    self.sectionScrollView = scrollView;
    [self.sectionContainerView addSubview:scrollView];
    self.sectionContainerView.touchDelegateView = scrollView;
    
    //init container bottom line and section mark arrow
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.sectionContainerView.frame) - 1, CGRectGetWidth(self.sectionContainerView.frame), 1)];
    bottomLine.backgroundColor = kViewBgColor;
    [self.sectionContainerView addSubview:bottomLine];
    
    self.sectionActionMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section_action_mark"]];
    self.sectionActionMark.frame = CGRectMake((kSectionViewWidth - 15) / 2, kSectionViewHeight - 7, 15, 7);
    [self.sectionContainerView addSubview:self.sectionActionMark];
    
    //init unexpand section view
    self.unexpandSectionActionView = [[UnexpandSectionActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kUnexpandSectionActionViewHeight)];
    [self.unexpandSectionActionView.expandView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSectionExpand:)]];
    
    //init section action view
    self.sectionActionView = [[SectionActionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionActionViewHeight)];
    [self.sectionActionView.expandView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSectionExpand:)]];
    
    self.wasFirstEnter = NO;
    [[NotificationDataManager shared] subscribeMyNotificationUnreadCount:^(NSInteger count) {
        self.navigationItem.rightBarButtonItem.badgeNumber = count > 0 ? kBadgeStyleDot : @"";
    }];
}

#pragma mark - gesture
- (void)onTapSectionExpand:(UITapGestureRecognizer *)g {
    if (!self.wasExpandAction) {
        [self showExpandActionView];
    } else {
        [self hideExpandActionView];
    }
}

#pragma mark - section action operations
- (void)showExpandActionView {
    if (!self.wasExpandAction) {
        self.wasExpandAction = YES;
        [self playAnimation:self.wasExpandAction animated:YES];
    } else {
        [self playAnimation:self.wasExpandAction animated:NO];
    }
}

- (void)hideExpandActionView {
    if (self.wasExpandAction) {
        self.wasExpandAction = NO;
        [self playAnimation:self.wasExpandAction animated:YES];
    } else {
        [self playAnimation:self.wasExpandAction animated:NO];
    }
}

- (void)playAnimation:(BOOL)expand animated:(BOOL)animated {
    @weakify(self);
    void (^ReloadBlock)() = ^{
        @strongify(self);
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        self.statusLineTopConstraint.constant = expand ? kNavWithStatusBarHeight + kSectionViewHeight + kSectionActionViewHeight : kNavWithStatusBarHeight + kSectionViewHeight;
    };
    
    if (animated) {
        if (expand) {
            [self.unexpandSectionActionView.expandIcon playRotationZAnimation:0.3 angle:M_PI completion:ReloadBlock];
        } else {
            [self.sectionActionView.expandIcon playRotationZAnimation:0.3 angle:M_PI completion:ReloadBlock];
        }
    } else {
        ReloadBlock();
    }
}

- (void)updateSectionActionUI:(BOOL)needExpand {
    Item *item = [self hasYSInCurSection];
    
    if (item) {
        [self.sectionActionView updateData:item withMgr:self.dataManager refresh:nil];
        self.sectionActionMark.hidden = NO;
        
        if (needExpand) {
            [self showExpandActionView];
        } else {
            [self playAnimation:self.wasExpandAction animated:NO];
        }
    } else {
        self.sectionActionMark.hidden = YES;
        [self hideExpandActionView];
    }
}

- (Item *)hasYSInCurSection {
    if (self.dataManager.ysItem) {
        Item *item = self.dataManager.ysItem;
        if ([item.name isEqualToString:DBYS]) {
            return item;
        }
    }
    
    return nil;
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.sectionScrollView) {
        if (!decelerate) {
            [self switchSectionData];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.sectionScrollView) {
        [self switchSectionData];
    }
}

- (void)switchSectionData {
    NSUInteger index = self.sectionScrollView.contentOffset.x / kSectionViewWidth;
    NSUInteger curIndex = self.dataManager.selectedSectionIndex;
    if (index != curIndex) {
        [self reloadItemsForSection:index];
        [self updateSectionActionUI:YES];
    }
}

#pragma mark - getures
- (void)handleTapSectionViewGesture:(UITapGestureRecognizer *)gesture {
    SectionView *sectionView = (SectionView *)gesture.view;
    NSInteger index = [self.sectionViewArr indexOfObject:sectionView];
    [self.sectionScrollView setContentOffset:CGPointMake(index * kSectionViewWidth, 0) animated:YES];
    [self reloadItemsForSection:index];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kSectionViewHeight;
    }
    
    if ([self hasYSInCurSection]) {
        return self.wasExpandAction ? kSectionActionViewHeight : kUnexpandSectionActionViewHeight;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionContainerView;
    }
    
    if ([self hasYSInCurSection]) {
        return self.wasExpandAction ? self.sectionActionView : self.unexpandSectionActionView;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return self.dataManager.selectedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.dataManager.selectedItems[indexPath.row];
    
    if (item.itemCellStatus == ItemCellStatusClosed) {
        ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier forIndexPath:indexPath];
        [cell initWithItem:item withDataManager:self.dataManager];
        [self configureCellProperties:cell];
        return cell;
    } else {
        ItemExpandImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemExpandCellIdentifier forIndexPath:indexPath];
        @weakify(self);
        [cell initWithItem:item withDataManager:self.dataManager withBlock:^(BOOL isNeedReload) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusUnStart]) {
        self.lastSelectedIndexPath = indexPath;
        return;
    }
    
    if (self.lastSelectedIndexPath && self.lastSelectedIndexPath.row != indexPath.row) {
        Item *item = self.dataManager.selectedItems[indexPath.row];
        item.itemCellStatus = ItemCellStatusExpaned;
        
        Item *lastItem = self.dataManager.selectedItems[self.lastSelectedIndexPath.row];
        lastItem.itemCellStatus = ItemCellStatusClosed;
        
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.lastSelectedIndexPath, indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    } else  {
        Item *item = self.dataManager.selectedItems[indexPath.row];
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
            self.tableView.header = [BrushGifHeader headerWithRefreshingBlock:^{
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
        [self.dataManager refreshSections:[ProcessBusiness defaultProcess]];
        [self refreshSectionView];
        [self reloadItemsForSection:0];
        self.sectionActionView.userInteractionEnabled = NO;
    } else {
        if (showPlsWait) {
            [HUDUtil showWait];
        }
        GetProcess *request = [[GetProcess alloc] init];
        request.processid = self.processid;
        
        [API getProcess:request success:^{
            [HUDUtil hideWait];
            [self.tableView.header endRefreshing];
            [self.dataManager refreshProcess];
            [self refreshSectionView];
            [self scrollToOngoingSection];
            [self reloadItemsForSection:self.dataManager.selectedSectionIndex];
            [self updateSectionActionUI:YES];
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
    if (self.workSiteMode != WorkSiteModeReal) {
        return;
    }
    
    GetProcess *request = [[GetProcess alloc] init];
    request.processid = self.processid;
    
    [API getProcess:request success:^{
        [self.dataManager refreshProcess];
        [self refreshSectionView];
        BOOL goToNextSection = [self scrollToOngoingSection];
        if (goToNextSection) {
            [self reloadItemsForSection:self.dataManager.selectedSectionIndex];
            [self updateSectionActionUI:YES];
        } else {
            [self.dataManager switchToSelectedSection:self.dataManager.selectedSectionIndex];
            
            if (indexPath && indexPath.row < self.dataManager.selectedItems.count) {
                Item *item = self.dataManager.selectedItems[indexPath.row];
                if (isExpand) {
                    item.itemCellStatus = ItemCellStatusExpaned;
                } else {
                    item.itemCellStatus = ItemCellStatusClosed;
                }
            }
            
            [self refreshSectionBackground];
            [self updateSectionActionUI:[ProcessBusiness isAllSectionItemsFinished:self.dataManager.selectedSection]];
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

#pragma mark - refresh section
- (void)refreshSectionView {
    if (!self.wasFirstEnter) {
        self.wasFirstEnter = YES;
        self.title = self.dataManager.process.basic_address;
        [self initSectionView];
    } else {
        [self updateSectionView];
    }
}

- (BOOL)scrollToOngoingSection {
    if (self.dataManager.preOngoingSectionIndex == self.dataManager.ongoingSectionIndex) {
        return NO;
    }
    
    self.dataManager.selectedSectionIndex = self.dataManager.ongoingSectionIndex;
    [UIView animateWithDuration:0.5 animations:^{
        [self.sectionScrollView setContentOffset:CGPointMake(self.dataManager.selectedSectionIndex * kSectionViewWidth, 0) animated:NO];
    }];
    
    return YES;
}

#pragma mark - update section
- (void)initSectionView {
    NSArray *sections = self.dataManager.sections;
    self.sectionViewArr = [NSMutableArray arrayWithCapacity:sections.count];
    self.sectionScrollView.contentSize = CGSizeMake(sections.count * kSectionViewWidth, kSectionViewHeight);
    
    @weakify(self);
    [sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        Section *section = sections[idx];
        SectionView *sectionView = [SectionView sectionView];
        sectionView.frame = CGRectMake(idx * kSectionViewWidth, 0, kSectionViewWidth, kSectionViewHeight);
        [sectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSectionViewGesture:)]];
        
        [self updateSection:section forView:sectionView index:idx total:sections.count];
        [self.sectionScrollView addSubview:sectionView];
        [self.sectionViewArr addObject:sectionView];
    }];
}

- (void)updateSectionView {
    NSArray *sections = self.dataManager.sections;
    
    @weakify(self);
    [self.sectionViewArr enumerateObjectsUsingBlock:^(SectionView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self updateSection:sections[idx] forView:obj index:idx total:self.sectionViewArr.count];
    }];
}

- (void)updateSection:(Section *)section forView:(SectionView *)sectionView index:(NSInteger)index total:(NSInteger)total {
    if (index == 0) {
        sectionView.leftLine.hidden = YES;
    } else if (index == (total - 1)) {
        sectionView.rightLine.hidden = YES;
    }
    
    Section *preSection = self.dataManager.sections[index - 1 < 0 ? 0 : index - 1];
    Section *nextSection = self.dataManager.sections[index + 1 > total - 1 ? total - 1 : index + 1];
    if ([preSection.status isEqualToString:kSectionStatusAlreadyFinished] && [section.status isEqualToString:kSectionStatusAlreadyFinished]) {
        sectionView.leftLine.backgroundColor = kThemeColor;
    }
    
    if ([section.status isEqualToString:kSectionStatusAlreadyFinished] && [nextSection.status isEqualToString:kSectionStatusAlreadyFinished]) {
        sectionView.rightLine.backgroundColor = kThemeColor;
    }
    
    sectionView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%@_%d", @(index), section.status.intValue < 3 ? section.status.intValue : 1]];
    sectionView.nameLabel.text = section.label;
    sectionView.durationLabel.text = [NSString stringWithFormat:@"%@-%@", [NSDate M_dot_dd:section.start_at], [NSDate M_dot_dd:section.end_at]];
}

#pragma mark - reload items
- (void)reloadItemsForSection:(NSInteger)sectionIndex {
    [self.dataManager switchToSelectedSection:sectionIndex];
    [self initItemsStatus];
}

- (void)initItemsStatus {
    [self refreshSectionBackground];
    
    self.lastSelectedIndexPath = nil;
    if ([self.dataManager.selectedSection.status isEqualToString:kSectionStatusUnStart]) {
        return;
    }
    
    __block NSTimeInterval latestUpdateTime = 0;
    __block NSInteger latestUpdateItem = -1;
    [self.dataManager.selectedItems enumerateObjectsUsingBlock:^(Item *  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSTimeInterval itemTime = item.date.doubleValue;
        if (itemTime > latestUpdateTime) {
            [self.dataManager.selectedItems[MAX(latestUpdateItem, 0)] setItemCellStatus:ItemCellStatusClosed];
            [self.dataManager.selectedItems[idx] setItemCellStatus:ItemCellStatusExpaned];
            
            latestUpdateTime = itemTime;
            latestUpdateItem = idx;
        }
    }];
    
    if (latestUpdateItem > -1) {
        self.lastSelectedIndexPath = [NSIndexPath indexPathForRow:latestUpdateItem inSection:1];
    }
}

- (void)refreshSectionBackground {
    self.statusLine.backgroundColor = [self.dataManager.selectedSection.status isEqualToString:kSectionStatusAlreadyFinished] ? kThemeColor : kUntriggeredColor;
}

#pragma mark - user action
- (void)onClickMyNotification {
    [ViewControllerContainer showMyNotification];
}

@end
