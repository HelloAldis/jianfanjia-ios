//
//  MyFavoriateViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MyFavoriateViewController.h"
#import "FavoriteDesignerData.h"
#import "FavoriteDesignerCell.h"
#import "FavoriateProductData.h"
#import "FavoriateProductCell.h"
#import "FavoriateBeautifulImageData.h"
#import "FavoriateBeautifulImageCell.h"
#import "BeautifulImageHomePageViewController.h"


typedef NS_ENUM(NSInteger, FavoriateType) {
    FavoriateTypeDesigner,
    FavoriateTypeProduct,
    FavoriateTypeBeautifulImage,
};

@interface MyFavoriateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *designerTableView;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *beautifulImageCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnDesigner;
@property (weak, nonatomic) IBOutlet UIButton *btnProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnBeautifulImage;
@property (weak, nonatomic) IBOutlet CollectionFallsFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *lblNoData;
@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;

@property (strong, nonatomic) FavoriteDesignerData *favoriateDesignerPageData;
@property (strong, nonatomic) FavoriateProductData *favoriateProductPageData;
@property (strong, nonatomic) FavoriateBeautifulImageData *favoriateBeautifulImageData;
@property (assign, nonatomic) FavoriateType favoriateType;
@property (copy, nonatomic) DeleteFavoriateProductBlock deleteFavoriateProductBlock;
@property (copy, nonatomic) DeleteFavoriateBeautifulImageBlock deleteFavoriateBeautifulImageBlock;
@end

@implementation MyFavoriateViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.designerTableView registerNib:[UINib nibWithNibName:@"FavoriteDesignerCell" bundle:nil] forCellReuseIdentifier:@"FavoriteDesignerCell"];
    [self.productTableView registerNib:[UINib nibWithNibName:@"FavoriateProductCell" bundle:nil] forCellReuseIdentifier:@"FavoriateProductCell"];
    [self.beautifulImageCollectionView registerNib:[UINib nibWithNibName:@"FavoriateBeautifulImageCell"bundle:nil] forCellWithReuseIdentifier:@"FavoriateBeautifulImageCell"];
    self.designerTableView.contentInset = UIEdgeInsetsMake(9, 0, 0, 0);
    
    @weakify(self);
    [RACObserve(self.designerTableView, hidden) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            [self.btnDesigner setTitleColor:[UIColor colorWithR:170 g:177 b:182] forState:UIControlStateNormal];
        } else {
            [self.btnDesigner setTitleColor:[UIColor colorWithR:52 g:74 b:93] forState:UIControlStateNormal];
        }
    }];
    
    [RACObserve(self.productTableView, hidden) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            [self.btnProduct setTitleColor:[UIColor colorWithR:170 g:177 b:182] forState:UIControlStateNormal];
        } else {
            [self.btnProduct setTitleColor:[UIColor colorWithR:52 g:74 b:93] forState:UIControlStateNormal];
        }
    }];
    
    [RACObserve(self.beautifulImageCollectionView, hidden) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            [self.btnBeautifulImage setTitleColor:[UIColor colorWithR:170 g:177 b:182] forState:UIControlStateNormal];
        } else {
            [self.btnBeautifulImage setTitleColor:[UIColor colorWithR:52 g:74 b:93] forState:UIControlStateNormal];
        }
    }];
    
    self.deleteFavoriateProductBlock = ^(FavoriateProductCell *cell) {
        @strongify(self);
        [self handleAfterDeleteFavoriateProduct:cell];
    };
    self.deleteFavoriateBeautifulImageBlock = ^(FavoriateBeautifulImageCell *cell) {
        @strongify(self);
        [self handleAfterDeleteFavoriateBeautifulImage:cell];
    };
    
    
    self.designerTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         @strongify(self);
        [self refreshDesigner];
    }];
    self.designerTableView.header.ignoredScrollViewContentInsetTop = 9;
    self.designerTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreDesigner];
    }];
    self.productTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshFavoriateProduct];
    }];
    self.productTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreFavoriateProduct];
    }];
    self.beautifulImageCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshFavoriateBeautifulImage];
    }];
    self.beautifulImageCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreFavoriateBeautifulImage];
    }];
    
    self.designerTableView.hidden = NO;
    self.productTableView.hidden = YES;
    self.beautifulImageCollectionView.hidden = YES;
    self.flowLayout.delegate = self;
    
    self.favoriateType = FavoriateTypeDesigner;
    self.favoriateDesignerPageData = [[FavoriteDesignerData alloc] init];
    self.favoriateProductPageData = [[FavoriateProductData alloc] init];
    self.favoriateBeautifulImageData = [[FavoriateBeautifulImageData alloc] init];
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initUIData];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    [self initLeftBackInNav];
    self.title = @"我的收藏";
}

