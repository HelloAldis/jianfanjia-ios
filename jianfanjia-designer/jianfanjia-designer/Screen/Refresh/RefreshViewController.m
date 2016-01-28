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
    
    [API designerRefreshSession:request success:^{
        DesignerGetInfo *request = [[DesignerGetInfo alloc] init];
        [API designerGetInfo:request success:^{
            [ViewControllerContainer refreshSuccess];
        } failure:^{
        } networkError:^{
        }];
    } failure:^{
        [ViewControllerContainer logout];
    } networkError:^{
        
    }];
}

@end
