//
//  ImageBrowerViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ImageBrowerViewController.h"
#import "ThumbnailCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageBrowerViewController ()

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong, nonatomic) PHFetchResult<PHAsset *> *result;
@property (strong, nonatomic) NSMutableArray *imageIds;
@property (strong, nonatomic) MBProgressHUD *progressBar;
@property (strong, nonatomic) PHImageManager *imageManager;
@property (strong, nonatomic) PHImageRequestOptions *options;

@property (assign, nonatomic) NSInteger selectingCount;

@end

@implementation ImageBrowerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = YES;
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
        @weakify(self);
        [RACObserve(self, selectingCount) subscribeNext:^(id x) {
            @strongify(self);
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    if (self.allowsMultipleSelection) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(onClickDoneMutil)];
        item.tintColor = kThemeColor;
        self.navigationItem.rightBarButtonItem = item;
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    }
}

- (void)initTitleAndRight {
    if (self.maxCount == NSIntegerMax) {
        self.title = @"请选择";
        return;
    }
    
    self.title = [NSString stringWithFormat:@"还可以选%@张", [@(self.maxCount - self.selectingCount) stringValue]];
    self.navigationItem.rightBarButtonItem.enabled = self.selectingCount > 0;
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.result.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    [cell initWithPHAsset:[self.result objectAtIndex:indexPath.row] hidden:!self.allowsMultipleSelection checked:^void(BOOL currentSelect){
        if (!currentSelect && self.allowsMultipleSelection && self.selectingCount >= self.maxCount) {
            return;
        }
        
        if (currentSelect) {
            self.selectingCount--;
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        } else {
            self.selectingCount++;
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    } detail:^{
        [self onClickDoneSingle:[self.result objectAtIndex:indexPath.row]];
    }];
    return cell;
}

#pragma mark - Done
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDoneSingle:(PHAsset *)asset {
    if (self.allowsEdit) {
        [PhotoCropper showPhotoCropper:self asset:asset cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        } choose:^(UIImage *croppedImage) {
            UploadImage *request = [[UploadImage alloc] init];
            request.image = [croppedImage aspectToScale:kScreenWidth];
            
            NSArray *vcs = self.navigationController.viewControllers;
            [self.navigationController popToViewController:vcs[vcs.count - 3] animated:NO];
            [API uploadImage:request success:^{
                if (self.finishUploadBlock) {
                    self.finishUploadBlock(@[[DataManager shared].lastUploadImageid]);
                }
            } failure:^{
            } networkError:^{
            }];
        }];
    } else {
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(kScreenWidth * kScreenScale, kScreenHeight * kScreenScale)
                                    contentMode:PHImageContentModeAspectFit
                                        options:self.options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOffline:@[result] index:0];
                                          imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                                          [self.navigationController presentViewController:imgDetail animated:YES completion:nil];
                                      });
                                  }];

    }
}

- (void)onClickDoneMutil {
    DDLogDebug(@"onClickDoneMutil");
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
                             [API uploadImage:request success:^{
                                 [self.imageIds addObject:[DataManager shared].lastUploadImageid];
                                 
//                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.progressBar.progress = (CGFloat)(index + 1) / (CGFloat)total ;
                                     if (index < total - 1) {
                                         NSIndexPath *nextIndexPath = self.collectionView.indexPathsForSelectedItems[index + 1];
                                         [self uploadImageForIndex:nextIndexPath];
                                     } else {
                                         self.progressBar.labelText = @"上传完成";
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self.progressBar hide:YES];
                                             if (self.finishUploadBlock) {
                                                 self.finishUploadBlock(self.imageIds);
                                             }
                                             [self.navigationController popViewControllerAnimated:YES];
                                         });
                                     }
//                                 });
                             } failure:^{
//                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if (index == 0) {
                                         self.progressBar.labelText = @"上传失败";
                                     } else {
                                         self.progressBar.labelText = @"上传部分失败";
                                     }
                                     
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         [self.progressBar hide:YES];
                                         if (self.finishUploadBlock) {
                                             self.finishUploadBlock(self.imageIds);
                                         }
                                         [self.navigationController popViewControllerAnimated:YES];
                                     });
//                                 });
                             } networkError:^{
                                 
                             }];
                         }];

    
}

@end
