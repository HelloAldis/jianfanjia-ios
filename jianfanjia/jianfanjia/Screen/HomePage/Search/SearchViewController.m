//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SearchViewController.h"
#import "DesignerSimpleInfoCell.h"
#import "ProductCaseCell.h"
#import "BeautifulImageCollectionCell.h"
#import "SearchDesignerDataManager.h"
#import "SearchProductCaseDataManager.h"
#import "SearchBeautifulImageDataManager.h"
#import "BeautifulImageHomePageViewController.h"

typedef NS_ENUM(NSInteger, SearchType) {
    SearchTypeDesigner,
    SearchTypeProductCase,
    SearchTypeBeautifulImage,
};

static NSString *DesignerSimpleInfoCellIdentifier = @"DesignerSimpleInfoCell";
static NSString *ProductCaseCellIdentifier = @"ProductCaseCell";
static NSString *BeautifulImageCollectionCellIdentifier = @"BeautifulImageCollectionCell";


@interface SearchViewController () <UISearchBarDelegate, CollectionFallsFlowLayoutProtocol>

@property (strong, nonatomic) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet CollectionFallsFlowLayout *imgCollectionLayout;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lblChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;

@property (assign, nonatomic) SearchType searchType;

@property (strong, nonatomic) SearchDesignerDataManager *designerDataManager;
@property (strong, nonatomic) SearchProductCaseDataManager *productCaseDataManager;
@property (strong, nonatomic) SearchBeautifulImageDataManager *beautifulDataManager;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSString *searchText;

@end

@implementation SearchViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UI
- (void)initNav {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeTextColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.placeholder = @"设计师、案例、美图";
    searchBar.delegate = self;
    [searchBar sizeToFit];
    [searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
}

- (void)initUI {
    self.designerDataManager = [[SearchDesignerDataManager alloc] init];
    self.productCaseDataManager = [[SearchProductCaseDataManager alloc] init];
    self.beautifulDataManager = [[SearchBeautifulImageDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64+45, 0, 0, 0);
    self.imgCollection.contentInset = UIEdgeInsetsMake(64+45, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:DesignerSimpleInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DesignerSimpleInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:ProductCaseCellIdentifier bundle:nil] forCellReuseIdentifier:ProductCaseCellIdentifier];
    [self.imgCollection registerNib:[UINib nibWithNibName:BeautifulImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:BeautifulImageCollectionCellIdentifier];
    self.imgCollectionLayout.delegate = self;
    
    @weakify(self);
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    self.imgCollection.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMore];
    }];
    
    [self.btnChooseTypes enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    self.headerView.hidden = YES;
    self.searchType = SearchTypeDesigner;
    [self highlightTypeButton:self.searchType highlight:YES title:nil];
}

