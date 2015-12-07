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
    
    UserLogin *request = [[UserLogin alloc] init];
    request.phone = [GVUserDefaults standardUserDefaults].x;
    request.pass = [GVUserDefaults standardUserDefaults].xx;
    [API userLogin:request success:^{
        [ViewControllerContainer refreshSuccess];
    } failure:^{
        [ViewControllerContainer logout];
    } networkError:^{
        
    }];
}

@end
