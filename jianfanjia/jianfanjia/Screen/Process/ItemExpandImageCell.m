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
#import "ImageDetailViewController.h"

static const NSInteger MAX_IMG_COUNT = 9;
static const NSInteger COUNT_IN_ONE_ROW = 3;
static const NSInteger CELL_SPACE = 3;

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
@property (weak, nonatomic) IBOutlet UIView *leaveMsgView;
@property (weak, nonatomic) IBOutlet UIItemImageCollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;

@property (weak, nonatomic) ProcessDataManager *dataManager;
@property (weak, nonatomic) Item *item;
@property (copy, nonatomic) void(^refreshBlock)(void);

@property (assign, nonatomic) NSInteger numberOfItemsInsection;
@property (assign, nonatomic) BOOL isShaking;

@end

@implementation ItemExpandImageCell

#pragma mark - life cycle
- (void)awakeFromNib {
    DDLogDebug(@"ItemExpandImageCell %@", self);
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollection.scrollEnabled = NO;
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    [self.imgCollection addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)]];
    [self.leaveMsgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLeaveIconGesture:)]];
    
//    [self.imgCollection setBorder:1 andColor:[UIColor redColor].CGColor];
}

#pragma mark - UI
- (void)initWithItem:(Item *)item withDataManager:(ProcessDataManager *)dataManager withBlock:(void(^)(void))refreshBlock {
    self.refreshBlock = refreshBlock;
    self.dataManager = dataManager;
    self.item = item;
    self.lblItemTitle.text = [ProcessBusiness nameForKey:item.name];
    self.lblLastUpdateTime.text = self.item.date.longLongValue > 0 ? [NSDate yyyy_MM_dd_HH_mm:self.item.date] : @"";
    self.lblItemStatus.text = [NameDict nameForSectionStatus:self.item.status];
    
    if (self.item.comment_count.intValue > 0) {
        self.lblLeaveMessageTitle.text = self.item.comment_count.stringValue;
        self.imgViewLeaveMessageIcon.image = [UIImage imageNamed:@"btn_leave_msg_pressed"];
    } else {
        self.lblLeaveMessageTitle.text = @"评价";
        self.imgViewLeaveMessageIcon.image = [UIImage imageNamed:@"btn_leave_msg_normal"];
    }
    
    if ([self.item.status isEqualToString:kSectionStatusOnGoing]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_1"];
        self.statusLine2.backgroundColor = kFinishedColor;
        self.lblItemStatus.textColor = kExcutionStatusColor;
    } else if([self.item.status isEqualToString:kSectionStatusAlreadyFinished]) {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_2"];
        self.statusLine2.backgroundColor = kFinishedColor;
        self.lblItemStatus.textColor = kFinishedColor;
    } else {
        self.statusImageView.image = [UIImage imageNamed:@"item_status_0"];
        self.statusLine2.backgroundColor = kUntriggeredColor;
        self.lblItemStatus.textColor = kUntriggeredColor;
    }
    
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

    if (indexPath.row < self.item.images.count) {
        NSString *imgURL = self.item.images[indexPath.row];
        [cell initWithImage:imgURL width:self.imgCollectionLayout.itemSize.width];
    } else {
        [cell initWithImage:nil width:0];
    }

    return cell;
}

#pragma mark - user action
- (void)deleteImage:(NSIndexPath *)indexPath {
    [self.item.images removeObjectAtIndex:indexPath.row];
    [self refreshNumberOfItems];
    if (self.numberOfItemsInsection == MAX_IMG_COUNT) {
        [self.imgCollection performBatchUpdates:^{
            [self.imgCollection deleteItemsAtIndexPaths:@[indexPath]];
            [self.imgCollection insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:MAX_IMG_COUNT - 1 inSection:0]]];
        } completion:nil];
    } else {
        [self.imgCollection deleteItemsAtIndexPaths:@[indexPath]];
    }
    [self refreshViewContentSize];
    
    DeleteImageFromProcess *request = [[DeleteImageFromProcess alloc] init];
    request._id = self.dataManager.process._id;
    request.section = self.dataManager.selectedSection.name;
    request.item = self.item.name;
    request.index = @(indexPath.row);
    
    [API deleteImageFromeProcess:request success:^{
    } failure:^{
        
    } networkError:^{
        
    }];
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
        if (indexPath.row < self.item.images.count) {
            [self deleteImage:indexPath];
            return;
        }
    }
    
    if (indexPath.row < self.item.images.count) {
        [self showImageDetail:indexPath.row];
    } else {
        [self showPhotoSelector];
    }
}

- (void)showPhotoSelector {
    if (self.isShaking) {
        [self endShaking];
        return;
    }
    
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
            
        } networkError:^{
            
        }];

    }];
}

- (void)showImageDetail:(NSInteger)index{
    ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOnline:self.item.images index:index];
    imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[ViewControllerContainer getCurrentTapController] presentViewController:imgDetail animated:YES completion:nil];
}

- (void)handleTapLeaveIconGesture:(UITapGestureRecognizer *)gesture {
    [self endShaking];
    @weakify(self);
    [ViewControllerContainer leaveMessage:self.dataManager.process._id section:self.dataManager.selectedSection.name item:self.item.name block:^{
        @strongify(self);
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    }];
}

#pragma mark - layout
- (void)layoutSubviews {
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        [self.imgCollection setNeedsLayout];
        [self.imgCollection layoutIfNeeded];
        imgCollectionWidth = self.imgCollection.frame.size.width;
        imgCellWidth = (imgCollectionWidth - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
        DDLogDebug(@"bounds %f %f", imgCollectionWidth, imgCellWidth);
        [self refreshViewContentSize];
    });
    
    [super layoutSubviews];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endShaking];
    
    if (event) {
        [super touchesBegan:touches withEvent:event];
    }
}

#pragma mark - other
- (void)refreshNumberOfItems {
    self.numberOfItemsInsection = self.item.images.count < MAX_IMG_COUNT ? self.item.images.count + 1 : self.item.images.count;
}

- (void)refreshViewContentSize {
    self.imgCollectionLayout.itemSize = CGSizeMake(imgCellWidth, imgCellWidth);
    self.imgCollection.viewContentSize = CGSizeMake(imgCollectionWidth,  (imgCellWidth + CELL_SPACE) * (self.numberOfItemsInsection % COUNT_IN_ONE_ROW == 0 ? self.numberOfItemsInsection / COUNT_IN_ONE_ROW : (NSInteger)(self.numberOfItemsInsection / COUNT_IN_ONE_ROW) + 1));
    [self.imgCollection invalidateIntrinsicContentSize];
}

@end
