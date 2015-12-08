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

typedef NS_ENUM(NSInteger, WorkSiteMode) {
    WorkSiteModePreview,
    WorkSiteModeReal,
};

typedef NS_ENUM(NSInteger, SectionOperationStatus) {
    SectionOperationStatusRefresh,
    SectionOperationStatusSwitchItemCell,
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
@property (assign, nonatomic) SectionOperationStatus currentSectionOperationStatus;
@property (assign, nonatomic) WorkSiteMode workSiteMode;
@property (strong, nonatomic) ProcessDataManager *processDataManager;

@property (strong, nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (assign, nonatomic) BOOL isHeaderHidden;
@property (assign, nonatomic) CGFloat preY;

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
    [self refreshProcess];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notification-bell"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickReminder)];
    
    self.title = @"工地管理";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sectionScrollView = [[UIScrollView alloc] init];
    self.sectionScrollView.bounces = NO;
    self.sectionScrollView.showsHorizontalScrollIndicator = NO;
    
    self.tableView = [[UITableView alloc] init];
    
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
    
    if (self.workSiteMode == WorkSiteModeReal) {
        @weakify(self);
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshProcess];
        }];
    }

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
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (self.preY > scrollView.contentOffset.y) {
            //下滑
            if (!self.tableView.header.isRefreshing) {
                [self showScrollView];
            }
        } else if (self.preY < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
            //上滑
            [self hideScrollView];
        }
        
        NSInteger maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height;
        //是否有滑动超过边界
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > maxOffset) {
            self.preY = maxOffset;
        } else {
            self.preY = scrollView.contentOffset.y;
        }

    }
}

#pragma mark - scroll view move 
- (void)hideScrollView {
    if (!self.isHeaderHidden) {
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view removeConstraints:self.scrollViewToSuperTop64Constraint];
            [self.view addConstraints:self.scrollViewBottomEqualsSuperBottomConstraint];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isHeaderHidden = YES;
        }];
    }
}

- (void)showScrollView {
    if (self.isHeaderHidden) {
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view removeConstraints:self.scrollViewBottomEqualsSuperBottomConstraint];
            [self.view addConstraints:self.scrollViewToSuperTop64Constraint];
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
    
    if (self.currentSectionOperationStatus == SectionOperationStatusRefresh || item.itemCellStatus == ItemCellStatusClosed) {
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
    
    self.currentSectionOperationStatus = SectionOperationStatusSwitchItemCell;
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
- (void)refreshLastRow {
    if (self.lastSelectedIndexPath) {
        [self refreshForIndexPath:self.lastSelectedIndexPath isExpand:YES];
    }
}

- (void)refreshProcess {
    if (self.workSiteMode == WorkSiteModePreview) {
        [self.processDataManager refreshSections:[ProcessBusiness defaultProcess]];
        [self.processDataManager switchToSelectedSection:0];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self refreshSections];
    } else {
        GetProcess *request = [[GetProcess alloc] init];
        request.processid = self.processid;
        
        [API getProcess:request success:^{
            [self.tableView.header endRefreshing];
            self.currentSectionOperationStatus = SectionOperationStatusRefresh;
            [self.processDataManager refreshProcess];
            [self.processDataManager switchToSelectedSection:self.processDataManager.selectedSectionIndex];
            self.lastSelectedIndexPath = nil;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self refreshSections];
        } failure:^{
            
        } networkError:^{
            
        }];
    }
}

- (void)refreshForIndexPath:(NSIndexPath *)indexPath isExpand:(BOOL)isExpand {
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
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self refreshSections];
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)refreshSections {
    UIView *preSection = [[UIView alloc] init];
    
    NSArray *sections = self.processDataManager.sections;
    self.sectionViewArray = [NSMutableArray arrayWithCapacity:sections.count];
    for (int i = 0; i < sections.count; i++) {
        Section *section = sections[i];
        SectionView *sectionView = [SectionView sectionView];
        [sectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSectionViewGesture:)]];
        
        [self.sectionViewArray addObject:sectionView];
        
        if (i == 0) {
            sectionView.leftLine.hidden = YES;
        } else if (i == (sections.count - 1)) {
            sectionView.rightLine.hidden = YES;
        }

        sectionView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%d_%d", i, section.status.intValue < 3 ? section.status.intValue : 1]];
        sectionView.nameLabel.text = [ProcessBusiness nameForKey:section.name];
        sectionView.durationLabel.text = [NSString stringWithFormat:@"%@-%@", [NSDate M_dot_dd:section.start_at], [NSDate M_dot_dd:section.end_at]];

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
            [self.sectionScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[section]|" options:0 metrics: 0 views:views]];
        }
    }
}

#pragma mark - getures 
- (void)handleTapSectionViewGesture:(UITapGestureRecognizer *)gesture {
    SectionView *sectionView = (SectionView *)gesture.view;
    NSInteger index = [self.sectionViewArray indexOfObject:sectionView];
    [self.processDataManager switchToSelectedSection:index];
    self.lastSelectedIndexPath = nil;
    self.currentSectionOperationStatus = SectionOperationStatusRefresh;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - user action
- (void)onClickReminder {
    [ViewControllerContainer showReminder];
}

@end