#pragma mark - search bar delegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.headerView.hidden = NO;
    self.searchText = searchBar.text;
    [self search];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchType == SearchTypeDesigner) {
        return self.designerDataManager.designers.count;
    } else if (self.searchType == SearchTypeProductCase) {
        return self.productCaseDataManager.products.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == SearchTypeDesigner) {
        DesignerSimpleInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DesignerSimpleInfoCellIdentifier];
        [cell initWithDesigner:self.designerDataManager.designers[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (self.searchType == SearchTypeProductCase) {
        ProductCaseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProductCaseCellIdentifier];
        [cell initWithProduct:self.productCaseDataManager.products[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == SearchTypeDesigner) {
        return kDesignerSimpleInfoCellHeight;
    } else if (self.searchType == SearchTypeProductCase) {
        return kProductCaseCellHeight;
    }
    
    return 0;
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.beautifulDataManager.beautifulImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BeautifulImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BeautifulImageCollectionCellIdentifier forIndexPath:indexPath];
    
    BeautifulImage *beauitifulImage = self.beautifulDataManager.beautifulImages[indexPath.row];
    [cell initWithImage:beauitifulImage];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BeautifulImageHomePageViewController *controller = [[BeautifulImageHomePageViewController alloc] initWithDataManager:self.beautifulDataManager index:indexPath.row loadMore:[self loadMoreBeautifulImageRequest]];
    
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
    BeautifulImage *beauitifulImage = self.beautifulDataManager.beautifulImages[indexPath.row];
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
    
    NSInteger buttonIndex = [self.btnChooseTypes indexOfObject:button];
    self.searchType = buttonIndex;
    [self search];
}

- (void)highlightTypeButton:(NSInteger)idx highlight:(BOOL)highlight title:(NSString *)title {
    UILabel *label = self.lblChooseTypes[idx];
    UIImageView *imgView = self.angleImages[idx];
    if (title) {
        [label setText:title];
    }
    
    [label setTextColor:highlight ? kThemeColor : kUntriggeredColor];
    [imgView setImage:[UIImage imageNamed:highlight ? @"angle_expand" : @"angle_unexpand" ]];
}

- (void)onClickBack {
    [self.searchBar resignFirstResponder];
    [super onClickBack];
}

#pragma mark - api request
- (void)search {
    switch (self.searchType) {
        case SearchTypeDesigner:
            self.imgCollection.hidden = YES;
            self.tableView.hidden = NO;
            [self searchDesigner];
            break;
        case SearchTypeProductCase:
            self.imgCollection.hidden = YES;
            self.tableView.hidden = NO;
            [self searchProductCase];
            break;
        case SearchTypeBeautifulImage:
            self.imgCollection.hidden = NO;
            self.tableView.hidden = YES;
            [self searchBeautifulImage];
            break;
            
        default:
            break;
    }
}

- (void)loadMore {
    switch (self.searchType) {
        case SearchTypeDesigner:
            [self loadMoreDesigner];
            break;
        case SearchTypeProductCase:
            [self loadMoreProductCase];
            break;
        case SearchTypeBeautifulImage:
            [self loadMoreBeautifulImage];
            break;
            
        default:
            break;
    }
}

#pragma mark - search Designer
- (void)searchDesigner {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
    SearchDesigner *request = [[SearchDesigner alloc] init];
    request.search_word = self.searchText;
    request.from = @0;
    request.limit = @20;
    
    [API searchDesigner:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.designerDataManager refresh];
        
        if (count == 0) {
            [self handleNoDesigner];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreDesigner {
    SearchDesigner *request = [[SearchDesigner alloc] init];
    request.search_word = self.searchText;
    request.from = @(self.designerDataManager.designers.count);
    request.limit = @20;
    
    [API searchDesigner:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.designerDataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoDesigner {
    self.lblNoData.text = @"没有找到任何匹配的设计师";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_designer"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

#pragma mark - search Product Case
- (void)searchProductCase {
    [self resetNoDataTip];
    [self.tableView.footer resetNoMoreData];
    
    SearchProduct *request = [[SearchProduct alloc] init];
    request.search_word = self.searchText;
    request.from = @0;
    request.limit = @20;
    
    [API searchProduct:request success:^{
        [self.tableView.header endRefreshing];
        NSInteger count = [self.productCaseDataManager refresh];
        
        if (count == 0) {
            [self handleNoProduct];
        } else if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.header endRefreshing];
    } networkError:^{
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreProductCase {
    SearchProduct *request = [[SearchProduct alloc] init];
    request.search_word = self.searchText;
    request.from = @(self.productCaseDataManager.products.count);
    request.limit = @20;
    
    [API searchProduct:request success:^{
        [self.tableView.footer endRefreshing];
        NSInteger count = [self.productCaseDataManager loadMore];
        if (request.limit.integerValue > count) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView reloadData];
    } failure:^{
        [self.tableView.footer endRefreshing];
    } networkError:^{
        [self.tableView.footer endRefreshing];
    }];
}

- (void)handleNoProduct {
    self.lblNoData.text = @"没有找到任何匹配的作品";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_product"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

#pragma mark - search Beautiful Image
- (void)searchBeautifulImage {
    [self resetNoDataTip];
    [self.imgCollection.footer resetNoMoreData];
    
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.search_word = self.searchText;
    request.from = @0;
    request.limit = @20;
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.header endRefreshing];
        NSInteger count = [self.beautifulDataManager refreshBeautifulImages];
        
        if (count == 0) {
            [self handleNoBeautifulImage];
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
    SearchBeautifulImage *request = [self loadMoreBeautifulImageRequest];
    
    [API searchBeautifulImage:request success:^{
        [self.imgCollection.footer endRefreshing];
        NSInteger count = [self.beautifulDataManager loadMoreBeautifulImages];
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

- (SearchBeautifulImage *)loadMoreBeautifulImageRequest {
    SearchBeautifulImage *request = [[SearchBeautifulImage alloc] init];
    request.search_word = self.searchText;
    request.from = @(self.beautifulDataManager.beautifulImages.count);
    request.limit = @20;
    
    return request;
}

- (void)handleNoBeautifulImage {
    self.lblNoData.text = @"没有找到任何匹配的美图";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_beautiful_image"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

@end
