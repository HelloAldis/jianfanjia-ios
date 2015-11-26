//
//  ImageBrowerViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ImageBrowerViewController.h"
#import "ThumbnailCell.h"
#import "ImageEditorViewController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageBrowerViewController ()

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong, nonatomic) PHFetchResult<PHAsset *> *result;
@property(assign, nonatomic) int selectCount;

@end

@implementation ImageBrowerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initNav];
    
    //Init collection
    self.maxCount = self.maxCount <= 0 ? 1 : self.maxCount;
    CGFloat width = (kScreenWidth - ((self.cellCountInOneRow - 1) * self.cellSpace)) / self.cellCountInOneRow;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ThumbnailCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbnailCell"];
    self.collectionViewLayout.itemSize = CGSizeMake(width, width);
    self.collectionViewLayout.minimumLineSpacing = self.cellSpace;
    self.collectionViewLayout.minimumInteritemSpacing = self.cellSpace;
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    
    [RACObserve(self, selectCount) subscribeNext:^(NSNumber *newValue) {
        [self initTitleAndRight];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    @weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        @strongify(self);
        if (PHAuthorizationStatusAuthorized == status) {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            self.result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self.collectionView reloadData];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    if (self.allowsMultipleSelection) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onClickDoneMutil)];
        item.tintColor = kThemeColor;
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)initTitleAndRight {
    self.title = [NSString stringWithFormat:@"还可以选%d张", self.maxCount - self.selectCount];
    self.navigationItem.rightBarButtonItem.enabled = self.selectCount > 0;
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.result.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    [cell initWithPHAsset:[self.result objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.allowsMultipleSelection && self.selectCount >= self.maxCount) {
        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectCount++;
    if (self.allowsMultipleSelection) {
        //Do nothing
    } else {
        [self onClickDoneSingle:[self.result objectAtIndex:indexPath.row]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectCount--;
}

#pragma mark - Done
- (void)onClickDoneSingle:(PHAsset *)asset {
    ImageEditorViewController *v = [[ImageEditorViewController alloc] initWithNibName:nil bundle:nil];
    v.asset = asset;
    [self.navigationController pushViewController:v animated:YES];
}

- (void)onClickDoneMutil {
    DDLogDebug(@"onClickDoneMutil");
}

#pragma mark - Util
+ (void)imageBrowerForUserImage:(UINavigationController *)nav {
    ImageBrowerViewController *v = [[ImageBrowerViewController alloc] initWithNibName:nil bundle:nil];
    v.cellCountInOneRow = 4;
    v.cellSpace = 1;
    v.allowsMultipleSelection = NO;
    v.maxCount = 1;
    
    [nav pushViewController:v animated:YES];
}

@end
