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
    DDLogDebug(@"==================== RefreshSession1 %@", [NSDate date]);
    [API userRefreshSession:request success:^{
        DDLogDebug(@"==================== RefreshSession2 %@", [NSDate date]);
        [ViewControllerContainer refreshSuccess];
        DDLogDebug(@"==================== RefreshSession3 %@", [NSDate date]);
        UserGetInfo *request = [[UserGetInfo alloc] init];
        [API userGetInfo:request success:nil failure:nil networkError:nil];
    } failure:^{
        [ViewControllerContainer logout];
        [ViewControllerContainer refreshSuccess];
    } networkError:^{
        [ViewControllerContainer logout];
        [ViewControllerContainer refreshSuccess];
    }];
}

@end
