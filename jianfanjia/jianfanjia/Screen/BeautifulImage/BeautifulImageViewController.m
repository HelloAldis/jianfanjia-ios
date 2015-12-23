//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageViewController.h"
#import "BeautifulImageCollectionCell.h"
#import "ImageDetailViewController.h"
#import "ViewControllerContainer.h"
#import "MessageAlertViewController.h"
#import "BeautifulImageDataManager.h"
#import "BeautifulImageHomePageViewController.h"
#import "DropdownMenuView.h"
#import "API.h"

typedef NS_ENUM(NSInteger, BeautifulImageType) {
    BeautifulImageTypeSpace,
    BeautifulImageTypeHouse,
    BeautifulImageTypeStyle,
};

static NSString *BeautifulImageCollectionCellIdentifier = @"BeautifulImageCollectionCell";
static NSString *UnlimitedValue = @"不限";

@interface BeautifulImageViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet CollectionFallsFlowLayout *imgCollectionLayout;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;

@property (strong, nonatomic) DropdownMenuView *dropdownMenu;
@property (assign, nonatomic) BOOL isShowDropdown;
@property (assign, nonatomic) BeautifulImageType beautifulImageType;
@property (strong, nonatomic) NSString *curBeautifulImageTypeSpace;
@property (strong, nonatomic) NSString *curBeautifulImageTypeHouse;
@property (strong, nonatomic) NSString *curBeautifulImageTypeStyle;

@property (strong, nonatomic) BeautifulImageDataManager *dataManager;

@property (assign, nonatomic) CGFloat preY;
@property (assign, nonatomic) BOOL isTabbarhide;

@end

@implementation BeautifulImageViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isTabbarhide) {
        [self showTabbar];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!self.isTabbarhide && self.navigationController.viewControllers.count > 1) {
        [self hideTabbar];
    }
}

#pragma mark - UI
- (void)initNav {
    self.title = @"装修美图";
}

- (void)initUI {
    self.preY = 0;
    self.isTabbarhide = NO;
    self.dataManager = [[BeautifulImageDataManager alloc] init];
    [self.imgCollection registerNib:[UINib nibWithNibName:BeautifulImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:BeautifulImageCollectionCellIdentifier];
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    self.imgCollectionLayout.delegate = self;
    
    @weakify(self);
    self.imgCollection.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshBeautifulImage];
    }];
    
    self.imgCollection.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreBeautifulImage];
    }];
    
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.curBeautifulImageTypeSpace = UnlimitedValue;
    self.curBeautifulImageTypeHouse = UnlimitedValue;
    self.curBeautifulImageTypeStyle = UnlimitedValue;
    [self refreshBeautifulImage];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.preY > scrollView.contentOffset.y) {
        //下滑
        if (!self.imgCollection.footer.isRefreshing) {
            [self showTabbar];
        }
    } else if (self.preY < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
        //上滑
        [self hideTabbar];
        
    }
    
    NSInteger maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height;
    //是否有滑动超过边界
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y > maxOffset) {
        self.preY = maxOffset;
    } else {
        self.preY = scrollView.contentOffset.y;
    }
}

#pragma mark - Util
- (void)hideTabbar {
    if (!self.isTabbarhide) {
        self.isTabbarhide = YES;
        [UIView animateWithDuration:0.6 animations:^{
            self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, 50);
        }];
    }
}

- (void)showTabbar {
    if (self.isTabbarhide) {
        self.isTabbarhide = NO;
        [UIView animateWithDuration:0.6 animations:^{
            self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, -50);
        }];
    }
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataManager.beautifulImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BeautifulImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BeautifulImageCollectionCellIdentifier forIndexPath:indexPath];
    
    BeautifulImage *beauitifulImage = self.dataManager.beautifulImages[indexPath.row];
    LeafImage *leafImage = [beauitifulImage leafImageAtIndex:0];
    [cell initWithImage:leafImage.imageid width:cell.bounds.size.width];
    return cell;
}

- (CGFloat)fallFlowLayout:(CollectionFallsFlowLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    BeautifulImage *beauitifulImage = self.dataManager.beautifulImages[indexPath.row];
    LeafImage *leafImage = [beauitifulImage leafImageAtIndex:0];
    
    CGFloat widthHeightFactor = [leafImage.width floatValue] / [leafImage.height floatValue];
    CGFloat cellHeight = width / widthHeightFactor;
    
    return cellHeight;
}

#pragma mark - gesture
- (void)handleTapImageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.imgCollection];
    NSIndexPath *indexPath = [self.imgCollection indexPathForItemAtPoint:point];
    
    if (!indexPath) {
        return;
    }
    
    BeautifulImage *beauitifulImage = self.dataManager.beautifulImages[indexPath.row];
    [self getPrettyPictureHomepage:beauitifulImage._id index:0];
}

#pragma mark - user action
- (void)onClickButton:(UIButton *)button {
    NSInteger buttonIndex = [self.btnChooseTypes indexOfObject:button];
    self.beautifulImageType = buttonIndex;

    @weakify(self);
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.btnChooseTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            if (idx == buttonIndex) {
                [obj setTitleColor:kThemeTextColor forState:UIControlStateNormal];
                [self.angleImages[idx] setImage:[UIImage imageNamed:@"angle_expand"]];
            } else {
                [obj setTitleColor:kUntriggeredColor forState:UIControlStateNormal];
                [self.angleImages[idx] setImage:[UIImage imageNamed:@"angle_unexpand"]];
            }
        }];
    } completion:nil];
    
    [self showDropdown:button];
}

