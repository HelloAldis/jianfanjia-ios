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
@property (strong, nonatomic) NSMutableArray *imageIds;
@property (strong, nonatomic) MBProgressHUD *progressBar;
@property (strong, nonatomic) PHImageManager *imageManager;
@property (strong, nonatomic) PHImageRequestOptions *options;

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
    self.imageIds = [NSMutableArray array];
    
    self.imageManager = [PHImageManager defaultManager];
    self.options = [PHImageRequestOptions new];
    self.options.networkAccessAllowed = YES;
    self.options.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = false;
    
    if (self.allowsMultipleSelection) {
        [RACObserve(self, selectCount) subscribeNext:^(NSNumber *newValue) {
            [self initTitleAndRight];
        }];
    }
    
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
    if (self.allowsMultipleSelection) {
        //Do nothing
        self.selectCount++;
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
    [self uploadImageForIndex:self.collectionView.indexPathsForSelectedItems[0]];
}

- (void)uploadImageForIndex:(NSIndexPath *)indexPath {
    if ([self.collectionView.indexPathsForSelectedItems indexOfObject:indexPath] == 0) {
        self.progressBar = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.progressBar.mode = MBProgressHUDModeAnnularDeterminate;
        self.progressBar.labelText = @"上传中";
    }
    @weakify(self);
    [self.imageManager requestImageForAsset:self.result[indexPath.row] targetSize:CGSizeMake(kScreenWidth * kScreenScale, kScreenHeight * kScreenScale)
                           contentMode:PHImageContentModeAspectFit
                               options:self.options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             @strongify(self);
                             NSInteger index = [self.collectionView.indexPathsForSelectedItems indexOfObject:indexPath];
                             NSInteger total = self.collectionView.indexPathsForSelectedItems.count;
                             
                             UploadImage *request = [[UploadImage alloc] init];
                             request.image = result;
                             @weakify(self);
                             [API uploadImage:request success:^{
                                 @strongify(self);
                                 [self.imageIds addObject:[DataManager shared].lastUploadImageid];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.progressBar.progress = (index + 1) / total;
                                     if (index < total - 1) {
                                         NSIndexPath *nextIndexPath = self.collectionView.indexPathsForSelectedItems[index + 1];
                                         [self uploadImageForIndex:nextIndexPath];
                                     } else {
                                         self.progressBar.labelText = @"上传完成";
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self.progressBar hide:YES];
                                             [self.navigationController popViewControllerAnimated:YES];
                                             if (self.finishUploadBlock) {
                                                 self.finishUploadBlock(self.imageIds);
                                             }
                                         });
                                     }
                                 });
                             } failure:^{
                                 @strongify(self);
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if (index == 0) {
                                         self.progressBar.labelText = @"上传失败";
                                     } else {
                                         self.progressBar.labelText = @"上传部分失败";
                                     }
                                     
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self.progressBar hide:YES];
                                         [self.navigationController popViewControllerAnimated:YES];
                                         if (self.finishUploadBlock) {
                                             self.finishUploadBlock(self.imageIds);
                                         }
                                     });
                                 });
                             }];
                         }];

    
}

@end
