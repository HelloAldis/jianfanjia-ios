//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "BeautifulImageViewController.h"
#import "BeautifulImageCollectionCell.h"
#import "ViewControllerContainer.h"
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
@property (assign, nonatomic) BeautifulImageType beautifulImageType;
@property (strong, nonatomic) NSString *curBeautifulImageTypeSpace;
@property (strong, nonatomic) NSString *curBeautifulImageTypeHouse;
@property (strong, nonatomic) NSString *curBeautifulImageTypeStyle;

@property (strong, nonatomic) BeautifulImageDataManager *dataManager;

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
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDefaultNavBarStyle];
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([DataManager shared].isNeedRefreshTotal) {
        [DataManager shared].isNeedRefreshTotal = NO;
        [self refreshBeautifulImage:YES];
    }
}

#pragma mark - UI
- (void)initNav {
    self.tabBarController.title = @"装修美图";
    self.tabBarController.navigationItem.titleView = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.dataManager = [[BeautifulImageDataManager alloc] init];
    self.imgCollection.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight + CGRectGetHeight(self.headerView.frame), 0, kTabBarHeight, 0);
    self.imgCollection.scrollIndicatorInsets = self.imgCollection.contentInset;
    [self.imgCollection registerNib:[UINib nibWithNibName:BeautifulImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:BeautifulImageCollectionCellIdentifier];
    self.imgCollectionLayout.delegate = self;
    
    @weakify(self);
    self.imgCollection.header = [BrushGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshBeautifulImage:NO];
    }];
    
    self.imgCollection.footer = [DIYRefreshFooter footerWithRefreshingBlock:^{
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
    [self refreshBeautifulImage:NO];
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
    BeautifulImageHomePageViewController *controller = [[BeautifulImageHomePageViewController alloc] initWithDataManager:self.dataManager index:indexPath.row loadMore:[self loadMoreBeautifulImageRequest]];
    
    @weakify(self, controller);
    HomePageDismissBlock dismissBlock = ^(NSInteger index) {
        @strongify(self, controller);
        [self.imgCollection reloadData];
        [self.imgCollection layoutIfNeeded];

        UICollectionViewLayoutAttributes *layoutAttributes = self.imgCollectionLayout.allItemAttributes[index];
        [self.imgCollection scrollRectToVisible:layoutAttributes.frame animated:NO];
        CGRect rect = [self.view convertRect:layoutAttributes.frame fromView:self.imgCollection];
        [controller dismissToRect:rect];
    };
    controller.dismissBlock = dismissBlock;
    BeautifulImageCollectionCell *cell = (BeautifulImageCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [controller presentFromImageView:cell.image fromController:self];
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
    if (self.beautifulImageType == buttonIndex && self.dropdownMenu && self.dropdownMenu.isShowing) {
        [self highlightTypeButton:self.beautifulImageType highlight:NO title:nil];
        [self.dropdownMenu dismiss:YES];
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
    
    @weakify(self);
    if (self.dropdownMenu && self.dropdownMenu.isShowing) {
        [self.dropdownMenu refreshDatasource:datasource defaultValue:defaultValue];
    } else {
        self.dropdownMenu = [DropdownMenuView showIn:self.view belowTo:self.headerView.frame datasource:datasource defaultValue:defaultValue block:^(id value) {
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
                [self refreshBeautifulImage:NO];
            }
            
            if ([value isEqualToString:UnlimitedValue]) {
                [self highlightTypeButton:self.beautifulImageType highlight:NO title:[self getDefaultTypeButtonTitle]];
            } else {
                [self highlightTypeButton:self.beautifulImageType highlight:NO title:value];
            }
        }];
    }
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

#pragma mark - api request
- (void)refreshBeautifulImage:(BOOL)refreshTotal {
    [self resetNoDataTip];
    [self.imgCollection.footer resetNoMoreData];
    
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.query = [self getQueryDic];
    request.from = @0;
    request.limit = refreshTotal && self.dataManager.beautifulImages.count > 0 ? @(self.dataManager.beautifulImages.count) : @20;
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.header endRefreshing];
        NSInteger count = [self.dataManager refreshBeautifulImages];
        
        if (count == 0) {
            [self handleNoBeautifulImage];
        } else if (request.limit.integerValue > count) {
            [self.imgCollection.footer endRefreshingWithNoMoreData];
        }
        
        [self.imgCollection reloadData];
    } failure:^{
        [self.imgCollection.header endRefreshing];
    } networkError:^{
        [self.imgCollection.header endRefreshing];
    }];
}

- (void)loadMoreBeautifulImage {
    SearchBeautifulImage *request = [self loadMoreBeautifulImageRequest];
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.footer endRefreshing];
        NSInteger count = [self.dataManager loadMoreBeautifulImages];
        if (request.limit.integerValue > count) {
            [self.imgCollection.footer endRefreshingWithNoMoreData];
        }
        
        [self.imgCollection reloadData];
    } failure:^{
        [self.imgCollection.footer endRefreshing];
    } networkError:^{
        [self.imgCollection.footer endRefreshing];
    }];
}

- (SearchBeautifulImage *)loadMoreBeautifulImageRequest {
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.query = [self getQueryDic];
    request.from = @(self.dataManager.beautifulImages.count);
    request.limit = @20;
    
    return request;
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

- (void)handleNoBeautifulImage {
    self.lblNoData.text = @"没有找到任何匹配的美图";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_beautiful_image"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
