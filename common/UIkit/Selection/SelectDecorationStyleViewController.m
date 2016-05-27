//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectDecorationStyleViewController.h"
#import "DecorationStyleCell.h"

#define kMaxSelectionCount 3

static const NSInteger CELL_SPACE = 4;
static const NSInteger SECTION_LEFT = 4;
static const NSInteger COUNT_IN_ROW = 2;
static const NSInteger CELL_WIDTH_ASPECT = 4;
static const NSInteger CELL_HEIGHT_ASPECT = 3;

static NSString* cellId = @"decStyleCell";

@interface SelectDecorationStyleViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSMutableArray *selectedData;

@end

@implementation SelectDecorationStyleViewController

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
    
    self.title = @"风格喜好";
    
    if (self.selectionType == SelectionTypeMultiple) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickOk)];
        self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
        self.title = @"最多可选择三种擅长风格";
    }
}

#pragma mark - UI
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"DecorationStyleCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    CGFloat cellWidth = (kScreenWidth - SECTION_LEFT * 2 - CELL_SPACE * (COUNT_IN_ROW - 1)) / COUNT_IN_ROW;
    CGFloat cellHeight = cellWidth / CELL_WIDTH_ASPECT * CELL_HEIGHT_ASPECT;
    self.collectionFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.collectionFlowLayout.minimumInteritemSpacing = CELL_SPACE;
    self.collectionFlowLayout.minimumLineSpacing = CELL_SPACE;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsMake(10, SECTION_LEFT, 10, SECTION_LEFT);
}

#pragma mark - init data 
- (void)initData {
    self.keys = [[NameDict getAllDecorationStyle] sortedKeyWithOrder:YES];
    self.selectedData = [self.curValues mutableCopy];
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keys[indexPath.row];
    
    DecorationStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString* imageName = [NSString stringWithFormat:@"dec_style_%@", key];
    [cell initWithImage:[UIImage imageNamed:imageName]];
    
    if ([self.selectedData containsObject:key]) {
        [cell setBorder:3 andColor:kThemeColor.CGColor];
    } else if ([self.curValue isEqualToString:key]) {
        [cell setBorder:3 andColor:kThemeColor.CGColor];
    } else {
        [cell setBorder:0 andColor:kThemeColor.CGColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectionType == SelectionTypeMultiple) {
        if (self.selectedData && [self.selectedData containsObject:self.keys[indexPath.row]]) {
            [self.selectedData removeObject:self.keys[indexPath.row]];
        } else if (self.selectedData.count < kMaxSelectionCount) {
            [self.selectedData addObject:self.keys[indexPath.row]];
        }
        
        [self.collectionView reloadData];
    } else {
        self.curValue = self.keys[indexPath.row];
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

@end
