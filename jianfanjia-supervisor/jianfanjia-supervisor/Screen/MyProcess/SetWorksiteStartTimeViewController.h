//
//  CustomAlertViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^WorksiteStartCompletionBlock)(BOOL completion);

@interface SetWorksiteStartTimeViewController : BaseViewController

+ (void)showSetMeasureHouseTime:(Requirement *)requirement completion:(WorksiteStartCompletionBlock)completion;

@end
