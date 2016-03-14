//
//  OrderDesignerViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PlanPreviewViewController : BaseViewController <UIScrollViewDelegate>

- (id)initWithPlan:(Plan *)plan forRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;

@end
