//
//  BannerCellTableViewCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "HomePagePackageCell.h"
#import "HomePagePackageItemCell.h"
#import "ViewControllerContainer.h"
#import "WebViewController.h"
#import "WebViewWithActionController.h"
#import "RequestPlanViewController.h"

CGFloat kHomePagePackageCellHeight;

static const NSInteger COUNT_IN_ONE_ROW = 2;
static const NSInteger CELL_SPACE = 8;
static const NSInteger SECTION_LEFT = CELL_SPACE;
static const NSInteger SECTION_BOTTOM = 15;
static const NSInteger HEADER_HEIGHT = 0;
static const NSInteger FOOTER_HEIGHT = 8;

static NSString *HomePagePackageItemCellIdentifier = @"HomePagePackageItemCell";
static NSString *HomePagePackageItemCellHeaderIdentifier = @"HomePageQuickEntryItemHeader";
static NSString *HomePagePackageItemCellFooterIdentifier = @"HomePageQuickEntryItemFooter";

static NSArray const *imgs;
static NSArray const *urls;
static CGFloat itemWidth;
static CGFloat itemHeight;

@interface HomePagePackageCell()
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) CGFloat quickEntryItemWidth;

@end

@implementation HomePagePackageCell

+ (void)initialize {
    if ([self class] == [HomePagePackageCell class] ) {
        imgs = @[@"package_jian+", @"package_365"];
        urls = @[@"weixin/jian/", kPkg365Url];
        
        itemWidth = (kScreenWidth - SECTION_LEFT * 2 - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
        itemHeight = floor(itemWidth / 590.0 * 680.0);
        kHomePagePackageCellHeight = itemHeight + SECTION_BOTTOM + HEADER_HEIGHT + FOOTER_HEIGHT;
    }
}

- (void)awakeFromNib {
    [self.imgCollection registerNib:[UINib nibWithNibName:HomePagePackageItemCellIdentifier bundle:nil] forCellWithReuseIdentifier:HomePagePackageItemCellIdentifier];
    [self.imgCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePagePackageItemCellHeaderIdentifier];
    [self.imgCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HomePagePackageItemCellFooterIdentifier];
    
    self.flowLayout.minimumLineSpacing = CELL_SPACE;
    self.flowLayout.minimumInteritemSpacing = CELL_SPACE;
    self.flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, HEADER_HEIGHT);
    self.flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, FOOTER_HEIGHT);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, SECTION_LEFT, SECTION_BOTTOM, SECTION_LEFT);
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePagePackageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePagePackageItemCellIdentifier forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:imgs[indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePagePackageItemCellHeaderIdentifier forIndexPath:indexPath];
        reusableview = headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HomePagePackageItemCellFooterIdentifier forIndexPath:indexPath];
        reusableview = footerView;
    }
    
    reusableview.backgroundColor = kViewBgColor;
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *curUrl = urls[indexPath.row];
    if ([curUrl isEqualToString:kPkg365Url]) {
        [WebViewWithActionController show:[ViewControllerContainer getCurrentTapController] withUrl:curUrl shareTopic:ShareTopicActivity actionTitle:@"我要装修" actionBlock:^{
            [RequestPlanViewController show];
        }];
    } else {
        [WebViewController show:[ViewControllerContainer getCurrentTapController] withUrl:curUrl shareTopic:ShareTopicActivity];
    }
}

@end
