//
//  RequirementCreateViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    Create,
    View,
    Edit,
} RequirementEditType;

@interface RequirementCreateViewController : BaseViewController

- (id)initToCreateRequirement;

@end
