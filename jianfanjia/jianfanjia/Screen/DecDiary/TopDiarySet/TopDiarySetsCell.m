//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TopDiarySetsCell.h"
#import "TopDiarySetCell.h"
#import "ViewControllerContainer.h"

static const NSInteger CELL_SPACE = 8;
static const NSInteger SECTION_LEFT = 20;

CGFloat kTopDiarySetsCellHeight;

static NSString* cellId = @"TopDiarySetCell";
static CGFloat cellWidth;
static CGFloat cellHeight;

@interface TopDiarySetsCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) NSArray *topDiarySets;

@end

@implementation TopDiarySetsCell

+ (void)initialize {
    if ([self class] == [TopDiarySetsCell class]) {
        cellWidth = (kScreenWidth - SECTION_LEFT - 2 * CELL_SPACE) / 2.0 - 10;
        cellHeight = round(cellWidth / 540.0 * 707.0);
        kTopDiarySetsCellHeight = cellHeight + 67.0;
    }
}

- (void)awakeFromNib {
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    self.collectionFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.collectionFlowLayout.minimumInteritemSpacing = CELL_SPACE;
    self.collectionFlowLayout.minimumLineSpacing = CELL_SPACE;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(0, SECTION_LEFT, 0, SECTION_LEFT);
}

- (void)initWithDiarySets:(NSArray *)topDiarySets {
    self.topDiarySets = topDiarySets;
    [self.collectionView reloadData];
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.topDiarySets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopDiarySetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell initWithDiarySet:self.topDiarySets[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [ViewControllerContainer showDiarySetDetail:self.topDiarySets[indexPath.row] fromNewDiarySet:NO];
}

@end