- (void)initUIData {
    switch (self.favoriateType) {
        case FavoriateTypeDesigner:
            [self refreshDesigner];
            break;
        case FavoriateTypeProduct:
            [self refreshFavoriateProduct];
            break;
        case FavoriateTypeBeautifulImage:
            [self refreshFavoriateBeautifulImage];
            break;
        default:
            break;
    }
}

#pragma mark - user action
- (IBAction)onClickDesigner:(id)sender {
    if (self.favoriateType != FavoriateTypeDesigner) {
        self.favoriateType = FavoriateTypeDesigner;
        self.designerTableView.hidden = NO;
        self.productTableView.hidden = YES;
        self.beautifulImageCollectionView.hidden = YES;
        
        //刷新数据
        if ([self.favoriateDesignerPageData.designers count] == 0) {
            [self.designerTableView.header beginRefreshing];
        } else {
            [self refreshDesigner];
        }
    }
}

- (IBAction)onClickProduct:(id)sender {
    if (self.favoriateType != FavoriateTypeProduct) {
        self.favoriateType = FavoriateTypeProduct;
        self.designerTableView.hidden = YES;
        self.productTableView.hidden = NO;
        self.beautifulImageCollectionView.hidden = YES;
        
        //刷新数据
        if ([self.favoriateProductPageData.products count] == 0) {
            [self.productTableView.header beginRefreshing];
        } else {
            [self refreshFavoriateProduct];
        }
    }
}
- (IBAction)onClickBeautifulImage:(id)sender {
    if (self.favoriateType != FavoriateTypeBeautifulImage) {
        self.favoriateType = FavoriateTypeBeautifulImage;
        self.designerTableView.hidden = YES;
        self.productTableView.hidden = YES;
        self.beautifulImageCollectionView.hidden = NO;
        
        //刷新数据
        if ([self.favoriateBeautifulImageData.beautifulImages count] == 0) {
            [self.beautifulImageCollectionView.header beginRefreshing];
        } else {
            [self refreshFavoriateBeautifulImage];
        }
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.designerTableView) {
        return [self.favoriateDesignerPageData.designers count];
    } else if (tableView == self.productTableView) {
        return [self.favoriateProductPageData.products count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.designerTableView) {
        FavoriteDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteDesignerCell"];
        [cell initWithDesigner:[self.favoriateDesignerPageData.designers objectAtIndex:indexPath.row]];
        return cell;
    } else if (tableView == self.productTableView) {
        FavoriateProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriateProductCell"];
        [cell initWithProduct:[self.favoriateProductPageData.products objectAtIndex:indexPath.row]
      andDeleteFavoriateBlock:self.deleteFavoriateProductBlock];
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.designerTableView) {
        return 80;
    } else if (tableView == self.productTableView) {
        return 280;
    } else {
        return 0;
    }
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriateBeautifulImageData.beautifulImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FavoriateBeautifulImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FavoriateBeautifulImageCell" forIndexPath:indexPath];
    BeautifulImage *beauitifulImage = self.favoriateBeautifulImageData.beautifulImages[indexPath.item];
    [cell initWithImage:beauitifulImage withDeleteBlock:self.deleteFavoriateBeautifulImageBlock];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BeautifulImageHomePageViewController *controller = [[BeautifulImageHomePageViewController alloc] initWithDataManager:self.favoriateBeautifulImageData index:indexPath.row queryDic:nil dismissBlock:^(NSInteger index) {
        [self.beautifulImageCollectionView reloadData];
        [self.beautifulImageCollectionView layoutIfNeeded];
        UICollectionViewLayoutAttributes *layoutAttributes = self.flowLayout.allItemAttributes[index];
        [self.beautifulImageCollectionView scrollRectToVisible:layoutAttributes.frame animated:YES];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)fallFlowLayout:(CollectionFallsFlowLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    BeautifulImage *beauitifulImage = self.favoriateBeautifulImageData.beautifulImages[indexPath.item];
    LeafImage *leafImage = [beauitifulImage leafImageAtIndex:0];
    
    CGFloat widthHeightFactor = [leafImage.width floatValue] / [leafImage.height floatValue];
    CGFloat cellHeight = width / widthHeightFactor;
    
    return cellHeight;
}

#pragma mark - favoriate designer
- (void)refreshDesigner {
    [self.designerTableView.footer resetNoMoreData];
    [self resetNoDataTip];
    
    ListFavoriteDesigner *request = [[ListFavoriteDesigner alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateDesigner:request success:^{
        @strongify(self);
        [self.designerTableView.header endRefreshing];
        NSInteger count = [self.favoriateDesignerPageData refreshDesigner];
        if (self.favoriateDesignerPageData.designers.count == 0) {
            [self handleNoFavoriateDesigner];
        } else {
            if (request.limit.integerValue > count) {
                [self.designerTableView.footer noticeNoMoreData];
            }
        }
        
        [self.designerTableView reloadData];
    } failure:^{
        @strongify(self);
        [self.designerTableView.header endRefreshing];
    } networkError:^{
        @strongify(self);
        [self.designerTableView.header endRefreshing];
    }];
}

- (void)loadMoreDesigner {
    ListFavoriteDesigner *request = [[ListFavoriteDesigner alloc] init];
    request.from = @(self.favoriateDesignerPageData.designers.count);
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateDesigner:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateDesignerPageData loadMoreDesigner];
        [self.designerTableView.footer endRefreshing];
        if (request.limit.integerValue > count) {
            [self.designerTableView.footer noticeNoMoreData];
        }
        
        [self.designerTableView reloadData];
    } failure:^{
         @strongify(self);
        [self.designerTableView.footer endRefreshing];
    } networkError:^{
         @strongify(self);
        [self.designerTableView.footer endRefreshing];
    }];
}

- (void)handleAfterDeleteFavoriateDesigner:(NSIndexPath *)index {
    [self.favoriateDesignerPageData.designers removeObjectAtIndex:index.row];
    [self.designerTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)resetNoDataTip {
    self.lblNoData.hidden = YES;
    self.noDataImageView.hidden = YES;
}

- (void)handleNoFavoriateDesigner {
    self.lblNoData.text = @"您还没有收藏任何设计师";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_designer"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

#pragma mark - favoriate product
- (void)refreshFavoriateProduct {
    [self.productTableView.footer resetNoMoreData];
    [self resetNoDataTip];
    
    ListFavoriateProduct *request = [[ListFavoriateProduct alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateProduct:request success:^{
        @strongify(self);
        [self.productTableView.header endRefreshing];
        NSInteger count = [self.favoriateProductPageData refreshProduct];
        if (self.favoriateProductPageData.products.count == 0) {
            [self handleNoFavoriateProduct];
        } else {
            if (request.limit.integerValue > count) {
                [self.productTableView.footer noticeNoMoreData];
            }
        }
        
        [self.productTableView reloadData];
    } failure:^{
        @strongify(self);
        [self.productTableView.header endRefreshing];
    } networkError:^{
        @strongify(self);
        [self.productTableView.header endRefreshing];
    }];
}

- (void)loadMoreFavoriateProduct {
    ListFavoriateProduct *request = [[ListFavoriateProduct alloc] init];
    request.from = @(self.favoriateProductPageData.products.count);
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateProduct:request success:^{
        @strongify(self);
        [self.productTableView.footer endRefreshing];
        NSInteger count = [self.favoriateProductPageData loadMoreProduct];
        if (request.limit.integerValue > count) {
            [self.productTableView.footer noticeNoMoreData];
        }
        
        [self.productTableView reloadData];
    } failure:^{
        [self.productTableView.footer endRefreshing];
    } networkError:^{
        [self.productTableView.footer endRefreshing];
    }];
}

- (void)handleAfterDeleteFavoriateProduct:(FavoriateProductCell *)cell {
    NSIndexPath *indexPath = [self.productTableView indexPathForCell:cell];
    [self.favoriateProductPageData.products removeObjectAtIndex:indexPath.row];
    [self.productTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)handleNoFavoriateProduct {
    self.lblNoData.text = @"您还没有收藏任何作品";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_product"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}

#pragma mark - favoriate beautiful image
- (void)refreshFavoriateBeautifulImage {
    [self.beautifulImageCollectionView.footer resetNoMoreData];
    [self resetNoDataTip];
    
    ListFavoriateBeautifulImage *request = [[ListFavoriateBeautifulImage alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateBeautifulImage:request success:^{
        @strongify(self);
        [self.beautifulImageCollectionView.header endRefreshing];
        NSInteger count = [self.favoriateBeautifulImageData refreshBeautifulImages];
        if (self.favoriateBeautifulImageData.beautifulImages.count == 0) {
            [self handleNoFavoriateBeautifulImage];
        } else {
            if (request.limit.integerValue > count) {
                [self.beautifulImageCollectionView.footer noticeNoMoreData];
            }
        }
        
        [self.beautifulImageCollectionView reloadData];
    } failure:^{
        @strongify(self);
        [self.beautifulImageCollectionView.header endRefreshing];
    } networkError:^{
        @strongify(self);
        [self.beautifulImageCollectionView.header endRefreshing];
    }];
}

- (void)loadMoreFavoriateBeautifulImage {
    ListFavoriateBeautifulImage *request = [[ListFavoriateBeautifulImage alloc] init];
    request.from = @(self.favoriateBeautifulImageData.beautifulImages.count);
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateBeautifulImage:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateBeautifulImageData loadMoreBeautifulImages];
        [self.beautifulImageCollectionView.footer endRefreshing];
        if (request.limit.integerValue > count) {
            [self.beautifulImageCollectionView.footer noticeNoMoreData];
        }
        
        [self.beautifulImageCollectionView reloadData];
    } failure:^{
        [self.beautifulImageCollectionView.footer endRefreshing];
    } networkError:^{
        [self.beautifulImageCollectionView.footer endRefreshing];
    }];
}

- (void)handleAfterDeleteFavoriateBeautifulImage:(FavoriateBeautifulImageCell *)cell {
    NSIndexPath *indexPath = [self.beautifulImageCollectionView indexPathForCell:cell];
    [self.favoriateBeautifulImageData.beautifulImages removeObjectAtIndex:indexPath.item];
    [self.beautifulImageCollectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)handleNoFavoriateBeautifulImage {
    self.lblNoData.text = @"您还没有收藏任何美图";
    self.noDataImageView.image = [UIImage imageNamed:@"no_favoriate_beautiful_image"];
    self.lblNoData.hidden = NO;
    self.noDataImageView.hidden = NO;
}


- (void)dealloc {
    DDLogDebug(@"dealloc");
}


@end
