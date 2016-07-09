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

@end

@implementation DiarySetDetailViewContainerController

+ (DiarySetDetailViewContainerController *)sideMenuWithDiarySet:(DiarySet *)diarySet {
    DiarySetDetailViewController *viewController = [[DiarySetDetailViewController alloc] initWithDiarySet:diarySet];
    DiarySetDetailViewContainerController *sideMenuController = [[DiarySetDetailViewContainerController alloc] initWithRootViewController:viewController];
    [sideMenuController setLeftViewEnabledWithWidth:kScreenWidth * (4.8 / 10.0)
                                  presentationStyle:LGSideMenuPresentationStyleSlideBelow
                               alwaysVisibleOptions:0];
    
    return sideMenuController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = NO;

    UIImageView *menuIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_diary_set_navigation"]];
    menuIcon.userInteractionEnabled = YES;
    [menuIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMenu)]];
    menuIcon.frame = CGRectMake(20, kScreenHeight - 75, 45, 45);
    [self.rootViewController.view addSubview:menuIcon];
}

- (void)onTapMenu {
    self.leftViewController = [[DiarySetLeftMenuViewController alloc] init];
    _leftViewController.width = self.leftViewWidth;
    [_leftViewController.collectionView reloadData];
    [self.leftView addSubview:_leftViewController.view];
    
    [self showLeftViewAnimated:YES completionHandler:^{
        
    }];
}

@end
