//
//  DropdownMenuView.m
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectionMenuView.h"
#import "SelectionMenuCollectionCell.h"

#define kSelectionMenuViewHeight 320

static NSString *SelectionMenuCollectionCellIdentifier = @"SelectionMenuCollectionCell";

@interface SelectionMenuView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger columnSpace;
@property (assign, nonatomic) NSInteger rowSpace;
@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSArray *datasoure;
@property (strong, nonatomic) NSString *defaultValue;
@property (copy, nonatomic) SelectionMenuChooseItemBlock chooseItemBlock;

@end

@implementation SelectionMenuView

+ (void)show:(UIViewController *)controller datasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(SelectionMenuChooseItemBlock)block {
    SelectionMenuView *menu = [[SelectionMenuView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [menu initWithDataSource:datasoure defaultValue:defaultValue block:block];
    [controller.view.window addSubview:menu];
    [menu show];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        
        _columnCount = 1;
        _columnSpace = 0;
        _rowSpace = 0;
        _insets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapParentView:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.cancelsTouchesInView = NO;
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0) collectionViewLayout:self.flowLayout];
        [self.collectionView registerNib:[UINib nibWithNibName:SelectionMenuCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:SelectionMenuCollectionCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)initWithDataSource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(SelectionMenuChooseItemBlock)block {
    _datasoure = datasoure;
    _defaultValue = defaultValue;
    _chooseItemBlock = block;
    
    [self initUI];
}

- (void)initUI {
    self.flowLayout.minimumLineSpacing = self.rowSpace;
    self.flowLayout.minimumInteritemSpacing = self.columnSpace;
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - self.insets.left - self.insets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
    CGFloat cellHeight = 40;
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.flowLayout.sectionInset = self.insets;

    NSInteger rowCount = self.datasoure.count % self.columnCount > 0 ? self.datasoure.count / self.columnCount + 1 : self.datasoure.count / self.columnCount;
//    self.height = self.rowSpace * (rowCount - 1) + cellHeight * rowCount + self.insets.top + self.insets.bottom;
    self.height = kSelectionMenuViewHeight;
    self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height);
    [self.collectionView reloadData];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)show {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.height, [UIScreen mainScreen].bounds.size.width, self.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasoure.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectionMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SelectionMenuCollectionCellIdentifier forIndexPath:indexPath];
    NSString *value = self.datasoure[indexPath.row];
    cell.text.text = value;
    cell.backgroundColor = [value isEqualToString:self.defaultValue] ? kThemeColor : [UIColor whiteColor];

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
        [self dismiss:nil];
    }
}

#pragma mark - user action
- (void)selectItem:(NSString *)value {
    __weak typeof(self) weakSelf = self;
    [self dismiss:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.chooseItemBlock) {
            strongSelf.chooseItemBlock(value);
        }
    }];
}

@end
