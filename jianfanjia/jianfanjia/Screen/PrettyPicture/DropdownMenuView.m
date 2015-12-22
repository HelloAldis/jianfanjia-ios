//
//  DropdownMenuView.m
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DropdownMenuView.h"
#import "DropdownMenuCollectionCell.h"

static NSString *DropdownMenuCollectionCellIdentifier = @"DropdownMenuCollectionCell";

@interface DropdownMenuView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger columnSpace;
@property (assign, nonatomic) NSInteger rowSpace;
@property (assign, nonatomic) UIEdgeInsets insets;

@property (strong, nonatomic) NSArray *datasoure;
@property (strong, nonatomic) NSString *defaultValue;
@property (copy, nonatomic) DropdownChooseItemBlock chooseItemBlock;

@end

@implementation DropdownMenuView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        
        _columnCount = 3;
        _columnSpace = 3;
        _rowSpace = 3;
        _insets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapParentView:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.cancelsTouchesInView = NO;
        
        [self.collectionView registerNib:[UINib nibWithNibName:DropdownMenuCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:DropdownMenuCollectionCellIdentifier];
    }
    
    return self;
}

- (void)initWithDataSource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(DropdownChooseItemBlock)block {
    _datasoure = datasoure;
    _defaultValue = defaultValue;
    _chooseItemBlock = block;
    
    [self initUI];
}

- (void)initUI {
    CGFloat height = 30;
    self.flowLayout.minimumLineSpacing = self.rowSpace;
    self.flowLayout.minimumInteritemSpacing = self.columnSpace;
    CGFloat cellWidth = (kScreenWidth - self.insets.left - self.insets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
    self.flowLayout.itemSize = CGSizeMake(cellWidth, height);
    self.flowLayout.sectionInset = self.insets;
    NSInteger rowCount = self.datasoure.count % self.columnCount > 0 ? self.datasoure.count / self.columnCount + 1 : self.datasoure.count / self.columnCount;
    self.heightConstraint.constant = self.rowSpace * (rowCount - 1) + height * rowCount + self.insets.top + self.insets.bottom;
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.datasoure indexOfObject:self.defaultValue] inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasoure.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DropdownMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DropdownMenuCollectionCellIdentifier forIndexPath:indexPath];
    cell.lblTitle.text = self.datasoure[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectItem:self.datasoure[indexPath.row]];
}

#pragma mark - gesture
- (void)handleTapParentView:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    CGPoint pointForTargetView = [self.collectionView convertPoint:point fromView:gesture.view];
    
    if (!CGRectContainsPoint(self.collectionView.bounds, pointForTargetView)) {
        if (self.chooseItemBlock) {
            self.chooseItemBlock(nil);
        }
    }
}

#pragma mark - user action
- (void)selectItem:(NSString *)value {
    if (self.chooseItemBlock) {
        self.chooseItemBlock(value);
    }
}

@end
