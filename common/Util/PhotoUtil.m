//
//  PhotoUtil.m
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PhotoUtil.h"
#import "ViewControllerContainer.h"
#import "ImageEditorViewController.h"

@implementation PhotoUtil

+ (void)showUserAvatarSelector:(FinishUploadBlock)block {
    [self showPhotoSelector:YES isMultiSelection:NO withMaxSelection:1 withBlock:block];
}

+ (void)showDecorationNodeImageSelector:(NSInteger)count withBlock:(FinishUploadBlock)block {
    [self showPhotoSelector:NO isMultiSelection:YES withMaxSelection:count withBlock:block];
}

+ (void)showPhotoSelector:(BOOL)allowsEditing isMultiSelection:(BOOL)allowsMultiSection withMaxSelection:(NSInteger)maxCount withBlock:(FinishUploadBlock)block {
    UIViewController *controller = [ViewControllerContainer getCurrentTapController];
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
                
                ImageEditorViewController *v = [[ImageEditorViewController alloc] initWithImage:originalImage allowCut:allowsEditing finishBlock:block];
                [controller.navigationController pushViewController:v animated:YES];
                [controller dismissViewControllerAnimated:YES completion:^{
                    // Save the new image (original or edited) to the Camera Roll
                    UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil , nil);
                }];
            }];
            
            [controller presentViewController:imagePickerController animated:YES completion:NULL];
        }
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)) {
            ImageBrowerViewController *v = [[ImageBrowerViewController alloc] initWithNibName:nil bundle:nil];
            v.cellCountInOneRow = 4;
            v.cellSpace = 1;
            v.maxCount = maxCount;
            v.finishUploadBlock = block;
            v.allowsMultipleSelection = allowsMultiSection;
            v.allowsEdit = allowsEditing;

            [controller.navigationController pushViewController:v animated:YES];
        }
    }];
    
    [alert addAction:cancel];
    [alert addAction:camera];
    [alert addAction:photo];
    
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
