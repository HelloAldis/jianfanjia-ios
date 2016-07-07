//
//  ImageBrowerViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AlbumBrowerViewController.h"
#import "ThumbnailCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumBrowerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PHImageManager *imageManager;
@property (strong, nonatomic) PHImageRequestOptions *options;
@property (strong, nonatomic) NSMutableArray<NSString *> *titles;
@property (strong, nonatomic) NSMutableArray<PHFetchResult<PHAsset *> *> *collections;

@end

@implementation AlbumBrowerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = YES;
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"照片";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(onClickCancel)];
    item.tintColor = kThemeColor;
    self.navigationItem.rightBarButtonItem = item;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.imageManager = [PHImageManager defaultManager];
    self.options = [PHImageRequestOptions new];
    self.options.networkAccessAllowed = YES;
    self.options.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = false;
}

- (void)initData {
    @weakify(self);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        @strongify(self);
        if (PHAuthorizationStatusAuthorized == status) {
            self.titles = [NSMutableArray array];
            self.collections = [NSMutableArray array];
            PHFetchResult<PHAssetCollection *> *result = nil;
            
            // 智能相册
            PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
            result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:userAlbumsOptions];
            
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAssetCollection *assetCollection = obj;
                PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                if (assetsFetchResult.count > 0) {
                    [self.titles addObject:[NSString stringWithFormat:@"%@ (%@)", assetCollection.localizedTitle, @([assetsFetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage])]];
                    [self.collections addObject:assetsFetchResult];
                }
            }];
            
            // 用户自定义相册
            userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
            result  = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:userAlbumsOptions];
            
            [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAssetCollection *assetCollection = obj;
                PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                if (assetsFetchResult.count > 0) {
                    [self.titles addObject:[NSString stringWithFormat:@"%@ (%@)", assetCollection.localizedTitle, @([assetsFetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage])]];
                    [self.collections addObject:assetsFetchResult];
                }
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    cell.imageView.frame = CGRectMake(0, 0, 100, 100);
    [self setImage:cell indexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didChooseAlbumBlock) {
        self.didChooseAlbumBlock(self.titles[indexPath.row], self.collections[indexPath.row]);
    }
}

#pragma mark - user actions
- (void)onClickCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - other
- (void)setImage:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.collections[indexPath.row].firstObject;
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = NO;
    
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100)
                           contentMode:PHImageContentModeAspectFill
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 cell.imageView.image = result;
                                 [cell setNeedsLayout];
                             });
                         }];
}

@end
