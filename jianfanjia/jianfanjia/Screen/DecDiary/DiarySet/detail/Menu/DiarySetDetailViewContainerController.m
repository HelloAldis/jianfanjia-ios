//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetDetailViewContainerController.h"
#import "DiarySetDetailViewController.h"
#import "DiarySetLeftMenuViewController.h"
#import "ViewControllerContainer.h"

@interface DiarySetDetailViewContainerController ()

@property (nonatomic, strong) DiarySetLeftMenuViewController *leftViewController;
@property (nonatomic, weak) DiarySetDetailViewController *contentController;

@end

@implementation DiarySetDetailViewContainerController

+ (DiarySetDetailViewContainerController *)sideMenuWithDiarySet:(DiarySet *)diarySet {
    DiarySetDetailViewController *viewController = [[DiarySetDetailViewController alloc] initWithDiarySet:diarySet];
    DiarySetDetailViewContainerController *sideMenuController = [[DiarySetDetailViewContainerController alloc] initWithRootViewController:viewController];
    [sideMenuController setLeftViewEnabledWithWidth:kScreenWidth * (4.8 / 10.0)
                                  presentationStyle:LGSideMenuPresentationStyleSlideBelow
                               alwaysVisibleOptions:0];
    
    sideMenuController.leftViewController = [[DiarySetLeftMenuViewController alloc] init];
    sideMenuController.leftViewController.width = sideMenuController.leftViewWidth;
    sideMenuController.contentController = viewController;
    
    return sideMenuController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.krs_EnableFakeNavigationBar = NO;

    UIImageView *menuIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_diary_set_navigation"]];
    menuIcon.userInteractionEnabled = YES;
    [menuIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMenu)]];
    menuIcon.frame = CGRectMake(20, kScreenHeight - 75, 45, 45);
    [self.rootViewController.view addSubview:menuIcon];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kLGSideMenuControllerWillShowLeftViewNotification object:self];
}

- (void)reloadData {
    _leftViewController.values = [_contentController getMenuNumberOfPhases];
    [_leftViewController.collectionView reloadData];
    
    @weakify(self);
    _leftViewController.didChoose = ^(NSString *phase) {
        @strongify(self);
        [self hideLeftViewAnimated:YES completionHandler:^{
            [self.contentController didChooseMenuPhase:phase];
        }];
    };
    
    [_leftViewController.view removeFromSuperview];
    [self.leftView addSubview:_leftViewController.view];
}

- (void)onTapMenu {
    [self showLeftViewAnimated:YES completionHandler:nil];
}

@end
