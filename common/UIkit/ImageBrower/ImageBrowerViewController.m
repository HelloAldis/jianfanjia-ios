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
@property (weak, nonatomic) IBOutlet UILabel *lblText;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConst;

@property (strong, nonatomic) NSMutableArray<NSIndexPath *> *selectedPaths;
@property (strong, nonatomic) NSMutableArray *imageIds;
@property (strong, nonatomic) NSMutableArray *imageSizes;
@property (strong, nonatomic) MBProgressHUD *progressBar;
@property (strong, nonatomic) PHImageManager *imageManager;
@property (strong, nonatomic) PHImageRequestOptions *options;

@property (assign, nonatomic) NSInteger selectingCount;

@end

@implementation ImageBrowerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.krs_EnableFakeNavigationBar = YES;
    
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - UI
- (void)initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    item.tintColor = kThemeColor;
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //Init collection
    self.maxCount = self.maxCount <= 0 ? 1 : self.maxCount;
    CGFloat width = (kScreenWidth - ((self.cellCountInOneRow - 1) * self.cellSpace)) / self.cellCountInOneRow;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ThumbnailCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbnailCell"];
    self.collectionViewLayout.itemSize = CGSizeMake(width, width);
    self.collectionViewLayout.minimumLineSpacing = self.cellSpace;
    self.collectionViewLayout.minimumInteritemSpacing = self.cellSpace;
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    self.imageIds = [NSMutableArray array];
    self.imageSizes = [NSMutableArray array];
    self.selectedPaths = [NSMutableArray array];
    
    self.imageManager = [PHImageManager defaultManager];
    self.options = [PHImageRequestOptions new];
    self.options.networkAccessAllowed = YES;
    self.options.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = false;
    
    @weakify(self);
    if (self.allowsMultipleSelection) {
        [RACObserve(self, selectingCount) subscribeNext:^(id x) {
            @strongify(self);
            [self initTextAndButton];
        }];
    } else {
        self.bottomViewConst.constant = 0;
        self.bottomView.hidden = YES;
    }
}

- (void)initData {
    if (!self.result) {
        @weakify(self);
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            @strongify(self);
            if (PHAuthorizationStatusAuthorized == status) {
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                self.result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.title = [NSString stringWithFormat:@"相机胶卷 (%@)", @(self.result.count)];
                    [self.collectionView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismiss];
                });
            }
        }];
    } else {
        self.title = self.vcTitle;
    }
}

- (void)initTextAndButton {
    if (self.maxCount == NSIntegerMax) {
        self.lblText.text = @"请选择";
    } else {
        self.lblText.text = [NSString stringWithFormat:@"还可以选%@张", [@(self.maxCount - self.selectingCount) stringValue]];
    }
    
    self.btnDone.enabled = self.selectingCount > 0;
}

#pragma mark - collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.result.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ThumbnailCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    [cell initWithPHAsset:[self.result objectAtIndex:indexPath.row] hidden:!self.allowsMultipleSelection checked:^void(BOOL currentSelect){
        if (!currentSelect && self.allowsMultipleSelection && self.selectingCount >= self.maxCount) {
            return;
        }
        
        if (currentSelect) {
            self.selectingCount--;
            [self.selectedPaths removeObject:indexPath];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        } else {
            self.selectingCount++;
            [self.selectedPaths addObject:indexPath];
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    } detail:^{
        [self onClickDoneSingle:[self.result objectAtIndex:indexPath.row] imageView:cell.imageView];
    }];
    return cell;
}

#pragma mark - Done
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDoneSingle:(PHAsset *)asset imageView:(UIImageView *)imageView {
    if (self.allowsEdit && !self.allowsMultipleSelection) {
        [PhotoCropper showPhotoCropper:self asset:asset style:self.style cancel:^{
//            [self.navigationController popViewControllerAnimated:YES];
        } choose:^(UIImage *croppedImage) {
            UploadImage *request = [[UploadImage alloc] init];
            request.image = [croppedImage aspectToScale:kScreenWidth];
            [self dismiss];
            [API uploadImage:request success:^{
                if (self.finishUploadBlock) {
                    self.finishUploadBlock(@[[DataManager shared].lastUploadImageid], @[[NSValue valueWithCGSize:request.image.size]]);
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
                                          PhotoGroupItem *item = [PhotoGroupItem new];
                                          item.itemType = PhotoGroupItemTypeOffline;
                                          item.thumbImage = result;
                                          
                                          PhotoGroupAnimationView *v = [[PhotoGroupAnimationView alloc] init];
                                          v.groupItems = @[item];
                                          [v presentFromImageView:imageView fromItemIndex:0 toContainer:self.navigationController.view animated:YES completion:nil];
                                      });
                                  }];

    }
}

- (IBAction)onClickDone:(id)sender {
    [self onClickDoneMutil];
}

- (void)onClickDoneMutil {
    DDLogDebug(@"onClickDoneMutil");
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self uploadImageForIndex:self.selectedPaths[0]];
}

- (void)uploadImageForIndex:(NSIndexPath *)indexPath {
    if ([self.selectedPaths indexOfObject:indexPath] == 0) {
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
                             NSInteger index = [self.selectedPaths indexOfObject:indexPath];
                             NSInteger total = self.selectedPaths.count;
                             
                             UploadImage *request = [[UploadImage alloc] init];
                             request.image = result;
                             [API uploadImage:request success:^{
                                 [self.imageIds addObject:[DataManager shared].lastUploadImageid];
                                 [self.imageSizes addObject:[NSValue valueWithCGSize:request.image.size]];
                                 
//                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     self.progressBar.progress = (CGFloat)(index + 1) / (CGFloat)total ;
                                     if (index < total - 1) {
                                         NSIndexPath *nextIndexPath = self.selectedPaths[index + 1];
                                         [self uploadImageForIndex:nextIndexPath];
                                     } else {
                                         self.progressBar.labelText = @"上传完成";
                                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                             [self.progressBar hide:YES];
                                             if (self.finishUploadBlock) {
                                                 self.finishUploadBlock(self.imageIds, self.imageSizes);
                                             }
                                             [self dismiss];
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
                                             self.finishUploadBlock(self.imageIds, self.imageSizes);
                                         }
                                         [self dismiss];
                                     });
//                                 });
                             } networkError:^{
                                 
                             }];
                         }];

    
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
