//
//  ItemCell.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "GroupImageEditCell.h"
#import "ItemImageCollectionCell.h"
#import "UIItemImageCollectionView.h"
#import "ViewControllerContainer.h"
#import "ProcessDataManager.h"

static const NSInteger MAX_IMG_COUNT = 9;
static const NSInteger COUNT_IN_ONE_ROW = 3;
static const NSInteger CELL_SPACE = 3;

static NSString *ImageCollectionCellIdentifier = @"ItemImageCollectionCell";

static CGFloat imgCollectionWidth;
static CGFloat imgCellWidth;

@interface GroupImageEditCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIItemImageCollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (copy, nonatomic) void(^refreshBlock)(BOOL isNeedReload);

@property (assign, nonatomic) NSInteger numberOfItemsInsection;
@property (assign, nonatomic) BOOL isShaking;

@end

@implementation GroupImageEditCell

#pragma mark - life cycle
- (void)awakeFromNib {
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollection.scrollEnabled = NO;
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    [self.imgCollection addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
    imgCollectionWidth = kScreenWidth - 87;
    imgCellWidth = (imgCollectionWidth - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
}

#pragma mark - UI
- (void)initWithItem:(EditCellItem *)item {
    [super initWithItem:item];
    if (item.attrTitle) {
        self.lblTitle.attributedText = item.attrTitle;
    } else {
        self.lblTitle.attributedText = nil;
        self.lblTitle.text = item.title;
    }
}
//
//- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager withBlock:(void(^)(BOOL isNeedReload))refreshBlock {
//    self.refreshBlock = refreshBlock;
//    
//    [self refreshNumberOfItems];
//    if (imgCollectionWidth > 0) {
//        [self refreshViewContentSize];
//    }
//    [self.imgCollection reloadData];
//}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.numberOfItemsInsection;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
//
//    if (indexPath.row < self.item.images.count) {
//        NSString *imgURL = self.item.images[indexPath.row];
//        [cell initWithImage:imgURL width:self.imgCollectionLayout.itemSize.width];
//    } else {
//        [cell initWithImage:nil width:0];
//    }
//
//    return cell;
//}
//
//#pragma mark - user action
//- (void)deleteImage:(NSIndexPath *)indexPath {
//    [self.item.images removeObjectAtIndex:indexPath.row];
//    [self refreshNumberOfItems];
//    if (self.numberOfItemsInsection == MAX_IMG_COUNT) {
//        @weakify(self);
//        [self.imgCollection performBatchUpdates:^{
//            @strongify(self);
//            [self.imgCollection deleteItemsAtIndexPaths:@[indexPath]];
//            [self.imgCollection insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:MAX_IMG_COUNT - 1 inSection:0]]];
//        } completion:nil];
//    } else {
//        @weakify(self);
//        [self.imgCollection performBatchUpdates:^{
//            @strongify(self);
//            [self.imgCollection deleteItemsAtIndexPaths:@[indexPath]];
//        } completion:nil];
//    }
//    [self refreshViewContentSize];
//    if (self.refreshBlock) {
//        self.refreshBlock(NO);
//    }
//    
//    DeleteImageFromProcess *request = [[DeleteImageFromProcess alloc] init];
//    request._id = self.dataManager.process._id;
//    request.section = self.dataManager.selectedSection.name;
//    request.item = self.item.name;
//    request.index = @(indexPath.row);
//    
//    [API deleteImageFromeProcess:request success:^{
//    } failure:^{
//        
//    } networkError:^{
//        
//    }];
//}
//
//- (void)startShaking {
//    if (self.isShaking) {
//        return;
//    }
//    
//    self.isShaking = YES;
//    [self.imgCollection.visibleCells enumerateObjectsUsingBlock:^(__kindof ItemImageCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj startShaking];
//    }];
//}
//
//- (void)endShaking {
//    if (!self.isShaking) {
//        return;
//    }
//    
//    self.isShaking = NO;
//    [self.imgCollection.visibleCells enumerateObjectsUsingBlock:^(__kindof ItemImageCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj endShaking];
//    }];
//}
//
//#pragma mark - gesture & user action
//- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        [self startShaking];
//    }
//}
//
//- (void)handleTapImageGesture:(UITapGestureRecognizer *)gesture {
//    CGPoint point = [gesture locationInView:self.imgCollection];
//    NSIndexPath *indexPath = [self.imgCollection indexPathForItemAtPoint:point];
//    
//    if (!indexPath) {
//        [self endShaking];
//        return;
//    }
//    
//    if (self.isShaking ) {
//        if (indexPath.row < self.item.images.count) {
//            [self deleteImage:indexPath];
//            return;
//        }
//    }
//    
//    if (indexPath.row < self.item.images.count) {
//        [self showImageDetail:indexPath.row];
//    } else {
//        [self showPhotoSelector:[self.imgCollection cellForItemAtIndexPath:indexPath]];
//    }
//}
//
//- (void)showPhotoSelector:(UIView *)view {
//    if (self.isShaking) {
//        [self endShaking];
//        return;
//    }
//    
//    NSString *processid = self.dataManager.process._id;
//    NSString *section = self.dataManager.selectedSection.name;
//    NSString *item = self.item.name;
//    
//    @weakify(self);
//    [PhotoUtil showDecorationNodeImageSelector:[ViewControllerContainer getCurrentTapController] inView:view max:MAX_IMG_COUNT - self.item.images.count withBlock:^(NSArray *imageIds) {
//        @strongify(self);
//        UploadImageToProcess *request = [[UploadImageToProcess alloc] init];
//        request._id = processid;
//        request.section = section;
//        request.item = item;
//        request.images = imageIds;
//        [API uploadImageToProcess:request success:^{
//            if (self.refreshBlock) {
//                self.refreshBlock(YES);
//            }
//        } failure:^{
//            
//        } networkError:^{
//            
//        }];
//
//    }];
//}
//
//- (void)showImageDetail:(NSInteger)index{
//    [ViewControllerContainer showOnlineImages:self.item.images index:index];
//}
//
//- (void)handleTapLeaveIconGesture:(UITapGestureRecognizer *)gesture {
//    [self endShaking];
//    @weakify(self);
//    [ViewControllerContainer leaveMessage:self.dataManager.process section:self.dataManager.selectedSection.name item:self.item.name block:^{
//        @strongify(self);
//        if (self.refreshBlock) {
//            self.refreshBlock(YES);
//        }
//    }];
//}
//
//#pragma mark - touches
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self endShaking];
//    
//    if (event) {
//        [super touchesBegan:touches withEvent:event];
//    }
//}
//
//#pragma mark - other
//- (void)refreshNumberOfItems {
//    self.numberOfItemsInsection = self.item.images.count < MAX_IMG_COUNT ? self.item.images.count + 1 : self.item.images.count;
//}
//
//- (void)refreshViewContentSize {
//    self.imgCollectionLayout.itemSize = CGSizeMake(imgCellWidth, imgCellWidth);
//    self.imgCollection.viewContentSize = CGSizeMake(imgCollectionWidth,  (imgCellWidth + CELL_SPACE) * (self.numberOfItemsInsection % COUNT_IN_ONE_ROW == 0 ? self.numberOfItemsInsection / COUNT_IN_ONE_ROW : (NSInteger)(self.numberOfItemsInsection / COUNT_IN_ONE_ROW) + 1));
//    [self.imgCollection invalidateIntrinsicContentSize];
//}

@end
