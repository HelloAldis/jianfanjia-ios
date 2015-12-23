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
    
    self.deleteFavoriateProductBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        [self handleAfterDeleteFavoriateProduct:indexPath];
    };
    
    
    self.designerTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreDesigner];
    }];
    self.productTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreFavoriateProduct];
    }];
    self.beautifulImageCollectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);

    }];
    
    self.designerTableView.hidden = NO;
    self.productTableView.hidden = YES;
    self.beautifulImageCollectionView.hidden = YES;
    
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
            [self refreshDesigner];
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
        [self refreshDesigner];
    }
}

- (IBAction)onClickProduct:(id)sender {
    if (self.favoriateType != FavoriateTypeProduct) {
        self.favoriateType = FavoriateTypeProduct;
        self.designerTableView.hidden = YES;
        self.productTableView.hidden = NO;
        self.beautifulImageCollectionView.hidden = YES;
        
        //刷新数据
        [self refreshFavoriateProduct];

    }
}
- (IBAction)onClickBeautifulImage:(id)sender {
    if (self.favoriateType != FavoriateTypeBeautifulImage) {
        self.favoriateType = FavoriateTypeBeautifulImage;
        self.designerTableView.hidden = YES;
        self.productTableView.hidden = YES;
        self.beautifulImageCollectionView.hidden = NO;
    }
}


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.favoriateType) {
        case FavoriateTypeDesigner:
            return [self.favoriateDesignerPageData.designers count];
        case FavoriateTypeProduct:
            return [self.favoriateProductPageData.products count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.favoriateType) {
        case FavoriateTypeDesigner:{
            FavoriteDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteDesignerCell"];
            [cell initWithDesigner:[self.favoriateDesignerPageData.designers objectAtIndex:indexPath.row]];
            return cell;
        }
        case FavoriateTypeProduct: {
            FavoriateProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriateProductCell"];
            [cell initWithProduct:[self.favoriateProductPageData.products objectAtIndex:indexPath.row]
                     andIndexPath:indexPath
          andDeleteFavoriateBlock:self.deleteFavoriateProductBlock];
            return cell;
        }
        default:
            return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.favoriateType) {
        case FavoriateTypeDesigner:
            return 80;
        case FavoriateTypeProduct:
            return 280;
        default:
            return 0;
    }
}

#pragma mark - collection view delegate


#pragma mark - favoriate designer
- (void)refreshDesigner {
    ListFavoriteDesigner *request = [[ListFavoriteDesigner alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateDesigner:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateDesignerPageData refreshDesigner];
        if (self.favoriateDesignerPageData.designers.count == 0) {
//            self.lblUnavailableDesigner.hidden = NO;
            self.designerTableView.hidden = YES;
        } else {
//            self.lblUnavailableDesigner.hidden = YES;
            self.designerTableView.hidden = NO;
            if (request.limit.integerValue > count) {
                [self.designerTableView.footer noticeNoMoreData];
            }
            
            [self.designerTableView reloadData];
        }
    } failure:^{
        
    } networkError:^{
        
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
        [self.designerTableView.footer endRefreshing];
    } networkError:^{
        [self.designerTableView.footer endRefreshing];
    }];
}

- (void)handleAfterDeleteFavoriateDesigner:(NSIndexPath *)index {
    [self.favoriateDesignerPageData.designers removeObjectAtIndex:index.row];
    [self.designerTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - favoriate product
- (void)refreshFavoriateProduct {
    ListFavoriateProduct *request = [[ListFavoriateProduct alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateProduct:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateProductPageData refreshProduct];
        if (self.favoriateProductPageData.products.count == 0) {
            //            self.lblUnavailableDesigner.hidden = NO;
            self.productTableView.hidden = YES;
        } else {
            //            self.lblUnavailableDesigner.hidden = YES;
            self.productTableView.hidden = NO;
            if (request.limit.integerValue > count) {
                [self.productTableView.footer noticeNoMoreData];
            }
            
            [self.productTableView reloadData];
        }
    } failure:^{
        
    } networkError:^{
        
    }];
}

- (void)loadMoreFavoriateProduct {
    ListFavoriateProduct *request = [[ListFavoriateProduct alloc] init];
    request.from = @(self.favoriateProductPageData.products.count);
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateProduct:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateProductPageData loadMoreProduct];
        [self.productTableView.footer endRefreshing];
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

- (void)handleAfterDeleteFavoriateProduct:(NSIndexPath *)index {
    [self.favoriateProductPageData.products removeObjectAtIndex:index.row];
    [self.productTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - favoriate beautiful image
- (void)refreshFavoriateBeautifulImage {
    ListFavoriateBeautifulImage *request = [[ListFavoriateBeautifulImage alloc] init];
    request.from = @0;
    request.limit = @20;
    
    @weakify(self);
    [API listFavoriateBeautifulImage:request success:^{
        @strongify(self);
        NSInteger count = [self.favoriateBeautifulImageData refreshBeautifulImages];
        if (self.favoriateBeautifulImageData.beautifulImages.count == 0) {
            //            self.lblUnavailableDesigner.hidden = NO;
            self.beautifulImageCollectionView.hidden = YES;
        } else {
            //            self.lblUnavailableDesigner.hidden = YES;
            self.beautifulImageCollectionView.hidden = NO;
            if (request.limit.integerValue > count) {
                [self.beautifulImageCollectionView.footer noticeNoMoreData];
            }
            
            [self.beautifulImageCollectionView reloadData];
        }
    } failure:^{
        
    } networkError:^{
        
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

- (void)handleAfterDeleteFavoriateBeautifulImage:(NSIndexPath *)index {
    [self.favoriateBeautifulImageData.beautifulImages removeObjectAtIndex:index.row];
    [self.beautifulImageCollectionView deleteItemsAtIndexPaths:@[index]];
}

- (void)dealloc {
    DDLogDebug(@"dealloc");
}


@end
