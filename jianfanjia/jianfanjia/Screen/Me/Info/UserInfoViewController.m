//
//  UserInfoViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblSex;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDetailLocation;

@end

@implementation UserInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
//    if (self.tabBarController.tabBar.frame.origin.y == ) {
//        <#statements#>
//    }
//    self.tabBarController.tabBar.frame = CGRectOffset(self.tabBarController.tabBar.frame, 0, 50);
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"个人信息";
}

#pragma mark - user action
- (IBAction)onClickImage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片上传" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showCamera];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPhotoLib];
    }];
    
    [alert addAction:cancel];
    [alert addAction:camera];
    [alert addAction:photo];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onClickUsername:(id)sender {

}

- (IBAction)onClickSex:(id)sender {
    
}

- (IBAction)onClickLocation:(id)sender {
}

- (IBAction)onClickDetailLocation:(id)sender {
}

#pragma mark - MWPhotoBrowser delegate

#pragma mark - Util
- (void)showPhotoLib {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO))
        return ;
//    PHFetchOptions *options = [[PHFetchOptions alloc] init];
//    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//    self.result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = YES;
//    browser.startOnGrid = YES;
//    browser.enableGrid = YES;
//    browser.alwaysShowControls = NO;
//    browser.displaySelectionButtons = YES;
//    browser.enableSwipeToDismiss = YES;
    
//    [self.navigationController pushViewController:browser animated:YES];
}

- (void)showCamera {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO))
        return ;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePickerController.view.frame = CGRectMake(0, 0, 320, 320);
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    imagePickerController.allowsEditing = YES;
//    imagePickerController.delegate = cameraControlView;
//    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 64);
//    imagePickerController.cameraViewTransform = translate;
//    imagePickerController.showsCameraControls = NO;
//    imagePickerController.cameraOverlayView = cameraControlView;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

@end
