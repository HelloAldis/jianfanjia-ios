//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiaryImgsCell.h"
#import "ItemImageCollectionCell.h"
#import "UIItemImageCollectionView.h"
#import "ViewControllerContainer.h"

static const NSInteger MAX_IMG_COUNT = 9;
static const NSInteger COUNT_IN_ONE_ROW = 3;
static const NSInteger CELL_SPACE = 3;

static NSString *ImageCollectionCellIdentifier = @"ItemImageCollectionCell";

static CGFloat imgCollectionWidth;
static CGFloat imgCellWidth;

@interface AddDiaryImgsCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIItemImageCollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;

@property (assign, nonatomic) NSInteger numberOfItemsInsection;
@property (assign, nonatomic) BOOL isShaking;

@property (strong, nonatomic) Diary *diary;

@end

@implementation AddDiaryImgsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollection.scrollEnabled = NO;
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    [self.imgCollection addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
}

- (void)initWithDiary:(Diary *)diary {
    self.diary = diary;
    
    [self refreshNumberOfItems];
    if (imgCollectionWidth > 0) {
        [self refreshViewContentSize];
    }
    [self.imgCollection reloadData];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItemsInsection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.diary.images.count) {
        NSString *imgURL = self.diary.images[indexPath.row];
        [cell initWithImage:imgURL width:self.imgCollectionLayout.itemSize.width];
    } else {
        [cell initWithImage:nil width:0];
    }
    
    return cell;
}

- (void)startShaking {
    if (self.isShaking) {
        return;
    }
    
    self.isShaking = YES;
    [self.imgCollection.visibleCells enumerateObjectsUsingBlock:^(__kindof ItemImageCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj startShaking];
    }];
}

- (void)endShaking {
    if (!self.isShaking) {
        return;
    }
    
    self.isShaking = NO;
    [self.imgCollection.visibleCells enumerateObjectsUsingBlock:^(__kindof ItemImageCollectionCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj endShaking];
    }];
}

#pragma mark - gesture & user action
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self startShaking];
    }
}

- (void)handleTapImageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.imgCollection];
    NSIndexPath *indexPath = [self.imgCollection indexPathForItemAtPoint:point];
    
    if (!indexPath) {
        [self endShaking];
        return;
    }
    
    if (self.isShaking ) {
        if (indexPath.row < self.diary.images.count) {
//            [self deleteImage:indexPath];
            return;
        }
    }
    
    if (indexPath.row < self.diary.images.count) {
        [self showImageDetail:indexPath.row];
    } else {
        [self showPhotoSelector:[self.imgCollection cellForItemAtIndexPath:indexPath]];
    }
}

- (void)showPhotoSelector:(UIView *)view {
    if (self.isShaking) {
        [self endShaking];
        return;
    }
    
    
    @weakify(self);
    [PhotoUtil showDecorationNodeImageSelector:[ViewControllerContainer getCurrentTapController] inView:view max:MAX_IMG_COUNT - self.diary.images.count withBlock:^(NSArray *imageIds) {
        @strongify(self);
        
        
    }];
}

- (void)showImageDetail:(NSInteger)index{
    [ViewControllerContainer showOnlineImages:self.diary.images index:index];
}


#pragma mark - other
- (void)refreshNumberOfItems {
    self.numberOfItemsInsection = self.diary.images.count < MAX_IMG_COUNT ? self.diary.images.count + 1 : self.diary.images.count;
}

- (void)refreshViewContentSize {
    self.imgCollectionLayout.itemSize = CGSizeMake(imgCellWidth, imgCellWidth);
    self.imgCollection.viewContentSize = CGSizeMake(imgCollectionWidth,  (imgCellWidth + CELL_SPACE) * (self.numberOfItemsInsection % COUNT_IN_ONE_ROW == 0 ? self.numberOfItemsInsection / COUNT_IN_ONE_ROW : (NSInteger)(self.numberOfItemsInsection / COUNT_IN_ONE_ROW) + 1));
    [self.imgCollection invalidateIntrinsicContentSize];
}

@end