- (void)showDropdown:(UIButton *)button {
    NSMutableArray *datasource = nil;
    NSString *defaultValue = nil;
    if (self.beautifulImageType == BeautifulImageTypeSpace) {
        datasource = [[NameDict getAllBeautifulImageType] mutableCopy];
        defaultValue = self.curBeautifulImageTypeSpace;
    } else if (self.beautifulImageType == BeautifulImageTypeHouse) {
        datasource = [self getAllOrderedArray:[NameDict getAllHouseType]];
        defaultValue = self.curBeautifulImageTypeHouse;
    } else if (self.beautifulImageType == BeautifulImageTypeStyle) {
        datasource = [self getAllOrderedArray:[NameDict getAllDecorationStyle]];
        defaultValue = self.curBeautifulImageTypeStyle;
    }
    
    [datasource insertObject:UnlimitedValue atIndex:0];
    
    if (!self.dropdownMenu) {
        self.dropdownMenu = [[DropdownMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
        [self.view insertSubview:self.dropdownMenu belowSubview:self.headerView];
    }
    
    @weakify(self);
    [self.dropdownMenu initWithDataSource:datasource defaultValue:defaultValue block:^(id value) {
        @strongify(self);
        //dismiss
        if (self.isShowDropdown) {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                self.dropdownMenu.frame = CGRectMake(0, -CGRectGetHeight(self.dropdownMenu.collectionView.frame), CGRectGetWidth(self.view.frame), 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    self.isShowDropdown = NO;
                }
            }];
        }
        
        if (value) {
            if (self.beautifulImageType == BeautifulImageTypeSpace) {
                self.curBeautifulImageTypeSpace = value;
            } else if (self.beautifulImageType == BeautifulImageTypeHouse) {
                self.curBeautifulImageTypeHouse = value;
            } else if (self.beautifulImageType == BeautifulImageTypeStyle) {
                self.curBeautifulImageTypeStyle = value;
            }
            
            //update fall flow data
            [self refreshBeautifulImage];
        }
    }];
    
    if (!self.isShowDropdown) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            self.dropdownMenu.frame = CGRectMake(0, CGRectGetMinY(self.imgCollection.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.imgCollection.frame));
        } completion:^(BOOL finished) {
            if (finished) {
                self.isShowDropdown = YES;
            }
        }];
    }
}

- (NSMutableArray *)getAllOrderedArray:(NSDictionary *)dictionary {
    NSArray *orderedKeys = [dictionary.allKeys sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        if ([obj1 compare:obj2] == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if ([obj1 compare:obj2] == NSOrderedDescending) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray *array = [orderedKeys map:^id(id obj) {
        return [dictionary valueForKey:obj];
    }];
    
    return array;
}

#pragma mark - api request
- (void)refreshBeautifulImage {
    [self.imgCollection.footer resetNoMoreData];
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.query = [self getQueryDic];
    request.from = @0;
    request.limit = @10;
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.header endRefreshing];
        [self.dataManager refreshBeautifulImage];
        if (request.limit.integerValue > self.dataManager.beautifulImages.count) {
            [self.imgCollection.footer noticeNoMoreData];
        }
        
        [self.imgCollection reloadData];
    } failure:^{
        [self.imgCollection.header endRefreshing];
    } networkError:^{
        [self.imgCollection.header endRefreshing];
    }];
}

- (void)loadMoreBeautifulImage {
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.query = [self getQueryDic];
    request.from = @(self.dataManager.beautifulImages.count);
    request.limit = @10;
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.footer endRefreshing];
        NSInteger currentCount = self.dataManager.beautifulImages.count;
        [self.dataManager loadMoreBeautifulImage];
        NSInteger totalCount = self.dataManager.beautifulImages.count;
        
//        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:totalCount - currentCount];
//        for (NSInteger i = currentCount; i < totalCount; i++) {
//            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        }
//        
        NSInteger moreCount = totalCount - currentCount;
//        if (moreCount > 0) {
//            [self.imgCollection insertItemsAtIndexPaths:insertIndexPaths];
//        }
        
        if (request.limit.integerValue > moreCount) {
            [self.imgCollection.footer noticeNoMoreData];
        }
        
        [self.imgCollection reloadData];
    } failure:^{
        [self.imgCollection.footer endRefreshing];
    } networkError:^{
        [self.imgCollection.footer endRefreshing];
    }];
}

- (NSDictionary *)getQueryDic {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (![self.curBeautifulImageTypeSpace isEqualToString:UnlimitedValue]) {
        [dic setObject:self.curBeautifulImageTypeSpace forKey:@"section"];
    }
    if (![self.curBeautifulImageTypeHouse isEqualToString:UnlimitedValue]) {
        [dic setObject:self.curBeautifulImageTypeHouse forKey:@"section"];
    }
    if (![self.curBeautifulImageTypeStyle isEqualToString:UnlimitedValue]) {
        [dic setObject:self.curBeautifulImageTypeStyle forKey:@"section"];
    }
    
    return dic;
}

- (void)getPrettyPictureHomepage:(NSString *)beautifulId index:(NSInteger)index {
    [HUDUtil showWait];
    GetBeautifulImageHomepage *request = [[GetBeautifulImageHomepage alloc] init];
    request._id = beautifulId;
    
    @weakify(self);
    [API getBeautifulImageHomepage:request success:^{
        @strongify(self);
        BeautifulImage *beauitifulImage = [[BeautifulImage alloc] initWith:[DataManager shared].data];
        BeautifulImageHomePageViewController *controller = [[BeautifulImageHomePageViewController alloc] initWithBeautifulImage:beauitifulImage index:index];
        [self.navigationController pushViewController:controller animated:YES];
        [HUDUtil hideWait];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

@end
