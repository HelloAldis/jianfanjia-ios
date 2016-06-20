//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectDecorationPhaseViewController.h"
#import "DecorationPhaseCell.h"

#define kMaxSelectionCount 3

static const NSInteger CELL_WIDTH_ASPECT = 4;
static const NSInteger CELL_HEIGHT_ASPECT = 6;

static NSString* cellId = @"DecorationPhaseCell";

@interface SelectDecorationPhaseViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSArray *keys1;
@property (strong, nonatomic) NSArray *keys2;
@property (strong, nonatomic) NSArray *keys3;
@property (strong, nonatomic) NSArray *keys4;
@property (strong, nonatomic) NSMutableArray *selectedData;

@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat cellSpace;

@end

@implementation SelectDecorationPhaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - init Nav
- (void)initNav {
    [self initLeftBackInNav];
    
    self.title = @"装修阶段选择";
}

#pragma mark - UI
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    self.cellWidth = 70;
    self.cellSpace = (kScreenWidth - 4 * self.cellWidth) / (4 + 1);
    CGFloat cellHeight = self.cellWidth / CELL_WIDTH_ASPECT * CELL_HEIGHT_ASPECT;
    self.collectionFlowLayout.itemSize = CGSizeMake(self.cellWidth, cellHeight);
    self.collectionFlowLayout.minimumInteritemSpacing = self.cellSpace;
    self.collectionFlowLayout.minimumLineSpacing = self.cellSpace;
}

#pragma mark - init data 
- (void)initData {
    self.keys = [NameDict getAllDecorationPhase];
    self.selectedData = [self.curValues mutableCopy];
    self.keys1 = @[self.keys[0], self.keys[1], self.keys[2], self.keys[3]];
    self.keys2 = @[self.keys[4], self.keys[5], self.keys[6]];
    self.keys3 = @[self.keys[7], self.keys[8]];
    self.keys4 = @[self.keys[9]];
}

#pragma mark - collection view delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return [self sectionInsert:self.keys1];
    } else if (section == 1) {
        return [self sectionInsert:self.keys2];
    } else if (section == 2) {
        return [self sectionInsert:self.keys3];
    } else if (section == 3) {
        return [self sectionInsert:self.keys4];
    }
    
    return UIEdgeInsetsZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.keys1.count;
    } else if (section == 1) {
        return self.keys2.count;
    } else if (section == 2) {
        return self.keys3.count;
    } else if (section == 3) {
        return self.keys4.count;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DecorationPhaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *key;
    
    if (indexPath.section == 0) {
        key = self.keys1[indexPath.row];
    } else if (indexPath.section == 1) {
        key = self.keys2[indexPath.row];
    } else if (indexPath.section == 2) {
        key = self.keys3[indexPath.row];
    } else if (indexPath.section == 3) {
        key = self.keys4[indexPath.row];
    }
    
    if ([self.selectedData containsObject:key]) {
        NSString* imageName = [NSString stringWithFormat:@"%@_2", key];
        [cell initWithImage:[UIImage imageNamed:imageName] title:key];
    } else if ([self.curValue isEqualToString:key]) {
        NSString* imageName = [NSString stringWithFormat:@"%@_2", key];
        [cell initWithImage:[UIImage imageNamed:imageName] title:key];
    } else {
        NSString* imageName = [NSString stringWithFormat:@"%@_0", key];
        [cell initWithImage:[UIImage imageNamed:imageName] title:key];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key;
    
    if (indexPath.section == 0) {
        key = self.keys1[indexPath.row];
    } else if (indexPath.section == 1) {
        key = self.keys2[indexPath.row];
    } else if (indexPath.section == 2) {
        key = self.keys3[indexPath.row];
    } else if (indexPath.section == 3) {
        key = self.keys4[indexPath.row];
    }
    
    if (self.selectionType == SelectionTypeMultiple) {
        if (self.selectedData && [self.selectedData containsObject:key]) {
            [self.selectedData removeObject:key];
        } else if (self.selectedData.count < kMaxSelectionCount) {
            [self.selectedData addObject:key];
        }
        
        [self.collectionView reloadData];
    } else {
        self.curValue = key;
        [self onClickOk];
    }
}
                                                                                                                                                       
- (void)onClickOk {
    if (self.selectionType == SelectionTypeMultiple) {
        if (self.ValueBlock) {
            self.ValueBlock(self.selectedData);
        }
    } else {
        if (self.ValueBlock) {
            self.ValueBlock(self.curValue);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - section inset
- (UIEdgeInsets)sectionInsert:(NSArray *)array {
    CGFloat padding = kScreenWidth - array.count * (self.cellWidth + self.cellSpace) + self.cellSpace;
    
    return UIEdgeInsetsMake(20, padding / 2.0, 0, padding / 2.0);
}

@end
