//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "PrettyPictureViewController.h"
#import "PrettyImageCollectionCell.h"
#import "ImageDetailViewController.h"
#import "ViewControllerContainer.h"
#import "MessageAlertViewController.h"
#import "PrettyPictureDataManager.h"
#import "API.h"

static NSString *PrettyImageCollectionCellIdentifier = @"PrettyImageCollectionCell";

@interface PrettyPictureViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet PrettyPictureFallsLayout *imgCollectionLayout;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;

@property (strong, nonatomic) PrettyPictureDataManager *dataManager;

@property (assign, nonatomic) CGFloat preY;
@property (assign, nonatomic) BOOL isTabbarhide;

@end

@implementation PrettyPictureViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshPrettyPicture];
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
    self.dataManager = [[PrettyPictureDataManager alloc] init];
    [self.imgCollection registerNib:[UINib nibWithNibName:PrettyImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:PrettyImageCollectionCellIdentifier];
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    self.imgCollectionLayout.delegate = self;
    
    @weakify(self);
    self.imgCollection.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshPrettyPicture];
    }];
    
    self.imgCollection.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMorePrettyPicture];
    }];
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
    return self.dataManager.prettyPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PrettyImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PrettyImageCollectionCellIdentifier forIndexPath:indexPath];
    
    BeautifulImage *beauitifulImage = self.dataManager.prettyPictures[indexPath.row];
    LeafImage *leafImage = [beauitifulImage leafImageAtIndex:0];
    
    [cell initWithImage:leafImage.imageid width:cell.bounds.size.width];
    return cell;
}

- (CGFloat)fallFlowLayout:(PrettyPictureFallsLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    BeautifulImage *beauitifulImage = self.dataManager.prettyPictures[indexPath.row];
    LeafImage *leafImage = [beauitifulImage leafImageAtIndex:0];
    
    CGFloat widthHeightFactor = [leafImage.width floatValue] / [leafImage.height floatValue];
    CGFloat cellHeight = width / widthHeightFactor;
    
    if (indexPath.row == 0 || indexPath.row == 3) {
        cellHeight += 200;
    }
    
    return cellHeight;
}

#pragma mark - gesture
- (void)handleTapImageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.imgCollection];
    NSIndexPath *indexPath = [self.imgCollection indexPathForItemAtPoint:point];
    
    if (!indexPath) {
        return;
    }
    
    
}

#pragma mark - refresh
- (void)refreshPrettyPicture {
    SearchPrettyImage *request = [[SearchPrettyImage alloc] init];
    request.from = @0;
    request.limit = @10;
    
    [API searchPrettyImage:request success:^{
        [self.imgCollection.header endRefreshing];
        [self.dataManager refreshPrettyPicture];
        if (request.limit.integerValue > self.dataManager.prettyPictures.count) {
            [self.imgCollection.footer noticeNoMoreData];
        }
        
        [self.imgCollection reloadData];
    } failure:^{
        [self.imgCollection.header endRefreshing];
    } networkError:^{
        [self.imgCollection.header endRefreshing];
    }];
}

- (void)loadMorePrettyPicture {
    SearchPrettyImage *request = [[SearchPrettyImage alloc] init];
    request.from = @(self.dataManager.prettyPictures.count);
    request.limit = @10;
    
    [API searchPrettyImage:request success:^{
        [self.imgCollection.footer endRefreshing];
        NSInteger currentCount = self.dataManager.prettyPictures.count;
        [self.dataManager loadMorePrettyPicture];
        NSInteger totalCount = self.dataManager.prettyPictures.count;
        
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:totalCount - currentCount];
        for (NSInteger i = currentCount; i < totalCount; i++) {
            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        NSInteger moreCount = totalCount - currentCount;
        if (moreCount > 0) {
            [self.imgCollection insertItemsAtIndexPaths:insertIndexPaths];
        }
        
        if (moreCount == 0) {
            [self.imgCollection.footer noticeNoMoreData];
        }
    } failure:^{
        [self.imgCollection.footer endRefreshing];
    } networkError:^{
        [self.imgCollection.footer endRefreshing];
    }];
}

@end
