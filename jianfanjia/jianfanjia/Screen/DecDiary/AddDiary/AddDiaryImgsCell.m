//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiaryImgsCell.h"
#import "StaticImageCollectionCell.h"
#import "UIItemImageCollectionView.h"
#import "ViewControllerContainer.h"

static const NSInteger MAX_IMG_COUNT = 9;
static const NSInteger COUNT_IN_ONE_ROW = 4;
static const NSInteger CELL_SPACE = 4;
static const NSInteger CELL_PADDING = 15;

static NSString *StaticImageCollectionCellIdentifier = @"StaticImageCollectionCell";

static CGFloat imgCellWidth;

@interface AddDiaryImgsCell ()
@property (weak, nonatomic) IBOutlet UIItemImageCollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;

@property (copy, nonatomic) StaticImageColCellTapImageBlock tapImageBlock;
@property (copy, nonatomic) StaticImageColCellTapDeleteBlock tapDeleteBlock;

@property (assign, nonatomic) NSInteger numberOfItemsInsection;
@property (strong, nonatomic) Diary *diary;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation AddDiaryImgsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgCollection registerNib:[UINib nibWithNibName:StaticImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:StaticImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    self.imgCollectionLayout.sectionInset = UIEdgeInsetsMake(CELL_PADDING, CELL_PADDING, CELL_PADDING, CELL_PADDING);
    imgCellWidth = (kScreenWidth - 2 * CELL_PADDING - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    
    @weakify(self);
    self.tapImageBlock = ^(StaticImageCollectionCell *cell) {
        @strongify(self);
        [[ViewControllerContainer getCurrentTopController].view endEditing:YES];
        NSIndexPath *indexPath = [self.imgCollection indexPathForCell:cell];
        if (indexPath.row < self.diary.images.count) {
            [self showImageDetail:indexPath];
        } else {
            [self showPhotoSelector:cell];
        }
    };
    
    self.tapDeleteBlock = ^(StaticImageCollectionCell *cell) {
        @strongify(self);
        NSIndexPath *indexPath = [self.imgCollection indexPathForCell:cell];
        [self deleteImage:indexPath];
    };
}

- (void)initWithDiary:(Diary *)diary tableView:(UITableView *)tableView {
    self.diary = diary;
    self.tableView = tableView;
    
    [self refreshNumberOfItems];
    [self refreshViewContentSize];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItemsInsection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StaticImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StaticImageCollectionCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < self.diary.images.count) {
        LeafImage *img = [[LeafImage alloc] initWith:self.diary.images[indexPath.row]];
        [cell initWithImageId:img.imageid];
        cell.lblDeleteText.hidden = NO;
    } else {
        [cell initWithImage:[UIImage imageNamed:@"btn_add_image"]];
        cell.lblDeleteText.hidden = YES;
    }
    
    cell.tapImageBlock = self.tapImageBlock;
    cell.tapDeleteBlock = self.tapDeleteBlock;
    
    return cell;
}

#pragma mark - user action
- (void)deleteImage:(NSIndexPath *)indexPath {
    [self.diary.images removeObjectAtIndex:indexPath.row];
    [self refreshNumberOfItems];
    if (self.numberOfItemsInsection == MAX_IMG_COUNT) {
        [self.imgCollection performBatchUpdates:^{
            [self.imgCollection deleteItemsAtIndexPaths:@[indexPath]];
            [self.imgCollection insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:MAX_IMG_COUNT - 1 inSection:0]]];
        } completion:nil];
    } else {
        [self.imgCollection performBatchUpdates:^{
            [self.imgCollection deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
    [self refreshViewContentSize];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)showPhotoSelector:(UIView *)view {
    @weakify(self);
    [PhotoUtil showDecorationNodeImageSelector:[ViewControllerContainer getCurrentTopController] inView:view max:MAX_IMG_COUNT - self.diary.images.count withBlock:^(NSArray *imageIds, NSArray *imageSizes) {
        @strongify(self);
        if (!self.diary.images) {
            self.diary.images = [NSMutableArray array];
        }
        
        [imageIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGSize size = [imageSizes[idx] CGSizeValue];
            
            LeafImage *img = [[LeafImage alloc] init];
            img.imageid = obj;
            img.width = @(size.width);
            img.height = @(size.height);
            [self.diary.images addObject:img.data];
        }];

        [self refreshNumberOfItems];
        [self refreshViewContentSize];
        [self.imgCollection reloadData];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

- (void)showImageDetail:(NSIndexPath *)indexPath {
    NSArray *imgs = [self.diary.images map:^id(id obj) {
        return obj[@"imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imgs index:indexPath.row];
}

#pragma mark - other
- (void)refreshNumberOfItems {
    self.numberOfItemsInsection = self.diary.images.count < MAX_IMG_COUNT ? self.diary.images.count + 1 : self.diary.images.count;
}

- (void)refreshViewContentSize {
    self.imgCollectionLayout.itemSize = CGSizeMake(imgCellWidth, imgCellWidth);
    self.imgCollection.viewContentSize = CGSizeMake(kScreenWidth,  (imgCellWidth + CELL_SPACE) * (self.numberOfItemsInsection % COUNT_IN_ONE_ROW == 0 ? self.numberOfItemsInsection / COUNT_IN_ONE_ROW : (NSInteger)(self.numberOfItemsInsection / COUNT_IN_ONE_ROW) + 1) + CELL_PADDING * 2);
    [self.imgCollection invalidateIntrinsicContentSize];
}

@end
