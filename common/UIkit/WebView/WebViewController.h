//
//  AgreementViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseWebViewController.h"

@interface WebViewController : BaseWebViewController

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url shareTopic:(NSString *)topic;

@end
