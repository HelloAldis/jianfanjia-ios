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
    
//    UserLogin *request = [[UserLogin alloc] init];
//    request.phone = [GVUserDefaults standardUserDefaults].phone;
//    request.pass = [SSKeychain passwordForService:kKeychainService account:[GVUserDefaults standardUserDefaults].phone];;
//    [API userLogin:request success:^{
//        [ViewControllerContainer refreshSuccess];
//    } failure:^{
//        [ViewControllerContainer logout];
//    } networkError:^{
//        
//    }];
    
    RefreshSession *request = [[RefreshSession alloc] init];
    request._id = [GVUserDefaults standardUserDefaults].userid;
    
    [API refreshSession:request success:^{
        [ViewControllerContainer refreshSuccess];
    } failure:^{
        [ViewControllerContainer logout];
    } networkError:^{
        
    }];
}

@end
