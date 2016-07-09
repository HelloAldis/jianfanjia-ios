//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetDetailViewContainerController.h"
#import "DiarySetDetailViewController.h"
#import "ViewControllerContainer.h"

@interface DiarySetDetailViewContainerController ()

@end

@implementation DiarySetDetailViewContainerController

+ (DiarySetDetailViewContainerController *)sideMenuWithDiarySet:(DiarySet *)diarySet {
    DiarySetDetailViewController *viewController = [[DiarySetDetailViewController alloc] initWithDiarySet:diarySet];
    DiarySetDetailViewContainerController *sideMenuController = [[DiarySetDetailViewContainerController alloc] initWithRootViewController:viewController];
    [sideMenuController setLeftViewEnabledWithWidth:kScreenWidth * (4.8 / 10.0)
                                  presentationStyle:LGSideMenuPresentationStyleSlideBelow
                               alwaysVisibleOptions:0];
    
    UIViewController *leftViewController = [UIViewController new];
    leftViewController.view.backgroundColor = kTextColor;
    [sideMenuController.leftView addSubview:leftViewController.view];
    return sideMenuController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.krs_EnableFakeNavigationBar = NO;

    UIImageView *menuIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_publish_requirement"]];
    menuIcon.userInteractionEnabled = YES;
    [menuIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMenu)]];
    menuIcon.frame = CGRectMake(20, kScreenHeight - 60, 40, 40);
    [self.rootViewController.view addSubview:menuIcon];
}

- (void)onTapMenu {
    [self showLeftViewAnimated:YES completionHandler:^{
        
    }];
}

@end
