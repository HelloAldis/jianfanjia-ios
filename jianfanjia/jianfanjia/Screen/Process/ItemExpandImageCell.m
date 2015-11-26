//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "ItemExpandImageCell.h"
#import "ItemImageCollectionCell.h"

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
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;


@property (weak, nonatomic) Process *process;
@property (weak, nonatomic) Item *item;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) NSInteger itemIndex;

@end

@implementation ItemExpandImageCell

#pragma mark - life cycle
- (void)awakeFromNib {
    CGFloat width = (self.frame.size.width - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.itemSize = CGSizeMake(width, width);
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollection.tag = 100;
}

#pragma mark - UI
- (void)initWithItem:(Item *)item sectionIndex:(NSInteger )sectionIndex itemIndex:(NSInteger)itemIndex forProcess:(Process *)process  {
    self.process = process;
    self.item = item;
    self.sectionIndex = sectionIndex;
    self.itemIndex = itemIndex;
    self.lblItemTitle.text = [ProcessBusiness nameForKey:item.name];
    
    [self.imgCollection reloadData];
}

#pragma mark - collection delegate 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.item.images.count < MAX_IMG_COUNT ? self.item.images.count + 1 : self.item.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
    NSString *imgURL = self.item.images[indexPath.row];
    
    if (imgURL) {
         [cell.image setImageWithId:imgURL withWidth:self.imgCollectionLayout.itemSize.width];
    } else {
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAddGesture:)]];
    }
    
    return cell;
}

#pragma mark - geture 
- (void)handleTapAddGesture:(UITapGestureRecognizer *)gesture {
    
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    UICollectionView *collectionView =(UICollectionView *) [self viewWithTag:100];
    collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);//set the frames for tableview
}

@end
