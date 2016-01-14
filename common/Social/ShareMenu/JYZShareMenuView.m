//
//  DropdownMenuView.m
//  jianfanjia
//
//  Created by Karos on 15/12/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "JYZShareMenuView.h"
#import "JYZShareMenuCollectionCell.h"
#import "JYZSocialSnsConstant.h"

static NSString *JYZShareMenuCollectionCellIdentifier = @"JYZShareMenuCollectionCell";

@interface JYZShareMenuView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) NSInteger columnCount;
@property (assign, nonatomic) NSInteger columnSpace;
@property (assign, nonatomic) NSInteger rowSpace;
@property (assign, nonatomic) UIEdgeInsets insets;
@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSArray *datasoure;
@property (copy, nonatomic) JYZShareMenuChooseItemBlock chooseItemBlock;

@end

@implementation JYZShareMenuView

+ (void)show:(UIViewController *)controller datasource:(NSArray *)datasoure block:(JYZShareMenuChooseItemBlock)block {
    JYZShareMenuView *menu = [[JYZShareMenuView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [menu initWithDataSource:datasoure block:block];
    [controller.view.window addSubview:menu];
    [menu show];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        
        _columnCount = 3;
        _columnSpace = 0;
        _rowSpace = 0;
        _insets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapParentView:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.cancelsTouchesInView = NO;
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0) collectionViewLayout:self.flowLayout];
        [self.collectionView registerNib:[UINib nibWithNibName:JYZShareMenuCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:JYZShareMenuCollectionCellIdentifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)initWithDataSource:(NSArray *)datasoure block:(JYZShareMenuChooseItemBlock)block {
    _datasoure = datasoure;
    _chooseItemBlock = block;
    
    [self initUI];
}

- (void)initUI {
    CGFloat cellHeight = 100;
    self.flowLayout.minimumLineSpacing = self.rowSpace;
    self.flowLayout.minimumInteritemSpacing = self.columnSpace;
    CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - self.insets.left - self.insets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
    self.flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.flowLayout.sectionInset = self.insets;

    NSInteger rowCount = self.datasoure.count % self.columnCount > 0 ? self.datasoure.count / self.columnCount + 1 : self.datasoure.count / self.columnCount;
    self.height = self.rowSpace * (rowCount - 1) + cellHeight * rowCount + self.insets.top + self.insets.bottom;
    self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height);
    [self.collectionView reloadData];
}

- (void)show {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.height, [UIScreen mainScreen].bounds.size.width, self.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasoure.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYZShareMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JYZShareMenuCollectionCellIdentifier forIndexPath:indexPath];
    NSString *snsPlatform = self.datasoure[indexPath.row];
    if ([snsPlatform isEqualToString:JYZShareToWechatSession]) {
        cell.icon.image = [UIImage imageNamed:@"JYZ_wechat_session_icon"];
        cell.text.text = @"微信好友";
    } else if ([snsPlatform isEqualToString:JYZShareToWechatTimeline]) {
        cell.icon.image = [UIImage imageNamed:@"JYZ_wechat_timeline_icon"];
        cell.text.text = @"微信朋友圈";
    } else if ([snsPlatform isEqualToString:JYZShareToQQ]) {
        cell.icon.image = [UIImage imageNamed:@"JYZ_qq_icon"];
        cell.text.text = @"QQ";
    } else if ([snsPlatform isEqualToString:JYZShareToQzone]) {
        cell.icon.image = [UIImage imageNamed:@"JYZ_qzone_icon"];
        cell.text.text = @"QQ空间";
    } else if ([snsPlatform isEqualToString:JYZShareToWeibo]) {
        cell.icon.image = [UIImage imageNamed:@"JYZ_sina_icon"];
        cell.text.text = @"新浪微博";
    }
    
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
        [self dismiss];
    }
}

#pragma mark - user action
- (void)selectItem:(NSString *)value {
    if (self.chooseItemBlock) {
        self.chooseItemBlock(value);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

@end
