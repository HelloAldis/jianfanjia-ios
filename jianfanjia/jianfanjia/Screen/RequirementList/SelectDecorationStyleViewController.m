//
//  SelectRoomTypeViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SelectDecorationStyleViewController.h"
#import "DecorationStyleCell.h"

static NSString* cellId = @"cityCell";

@interface SelectDecorationStyleViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) NSArray *values;

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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    self.title = @"风格喜好";
}

#pragma mark - UI
- (void)initUI {
    [self.collectionView registerNib:[UINib nibWithNibName:@"DecorationStyleCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    
    
}

#pragma mark - init data 
- (void)initData {
    self.keys = [NameDict getAllDecorationStyle].allKeys;
    self.values = [NameDict getAllDecorationStyle].allValues;
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.values count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DecorationStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString* imageName = [NSString stringWithFormat:@"%ld%@", (long)[self.keys[indexPath.row] integerValue] + 1, self.values[indexPath.row]];
    
    [cell initWithImage:[UIImage imageNamed:imageName] withTitle:self.values[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 135);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [DataManager shared].requirementPageSelectedDecorationStyle = self.keys[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
