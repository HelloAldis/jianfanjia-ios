//
//  RefreshViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/13.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RefreshViewController.h"
#import "ViewControllerContainer.h"

@interface RefreshViewController ()

@end

@implementation RefreshViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    RefreshSession *request = [[RefreshSession alloc] init];
    request._id = [GVUserDefaults standardUserDefaults].userid;

    [API userRefreshSession:request success:^{
        [ViewControllerContainer refreshSuccess];
        
        UserGetInfo *request = [[UserGetInfo alloc] init];
        [API userGetInfo:request success:nil failure:nil networkError:nil];
        [[NotificationDataManager shared] refreshUnreadCount];
    } failure:^{
        [ViewControllerContainer logout];
        [ViewControllerContainer refreshSuccess];
    } networkError:^{
        [ViewControllerContainer logout];
        [ViewControllerContainer refreshSuccess];
    }];
}

@end
