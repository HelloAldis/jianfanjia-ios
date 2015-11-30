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
#import "API.h"
#import "ProcessDataManager.h"

typedef NS_ENUM(NSInteger, WorkSiteMode) {
    WorkSiteModePreview,
    WorkSiteModeReal,
};

typedef NS_ENUM(NSInteger, SectionOperationStatus) {
    SectionOperationStatusRefresh,
    SectionOperationStatusSwitchItemCell,
};

static NSString *ItemExpandCellIdentifier = @"ItemExpandImageCell";
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

@property (weak, nonatomic) NSIndexPath *lastSelectedIndexPath;
@property (assign, nonatomic) CGFloat lastTouchPoint;

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

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
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
    
    if (self.workSiteMode == WorkSiteModeReal) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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

#pragma mark - scroll view move 
- (void)hideScrollView {
    [self.view removeConstraints:self.scrollViewToSuperTop64Constraint];
    [self.view addConstraints:self.scrollViewBottomEqualsSuperBottomConstraint];
}

- (void)showScrollView {
    [self.view removeConstraints:self.scrollViewBottomEqualsSuperBottomConstraint];
    [self.view addConstraints:self.scrollViewToSuperTop64Constraint];
}

#pragma mark - util
- (BOOL)isItemEquals:(Item *)item other:(Item *)other {
    return [item.name isEqualToString:other.name];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.processDataManager.selectedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = self.processDataManager.selectedItems[indexPath.row];
    
    if ((self.currentSectionOperationStatus == SectionOperationStatusRefresh || item.itemCellStatus == ItemCellStatusClosed) && ![self isItemEquals:self.processDataManager.selectedSection.latestItem other:item]) {
        item.itemCellStatus = ItemCellStatusClosed;
        ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier forIndexPath:indexPath];
        [cell initWithItem:item sectionIndex:self.processDataManager.selectedSectionIndex itemIndex:indexPath.row forProcess:self.processDataManager.process];
        [self configureCellProperties:cell];
        return cell;
    } else {
        item.itemCellStatus = ItemCellStatusExpaned;
        ItemExpandImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ItemExpandCellIdentifier forIndexPath:indexPath];
        @weakify(self);
        [cell initWithItem:item withDataManager:self.processDataManager withBlock:^{
            @strongify(self);
            self.processDataManager.selectedSection.latestItem = item;
            [self refreshProcess];
        }];
        [self configureCellProperties:cell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentSectionOperationStatus = SectionOperationStatusSwitchItemCell;
    if (self.lastSelectedIndexPath && self.lastSelectedIndexPath.row != indexPath.row) {
        Item *item = self.processDataManager.selectedItems[indexPath.row];
        [item switchItemCellStatus];
        
        Item *lastItem = self.processDataManager.selectedItems[self.lastSelectedIndexPath.row];
        if (lastItem.itemCellStatus == item.itemCellStatus) {
            [lastItem switchItemCellStatus];
        }
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
- (void)refreshProcess {
    if (self.workSiteMode == WorkSiteModePreview) {
        [self.processDataManager refreshSections:[ProcessBusiness defaultProcess]];
        [self.processDataManager switchToSelectedSection:0];
        [self.tableView reloadData];
        [self refreshSections];
    } else {
        GetProcess *request = [[GetProcess alloc] init];
        request.processid = self.processid;
        
        [API getProcess:request success:^{
            [self.tableView.header endRefreshing];
            self.currentSectionOperationStatus = SectionOperationStatusRefresh;
            [self.processDataManager refreshProcess];
            [self.processDataManager switchToSelectedSection:self.processDataManager.selectedSectionIndex];
            [self.tableView reloadData];
            [self refreshSections];
        } failure:^{
            
        }];
    }
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

        sectionView.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"section_%d_%@", i, section.status]];
        sectionView.nameLabel.text = [ProcessBusiness nameForKey:section.name];

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
    
    self.sectionScrollView.contentOffset = CGPointMake(MIN(self.processDataManager.selectedSectionIndex, 3) * SectionViewWidth, 0);
}

#pragma mark - getures 
- (void)handleTapSectionViewGesture:(UITapGestureRecognizer *)gesture {
    SectionView *sectionView = (SectionView *)gesture.view;
    NSInteger index = [self.sectionViewArray indexOfObject:sectionView];
    [self.processDataManager switchToSelectedSection:index];
    self.currentSectionOperationStatus = SectionOperationStatusRefresh;
    [self.tableView reloadData];
}

@end
