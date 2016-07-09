//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetLeftMenuViewController.h"
#import "DiarySetLeftMenuCell.h"

static const NSInteger CELL_SPACE = 0;
static const NSInteger SECTION_LEFT = 10;
static const NSInteger COUNT_IN_ROW = 1;

static NSString* cellId = @"DiarySetLeftMenuCell";

@interface DiarySetLeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (strong, nonatomic) NSArray *keys;

@end

@implementation DiarySetLeftMenuViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.frame;
    frame.size.width = self.width;
    self.view.frame = frame;
}

#pragma mark - UI
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    CGFloat cellWidth = (self.width - SECTION_LEFT * 2 - CELL_SPACE * (COUNT_IN_ROW - 1)) / COUNT_IN_ROW;
    CGFloat cellHeight = kScreenHeight / (self.keys.count + 1);
    self.collectionFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.collectionFlowLayout.minimumInteritemSpacing = CELL_SPACE;
    self.collectionFlowLayout.minimumLineSpacing = CELL_SPACE;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(cellHeight - 6, 0, 0, 0);
}

#pragma mark - init data 
- (void)initData {
    self.keys = [[[NameDict getAllDecorationPhase] reverseObjectEnumerator] allObjects];
    if (!self.values) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:@0];
        }];
        self.values = arr;
    }
    
    if (!self.curKey) {
        [self.values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] > 0) {
                self.curKey = self.keys[idx];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keys[indexPath.row];
    NSNumber *value = self.values[indexPath.row];
    NSString *valueStr = value.integerValue > 0 ? [NSString stringWithFormat:@"（%@）", [value humCountString]] : @"";
    
    DiarySetLeftMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.lblPhase.text = [NSString stringWithFormat:@"%@阶段%@", key, valueStr];
    cell.lblPhase.textColor = value.integerValue > 0 ? kThemeTextColor : kUntriggeredColor;
    cell.lblPhase.textColor = [self.curKey isEqualToString:key] ? kThemeColor : cell.lblPhase.textColor;
    cell.circleImgView.tintColor = value.integerValue > 0 ? kThemeTextColor : kUntriggeredColor;
    cell.lineImgView.hidden = indexPath.row == self.keys.count - 1;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keys[indexPath.row];
    NSNumber *value = self.values[indexPath.row];
    
    if (value.integerValue > 0) {
        self.curKey = key;
        if (self.didChoose) {
            self.didChoose(key);
        }
    }
}

@end
