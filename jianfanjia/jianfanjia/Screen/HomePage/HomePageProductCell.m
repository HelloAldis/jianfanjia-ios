//
//  BannerCellTableViewCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "HomePageProductCell.h"
#import "ViewControllerContainer.h"

static NSString *HomePageProductItemIdentifier = @"HomePageProductItem";

@interface HomePageProductCell()
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIImageView *iconProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconRightArrow;

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) BOOL isShowProduct;

@property (nonatomic, strong) UIView *guideView;

@end

@implementation HomePageProductCell

- (void)awakeFromNib {
    [self.imgCollection registerNib:[UINib nibWithNibName:HomePageProductItemIdentifier bundle:nil] forCellWithReuseIdentifier:HomePageProductItemIdentifier];
    self.flowLayout.itemSize = CGSizeMake(kScreenWidth, kHomePageProductItemHeight);
    [self.iconProduct addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProduct:)]];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showProduct:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    swipe.delegate = self;
    [self.imgCollection addGestureRecognizer:swipe];
    RAC(self.iconRightArrow, hidden) = RACObserve([GVUserDefaults standardUserDefaults], wasShowProductCaseRightArrow);
}

- (void)initWithProducts:(NSArray *)products isShowProduct:(BOOL)isShowProduct {
    self.products = products;
    self.isShowProduct = isShowProduct;
    [self.imgCollection reloadData];
    if (self.isShowProduct) {
        [self addUserHelper];
    }
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageProductItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageProductItemIdentifier forIndexPath:indexPath];
    [cell initWithProduct:self.products[indexPath.row]];
    
    return cell;
}

#pragma mark - UIScroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= kScreenWidth) {
        [GVUserDefaults standardUserDefaults].wasShowProductCaseRightArrow = YES;
    }
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.isShowProduct;
}

#pragma mark - user action
- (void)showProduct:(UIGestureRecognizer *)g {
    CGPoint point = [g locationInView:self];
    if (self.guideView && [g isKindOfClass:[UITapGestureRecognizer class]] && !CGRectContainsPoint(self.iconProduct.frame, point)) {
      return;
    }
    
    [self removeUserHelper];
    point = [g locationInView:self.imgCollection];
    NSIndexPath *index = [self.imgCollection indexPathForItemAtPoint:point];
    [ViewControllerContainer showProduct:[self.products[index.row] _id] isModal:YES];
}

- (IBAction)onClickAllProduct:(id)sender {
    [ViewControllerContainer showProductCaseList];
}

#pragma mark - util
- (void)addUserHelper {
    if (![GVUserDefaults standardUserDefaults].wasShowProductCaseUserHelper) {
        [GVUserDefaults standardUserDefaults].wasShowProductCaseUserHelper = YES;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIImage *img = [UIImage imageNamed:@"img_swipe_up"];
        self.guideView = [[UIView alloc] initWithFrame:window.bounds];
        [self.guideView.layer addSublayer:[CALayer createMask:window.bounds withTransparentHole:CGRectOffset(self.iconProduct.frame, 0, kNavWithStatusBarHeight - self.lblTitle.frame.size.height)]];
        [self.guideView.layer addSublayer:[CALayer createLayer:CGRectMake((kScreenWidth - img.size.width) / 2, (kScreenHeight - img.size.height) / 2, img.size.width, img.size.height) image:img]];
        [window addSubview:self.guideView];
        [self.guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProduct:)]];
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showProduct:)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self.guideView addGestureRecognizer:swipe];
    }
}

- (void)removeUserHelper {
    if (self.guideView) {
        [self.guideView removeFromSuperview];
    }
}

@end
