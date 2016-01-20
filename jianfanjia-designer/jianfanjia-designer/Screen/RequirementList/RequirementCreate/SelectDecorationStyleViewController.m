//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectDecorationStyleViewController.h"
#import "DecorationStyleCell.h"

static const NSInteger CELL_SPACE = 1;
static const NSInteger COUNT_IN_ROW = 2;
static const NSInteger CELL_WIDTH_ASPECT = 4;
static const NSInteger CELL_HEIGHT_ASPECT = 3;

static NSString* cellId = @"decStyleCell";

@interface SelectDecorationStyleViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionFlowLayout;
@property (strong, nonatomic) NSArray *data;

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
}

#pragma mark - UI
- (void)initUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"DecorationStyleCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    CGFloat cellWidth = (kScreenWidth - CELL_SPACE * (COUNT_IN_ROW - 1)) / COUNT_IN_ROW;
    CGFloat cellHeight = cellWidth / CELL_WIDTH_ASPECT * CELL_HEIGHT_ASPECT;
    self.collectionFlowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    self.collectionFlowLayout.minimumInteritemSpacing = CELL_SPACE;
    self.collectionFlowLayout.minimumLineSpacing = CELL_SPACE;
    self.collectionFlowLayout.sectionInset = UIEdgeInsetsZero;
}

#pragma mark - init data 
- (void)initData {
    self.data = [[NameDict getAllDecorationStyle] sortedKeyWithOrder:YES];
    if (self.curValue) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self.data indexOfObject:self.curValue] inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DecorationStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString* imageName = [NSString stringWithFormat:@"dec_style_%@", self.data[indexPath.row]];
    [cell initWithImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ValueBlock) {
        self.ValueBlock(self.data[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
