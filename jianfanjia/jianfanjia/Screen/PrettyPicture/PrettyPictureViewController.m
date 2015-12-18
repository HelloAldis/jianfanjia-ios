//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "PrettyPictureViewController.h"
#import "ItemImageCollectionCell.h"
#import "ImageDetailViewController.h"
#import "ViewControllerContainer.h"
#import "MessageAlertViewController.h"
#import "API.h"

static const NSInteger COUNT_IN_ONE_ROW = 2;
static const NSInteger CELL_SPACE = 10;
static const NSInteger SECTION_EDGE = 10;

static CGFloat cellWidth;

static NSString *PrettyImageCollectionCellIdentifier = @"PrettyImageCollectionCell";

@interface PrettyPictureViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnChooseTypes;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *angleImages;

@property (strong, nonatomic) NSMutableArray *imgArray;

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
    [self.imgCollection registerNib:[UINib nibWithNibName:PrettyImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:PrettyImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollectionLayout.sectionInset = UIEdgeInsetsMake(SECTION_EDGE, SECTION_EDGE, SECTION_EDGE, SECTION_EDGE);
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellWidth = (kScreenWidth - SECTION_EDGE * 2 - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    });
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
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PrettyImageCollectionCellIdentifier forIndexPath:indexPath];
    [cell initWithImage:[UIImage imageNamed:@"waitToUpload"]];
    return cell;
}

#pragma mark - gesture
- (void)handleTapImageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.imgCollection];
    NSIndexPath *indexPath = [self.imgCollection indexPathForItemAtPoint:point];
    
    if (!indexPath) {
        return;
    }
    
    
}

@end
