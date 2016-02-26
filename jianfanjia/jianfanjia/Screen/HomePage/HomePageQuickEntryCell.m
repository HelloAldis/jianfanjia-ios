//
//  BannerCellTableViewCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "HomePageQuickEntryCell.h"
#import "HomePageQuickEntryItem.h"
#import "ViewControllerContainer.h"
#import "WebViewController.h"

CGFloat kHomePageQuickEntryCellHeight;

static const NSInteger COUNT_IN_ONE_ROW = 4;
static const NSInteger CELL_SPACE = 0;
static const NSInteger HEADER_HEIGHT = 0;
static const NSInteger FOOTER_HEIGHT = 8;
static const NSInteger SECTION_HEIGHT = 15;
static const NSInteger ITEM_HEIGHT = 88;

static NSString *HomePageQuickEntryItemIdentifier = @"HomePageQuickEntryItem";
static NSString *HomePageQuickEntryItemHeaderIdentifier = @"HomePageQuickEntryItemHeader";
static NSString *HomePageQuickEntryItemFooterIdentifier = @"HomePageQuickEntryItemFooter";

static NSArray const *quickEntryImages;
static NSArray const *quickEntryTexts;

@interface HomePageQuickEntryCell()
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) CGFloat quickEntryItemWidth;

@end

@implementation HomePageQuickEntryCell

+ (void)initialize {
    if ([self class] == [HomePageQuickEntryCell class] ) {
        HomePageQuickEntryFreePlan = @"免费方案";
        HomePageQuickEntryDecStrategy = @"装修攻略";
        HomePageQuickEntryBeautifulImage = @"装修美图";
        HomePageQuickEntryMassDesigner = @"海量设计师";
        
        quickEntryTexts = @[HomePageQuickEntryFreePlan, HomePageQuickEntryDecStrategy, HomePageQuickEntryBeautifulImage, HomePageQuickEntryMassDesigner];
        quickEntryImages = @[@"icon_publish_requirement", @"icon_dec_guide", @"icon_dec_beautiful_img", @"icon_mass_designer"];
        
        kHomePageQuickEntryCellHeight = ITEM_HEIGHT + SECTION_HEIGHT * 2 + HEADER_HEIGHT + FOOTER_HEIGHT;
    }
}

- (void)awakeFromNib {
    [self.imgCollection registerNib:[UINib nibWithNibName:HomePageQuickEntryItemIdentifier bundle:nil] forCellWithReuseIdentifier:HomePageQuickEntryItemIdentifier];
    [self.imgCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePageQuickEntryItemHeaderIdentifier];
    [self.imgCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HomePageQuickEntryItemFooterIdentifier];
    
    self.flowLayout.minimumLineSpacing = CELL_SPACE;
    self.flowLayout.minimumInteritemSpacing = CELL_SPACE;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(SECTION_HEIGHT, 0, SECTION_HEIGHT, 0);
    self.flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, HEADER_HEIGHT);
    self.flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, FOOTER_HEIGHT);
    self.quickEntryItemWidth = (kScreenWidth - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    self.flowLayout.itemSize = CGSizeMake(self.quickEntryItemWidth, ITEM_HEIGHT);
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return quickEntryImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageQuickEntryItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomePageQuickEntryItemIdentifier forIndexPath:indexPath];
    cell.image.image = [UIImage imageNamed:quickEntryImages[indexPath.row]];
    cell.lblText.text = quickEntryTexts[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomePageQuickEntryItemHeaderIdentifier forIndexPath:indexPath];
        reusableview = headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:HomePageQuickEntryItemFooterIdentifier forIndexPath:indexPath];
        reusableview = footerView;
    }
    
    reusableview.backgroundColor = kViewBgColor;
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *entry = quickEntryTexts[indexPath.row];
    if ([entry isEqualToString:HomePageQuickEntryMassDesigner]) {
        [ViewControllerContainer showDesignerList];
    } else if ([entry isEqualToString:HomePageQuickEntryBeautifulImage]) {
        [ViewControllerContainer showBeautifulImage];
    } else if ([entry isEqualToString:HomePageQuickEntryFreePlan]) {
        [ViewControllerContainer showRequirementCreate:nil];
    } else if ([entry isEqualToString:HomePageQuickEntryDecStrategy]) {
        [WebViewController show:[ViewControllerContainer getCurrentTapController] withUrl:@"view/article/" shareTopic:ShareTopicDecStrategy];
    }
}

@end
