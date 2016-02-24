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
}

- (void)initWithProducts:(NSArray *)products isShowProduct:(BOOL)isShowProduct {
    self.products = products;
    self.isShowProduct = isShowProduct;
    [self.imgCollection reloadData];
    [self createGuide];
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

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.isShowProduct;
}

#pragma mark - user action
- (void)showProduct:(UIGestureRecognizer *)g {
    CGPoint point = [g locationInView:self.imgCollection];
    NSIndexPath *index = [self.imgCollection indexPathForItemAtPoint:point];
    [ViewControllerContainer showProduct:[self.products[index.row] _id] isModal:YES];
}

- (IBAction)onClickAllProduct:(id)sender {
    [ViewControllerContainer showProductCaseList];
}

#pragma mark - util
- (void)createGuide {
    if (!self.isShowProduct) {
        return;
    }
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    self.guideView = [[UIView alloc] initWithFrame:window.bounds];
//    [self.guideView.layer addSublayer:[CALayer createMask:window.bounds]];
//    [window addSubview:self.guideView];
}

@end
