//
//  DesignerListViewController.h
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseWebViewController.h"

typedef void (^WebViewActioBlock)(void);

@interface WebViewWithActionController : BaseWebViewController

+ (void)show:(UIViewController *)controller withUrl:(NSString *)url shareTopic:(NSString *)topic actionTitle:(NSString *)actionTitle actionBlock:(WebViewActioBlock)actionBlock;
+ (void)show:(UIViewController *)controller withUrl:(NSString *)url shareTopic:(NSString *)topic actionTitle:(NSString *)actionTitle canBack:(BOOL)canBack actionBlock:(WebViewActioBlock)actionBlock;

@end
