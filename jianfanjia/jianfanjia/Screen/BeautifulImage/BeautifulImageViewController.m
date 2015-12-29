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
static NSMutableArray *beautifulImageDS;
static NSMutableArray *houseTypeDS;
static NSMutableArray *decStyleDS;

@interface BeautifulImageViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet CollectionFallsFlowLayout *imgCollectionLayout;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

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

#pragma mark - init
+ (void)initialize {
    if ([self class] == [BeautifulImageViewController class]) {
        beautifulImageDS = [[NameDict getAllBeautifulImageType] mutableCopy];
        houseTypeDS = [[NameDict getAllHouseType] sortedValueWithOrder:YES];
        decStyleDS = [[NameDict getAllDecorationStyle] sortedValueWithOrder:YES];
        
        [beautifulImageDS insertObject:UnlimitedValue atIndex:0];
        [houseTypeDS insertObject:UnlimitedValue atIndex:0];
        [decStyleDS insertObject:UnlimitedValue atIndex:0];
    }
}

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.preY = 0;
    self.isTabbarhide = NO;
    self.dataManager = [[BeautifulImageDataManager alloc] init];
    [self.imgCollection registerNib:[UINib nibWithNibName:BeautifulImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:BeautifulImageCollectionCellIdentifier];
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
    [cell initWithImage:beauitifulImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BeautifulImage *beauitifulImage = self.dataManager.beautifulImages[indexPath.row];
    BeautifulImageHomePageViewController *controller = [[BeautifulImageHomePageViewController alloc] initWithBeautifulImage:beauitifulImage index:0];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)fallFlowLayout:(CollectionFallsFlowLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    BeautifulImage *beauitifulImage = self.dataManager.beautifulImages[indexPath.row];
    LeafImage *leafImage = [beauitifulImage leafImageAtIndex:0];
    
    CGFloat widthHeightFactor = [leafImage.width floatValue] / [leafImage.height floatValue];
    CGFloat cellHeight = width / widthHeightFactor;
    
    return cellHeight;
}

#pragma mark - user action
- (void)onClickButton:(UIButton *)button {
    @weakify(self);
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self highlightTypeButton:idx highlight:obj == button title:nil];
    }];
    
    [self showDropdown:button];
}

- (void)showDropdown:(UIButton *)button {
    NSInteger buttonIndex = [self.btnChooseTypes indexOfObject:button];
    if (self.beautifulImageType == buttonIndex && self.isShowDropdown) {
        [self highlightTypeButton:self.beautifulImageType highlight:NO title:nil];
        [self hideDropdownMenu];
        return;
    }
    
    self.beautifulImageType = buttonIndex;
    
    NSMutableArray *datasource = nil;
    NSString *defaultValue = nil;
    if (self.beautifulImageType == BeautifulImageTypeSpace) {
        datasource = beautifulImageDS;
        defaultValue = self.curBeautifulImageTypeSpace;
    } else if (self.beautifulImageType == BeautifulImageTypeHouse) {
        datasource = houseTypeDS;
        defaultValue = self.curBeautifulImageTypeHouse;
    } else if (self.beautifulImageType == BeautifulImageTypeStyle) {
        datasource = decStyleDS;
        defaultValue = self.curBeautifulImageTypeStyle;
    }
    
    if (!self.dropdownMenu) {
        self.dropdownMenu = [[DropdownMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
        [self.view insertSubview:self.dropdownMenu belowSubview:self.headerView];
    }
    
    @weakify(self);
    [self.dropdownMenu initWithDataSource:datasource defaultValue:defaultValue block:^(id value) {
        @strongify(self);
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
        
        if ([value isEqualToString:UnlimitedValue]) {
            [self highlightTypeButton:buttonIndex highlight:NO title:[self getDefaultTypeButtonTitle]];
        } else {
            [self highlightTypeButton:buttonIndex highlight:NO title:value];
        }
        
        //dismiss
        [self hideDropdownMenu];
    }];
    
    [self showDropdownMenu];
}

- (NSString *)getDefaultTypeButtonTitle {
    NSString *buttonTitle;
    switch (self.beautifulImageType) {
        case BeautifulImageTypeSpace:
            buttonTitle = @"空间";
            break;
        case BeautifulImageTypeHouse:
            buttonTitle = @"户型";
            break;
        case BeautifulImageTypeStyle:
            buttonTitle = @"风格";
            break;
            
        default:
            break;
    }
    
    return buttonTitle;
}

- (void)highlightTypeButton:(NSInteger)idx highlight:(BOOL)highlight title:(NSString *)title {
    UILabel *label = self.lblChooseTypes[idx];
    UIImageView *imgView = self.angleImages[idx];
    if (title) {
        [label setText:title];
    }
    
    [label setTextColor:highlight ? kThemeTextColor : kUntriggeredColor];
    [imgView setImage:[UIImage imageNamed:highlight ? @"angle_expand" : @"angle_unexpand" ]];
}

- (void)showDropdownMenu {
    if (!self.isShowDropdown) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            self.dropdownMenu.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.imgCollection.frame));
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                self.isShowDropdown = YES;
            }
        }];
    }
}

- (void)hideDropdownMenu {
    if (self.isShowDropdown) {
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            self.dropdownMenu.frame = CGRectMake(0, -CGRectGetMaxY(self.dropdownMenu.collectionView.frame), CGRectGetWidth(self.view.frame), 0);
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                self.isShowDropdown = NO;
            }
        }];
    }
}

#pragma mark - api request
- (void)refreshBeautifulImage {
    [self resetNoDataTip];
    [self.imgCollection.footer resetNoMoreData];
    
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.query = [self getQueryDic];
    request.from = @0;
    request.limit = @20;
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.header endRefreshing];
        NSInteger count = [self.dataManager refreshBeautifulImage];
        
        if (count == 0) {
            [self handleNoFavoriateBeautifulImage];
        } else if (request.limit.integerValue > count) {
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
    request.limit = @20;
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.footer endRefreshing];
        NSInteger count = [self.dataManager loadMoreBeautifulImage];
        if (request.limit.integerValue > count) {
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
        [dic setObject:[[[NameDict getAllHouseType] allKeysForObject:self.curBeautifulImageTypeHouse] lastObject] forKey:@"house_type"];
    }
    if (![self.curBeautifulImageTypeStyle isEqualToString:UnlimitedValue]) {
        [dic setObject:[[[NameDict getAllDecorationStyle] allKeysForObject:self.curBeautifulImageTypeStyle] lastObject] forKey:@"dec_style"];
    }
    
    return dic;
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoFavoriateBeautifulImage {
    self.lblNoData.text = @"没有找到任何匹配的美图";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_beautiful_image"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
