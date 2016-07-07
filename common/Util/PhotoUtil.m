//
//  PhotoUtil.m
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PhotoUtil.h"

@implementation PhotoUtil

+ (void)showUserAvatarSelector:(nonnull UIViewController *)controller inView:(UIView *)sourceView withBlock:(FinishUploadBlock)block {
    [self showPhotoSelector:controller inView:sourceView allowsEditing:YES isMultiSelection:NO withMaxSelection:1 withBlock:block];
}

+ (void)showDecorationNodeImageSelector:(nonnull UIViewController *)controller inView:(UIView *)sourceView max:(NSInteger)count withBlock:(FinishUploadBlock)block {
    [self showPhotoSelector:controller inView:sourceView allowsEditing:NO isMultiSelection:YES withMaxSelection:count withBlock:block];
}

+ (void)showUploadProductImageSelector:(nonnull UIViewController *)controller inView:(UIView *)sourceView max:(NSInteger)count withBlock:(FinishUploadBlock)block {
    [self showImageBrowser:controller allowsEditing:NO isMultiSelection:YES withMaxSelection:count withBlock:block];
}

+ (void)showAwardImageSelector:(nonnull UIViewController *)controller inView:(UIView *)sourceView max:(NSInteger)count withBlock:(FinishUploadBlock)block {
    [self showPhotoSelector:controller inView:sourceView allowsEditing:YES isMultiSelection:YES withMaxSelection:count withBlock:block];
}

+ (void)showPhotoSelector:(nonnull UIViewController *)controller inView:(UIView *)sourceView allowsEditing:(BOOL)allowsEditing isMultiSelection:(BOOL)allowsMultiSection withMaxSelection:(NSInteger)maxCount withBlock:(FinishUploadBlock)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片上传" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [imagePickerController useBlocksForDelegate];
            [imagePickerController onDidFinishPickingMediaWithInfo:^(UIImagePickerController *picker, NSDictionary *info) {
                UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
                
                if (allowsEditing) {
                    [PhotoCropper showPhotoCropper:controller image:originalImage cancel:^{
                        [controller.navigationController popViewControllerAnimated:YES];
                    } choose:^(UIImage *croppedImage) {
                        UploadImage *request = [[UploadImage alloc] init];
                        request.image = [croppedImage aspectToScale:kScreenWidth];

                        [controller.navigationController popViewControllerAnimated:YES];
                        [API uploadImage:request success:^{
                            if (block) {
                                block(@[[DataManager shared].lastUploadImageid], @[[NSValue valueWithCGSize:request.image.size]]);
                            }
                        } failure:^{
                        } networkError:^{
                        }];
                    }];
                    
                } else {
                    UploadImage *request = [[UploadImage alloc] init];
                    request.image = [originalImage aspectToScale:kScreenWidth];
                    [API uploadImage:request success:^{
                        if (block) {
                            block(@[[DataManager shared].lastUploadImageid], @[[NSValue valueWithCGSize:request.image.size]]);
                        }
                    } failure:^{
                        
                    } networkError:^{
                        
                    }];
                }
                
                [controller dismissViewControllerAnimated:YES completion:^{
                    // Save the new image (original or edited) to the Camera Roll
                    UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil , nil);
                }];
            }];
            
            [controller presentViewController:imagePickerController animated:YES completion:NULL];
        }
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImageBrowser:controller allowsEditing:allowsEditing isMultiSelection:allowsMultiSection withMaxSelection:maxCount withBlock:block];
    }];
    
    [alert addAction:cancel];
    [alert addAction:camera];
    [alert addAction:photo];
    
    if(kIsPad) {
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = sourceView;
        popPresenter.sourceRect = sourceView.bounds;
        [controller presentViewController:alert animated:YES completion:nil];
    } else {
        [controller presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)showImageBrowser:(UIViewController *)controller allowsEditing:(BOOL)allowsEditing isMultiSelection:(BOOL)allowsMultiSection withMaxSelection:(NSInteger)maxCount withBlock:(FinishUploadBlock)block  {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)) {
        ImageBrowerViewController * (^imgBrowerVC)(void) = ^ImageBrowerViewController *(void) {
            ImageBrowerViewController *v = [[ImageBrowerViewController alloc] initWithNibName:nil bundle:nil];
            v.cellCountInOneRow = 3;
            v.cellSpace = 1;
            v.maxCount = maxCount;
            v.finishUploadBlock = block;
            v.allowsMultipleSelection = allowsMultiSection;
            v.allowsEdit = allowsEditing;
            
            if (allowsMultiSection) {
                v.allowsMultipleSelection = YES;
            } else {
                v.allowsMultipleSelection = NO;
            }
            
            return v;
        };
        
        AlbumBrowerViewController *album = [[AlbumBrowerViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:album];
        [nav setViewControllers:@[album, imgBrowerVC()]];
        
        album.didChooseAlbumBlock = ^(PHFetchResult<PHAsset *> *result) {
            ImageBrowerViewController * v = imgBrowerVC();
            v.result = result;
            [nav pushViewController:v animated:YES];
        };
        
        UIViewController *contrl = controller.presentedViewController ? controller.presentedViewController : controller;
        [contrl presentViewController:nav animated:YES completion:nil];
    }
}

@end
