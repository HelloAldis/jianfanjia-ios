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

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger columnSpace;
@property (assign, nonatomic) NSInteger rowSpace;
@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) BOOL isShowing;

@property (strong, nonatomic) NSArray *datasoure;
@property (strong, nonatomic) NSString *defaultValue;
@property (copy, nonatomic) DropdownChooseItemBlock chooseItemBlock;

@end

@implementation DropdownMenuView

+ (DropdownMenuView *)show:(UIView *)view datasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(DropdownChooseItemBlock)block {
    CGRect frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    frame = [[UIApplication sharedApplication].keyWindow convertRect:view.bounds fromView:view];
    DropdownMenuView *menu = [[DropdownMenuView alloc] initWithFrame:frame];
    [menu initWithDatasource:datasoure defaultValue:defaultValue block:block];
    [[UIApplication sharedApplication].keyWindow insertSubview:menu aboveSubview:view];
    [menu show];
    
    return menu;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        
        _columnCount = 3;
        _columnSpace = 3;
        _rowSpace = 3;
        _insets = UIEdgeInsetsMake(0, 0, 10, 0);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapParentView:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.cancelsTouchesInView = NO;
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0) collectionViewLayout:self.flowLayout];
        [self.collectionView registerNib:[UINib nibWithNibName:DropdownMenuCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:DropdownMenuCollectionCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)refreshDatasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue {
    _datasoure = datasoure;
    _defaultValue = defaultValue;
    
    [self initUI:YES];
}

- (void)initWithDatasource:(NSArray *)datasoure defaultValue:(NSString *)defaultValue block:(DropdownChooseItemBlock)block {
    _datasoure = datasoure;
    _defaultValue = defaultValue;
    _chooseItemBlock = block;
    
    [self initUI:NO];
}

- (void)initUI:(BOOL)refresh {
    CGFloat cellHeight = 30;
    self.flowLayout.minimumLineSpacing = self.rowSpace;
    self.flowLayout.minimumInteritemSpacing = self.columnSpace;
    CGFloat cellWidth = (kScreenWidth - self.insets.left - self.insets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
    
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.flowLayout.sectionInset = self.insets;
    
    NSInteger rowCount = self.datasoure.count % self.columnCount > 0 ? self.datasoure.count / self.columnCount + 1 : self.datasoure.count / self.columnCount;
    self.height = self.rowSpace * (rowCount - 1) + cellHeight * rowCount + self.insets.top + self.insets.bottom;
    
    if (refresh) {
        self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.height);
    } else {
        self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    }
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:[self.datasoure indexOfObject:self.defaultValue] inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}

- (void)show {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, self.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    } completion:^(BOOL finished) {
        self.isShowing = YES;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.collectionView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        self.isShowing = NO;
        [self removeFromSuperview];
    }];
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
        
        [self dismiss];
    }
}

#pragma mark - user action
- (void)selectItem:(NSString *)value {
    if (self.chooseItemBlock) {
        self.chooseItemBlock(value);
    }
    
    [self dismiss];
}

@end
