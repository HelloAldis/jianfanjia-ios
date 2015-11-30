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
#import "ViewControllerContainer.h"
#import "ProcessDataManager.h"

static const NSInteger MAX_IMG_COUNT = 9;
static const NSInteger COUNT_IN_ONE_ROW = 3;
static const NSInteger CELL_SPACE = 1;

static NSString *ImageCollectionCellIdentifier = @"ItemImageCollectionCell";

static CGFloat imgCollectionWidth;
static CGFloat imgCellWidth;

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

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (weak, nonatomic) Item *item;
@property (copy, nonatomic) void(^refreshBlock)(void);

@property (assign, nonatomic) NSInteger numberOfItemsInsection;

@end

@implementation ItemExpandImageCell

#pragma mark - life cycle
- (void)awakeFromNib {
    DDLogDebug(@"ItemExpandImageCell %@", self);
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollection.scrollEnabled = NO;
}

#pragma mark - UI
- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager withBlock:(void(^)(void))refreshBlock {
    self.refreshBlock = refreshBlock;
    self.dataManager = dataManager;
    self.item = item;
    self.lblItemTitle.text = [ProcessBusiness nameForKey:item.name];
    self.lblLastUpdateTime.text = self.item.date.longLongValue > 0 ? [NSDate yyyy_MM_dd_HH_mm:self.item.date] : @"";
    
    if ([self.item.status isEqualToString:kSectionStatusOnGoing]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_1"];
        self.statusLine2.backgroundColor = kFinishedColor;
    } else if([self.item.status isEqualToString:kSectionStatusAlreadyFinished]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_2"];
        self.statusLine2.backgroundColor = kFinishedColor;
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_0"];
        self.statusLine2.backgroundColor = kUntriggeredColor;
    }
    
    self.numberOfItemsInsection = self.item.images.count < MAX_IMG_COUNT ? self.item.images.count + 1 : self.item.images.count;
    if (imgCollectionWidth > 0) {
        self.imgCollectionLayout.itemSize = CGSizeMake(imgCellWidth, imgCellWidth);
        self.imgCollection.viewContentSize = CGSizeMake(imgCollectionWidth,  imgCellWidth * (self.numberOfItemsInsection % COUNT_IN_ONE_ROW == 0 ? self.numberOfItemsInsection / COUNT_IN_ONE_ROW : (NSInteger)(self.numberOfItemsInsection / COUNT_IN_ONE_ROW) + 1));
        [self.imgCollection invalidateIntrinsicContentSize];
    }
    [self.imgCollection reloadData];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItemsInsection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];

    for (UIGestureRecognizer *gesture in cell.gestureRecognizers) {
        [cell removeGestureRecognizer:gesture];
    }
    
    if (indexPath.row < self.item.images.count) {
        NSString *imgURL = self.item.images[indexPath.row];
        [cell.image setImageWithId:imgURL withWidth:self.imgCollectionLayout.itemSize.width];
    } else {
        cell.image.image = [UIImage imageNamed:@"btn_add_image"];
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAddGesture:)]];
//        [cell enableEditing];
    }

    return cell;
}

#pragma mark - geture 
- (void)handleTapAddGesture:(UITapGestureRecognizer *)gesture {
    @weakify(self);
    [PhotoUtil showDecorationNodeImageSelector:MAX_IMG_COUNT - self.item.images.count withBlock:^(NSArray *imageIds) {
        @strongify(self);
        DDLogDebug(@"%@", imageIds);
        UploadImageToProcess *request = [[UploadImageToProcess alloc] init];
        request._id = self.dataManager.process._id;
        request.section = self.dataManager.selectedSection.name;
        request.item = self.item.name;
        request.images = imageIds;
        [API uploadImageToProcess:request success:^{
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        } failure:^{
            
        }];

    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self.imgCollection setNeedsLayout];
        [self.imgCollection layoutIfNeeded];
        imgCollectionWidth = self.imgCollection.frame.size.width;
        imgCellWidth = (imgCollectionWidth - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
        DDLogDebug(@"bounds %f %f", imgCollectionWidth, imgCellWidth);
        self.imgCollectionLayout.itemSize = CGSizeMake(imgCellWidth, imgCellWidth);
        self.imgCollection.viewContentSize = CGSizeMake(imgCollectionWidth,  imgCellWidth * (self.numberOfItemsInsection % COUNT_IN_ONE_ROW == 0 ? self.numberOfItemsInsection / COUNT_IN_ONE_ROW : (NSInteger)(self.numberOfItemsInsection / COUNT_IN_ONE_ROW) + 1));
        [self.imgCollection invalidateIntrinsicContentSize];
    });
}

@end
