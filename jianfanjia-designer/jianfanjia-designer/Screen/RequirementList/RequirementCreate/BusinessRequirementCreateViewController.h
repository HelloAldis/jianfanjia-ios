//
//  RequirementCreateViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RequirementCreateProtocol.h"

@interface BusinessRequirementCreateViewController : BaseViewController <RequirementCreateProtocol>

- (id)initToCreateRequirement;
- (id)initToViewRequirement:(Requirement *)requirement;

- (void)triggerEditEvent;
- (void)triggerDoneEvent;
- (BOOL)hasDataChanged;

- (void)keyboardShow:(CGFloat)keyboardHeight;
- (void)keyboardHide:(CGFloat)keyboardHeight;

@end
