//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ItemExpandImageCell.h"
#import "ItemImageCollectionCell.h"
#import "UIItemImageCollectionView.h"

static const NSInteger MAX_IMG_COUNT = 9;
static const NSInteger COUNT_IN_ONE_ROW = 3;
static const NSInteger CELL_SPACE = 1;

static NSString *ImageCollectionCellIdentifier = @"ItemImageCollectionCell";

@interface ItemExpandImageCell ()

@property (weak, nonatomic) IBOutlet UIView *statusLine1;
@property (weak, nonatomic) IBOutlet UIView *statusLine2;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblItemStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLeaveMessageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLeaveMessageIcon;
@property (weak, nonatomic) IBOutlet UIItemImageCollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;

@property (weak, nonatomic) Process *process;
@property (weak, nonatomic) Item *item;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) NSInteger itemIndex;

@end

@implementation ItemExpandImageCell

#pragma mark - life cycle
- (void)awakeFromNib {
    
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    DDLogDebug(@"bounds %f %f", self.imgCollection.bounds.size.width, self.imgCollection.bounds.size.height);
}

#pragma mark - UI
- (void)initWithItem:(Item *)item sectionIndex:(NSInteger )sectionIndex itemIndex:(NSInteger)itemIndex forProcess:(Process *)process  {
    self.process = process;
    self.item = item;
    self.sectionIndex = sectionIndex;
    self.itemIndex = itemIndex;
    self.lblItemTitle.text = [ProcessBusiness nameForKey:item.name];
}

#pragma mark - collection delegate 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.item.images.count < MAX_IMG_COUNT ? self.item.images.count + 1 : self.item.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
    if (indexPath.row < self.item.images.count) {
        NSString *imgURL = self.item.images[indexPath.row];
        [cell.image setImageWithId:imgURL withWidth:self.imgCollectionLayout.itemSize.width];
    } else {
//        cell.image.frame = CGRectMake(cell.image.frame.origin.x, cell.image.frame.origin.y, self.imgCollectionLayout.itemSize.width, self.imgCollectionLayout.itemSize.height);
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAddGesture:)]];
    }

    return cell;
}

#pragma mark - geture 
- (void)handleTapAddGesture:(UITapGestureRecognizer *)gesture {
//    self.imgCollection.viewContentSize = CGSizeMake(self.imgCollection.frame.size.width, 500);
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    DDLogDebug(@"bounds %f %f", self.imgCollection.bounds.size.width, self.imgCollection.bounds.size.height);
    CGFloat width = (self.imgCollection.frame.size.width - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    self.imgCollectionLayout.itemSize = CGSizeMake(width, width);
    self.imgCollection.viewContentSize = CGSizeMake(self.imgCollection.frame.size.width, width);
    [self.imgCollection invalidateIntrinsicContentSize];
}

- (void)updateConstraints {
    [super updateConstraints];
}

@end
