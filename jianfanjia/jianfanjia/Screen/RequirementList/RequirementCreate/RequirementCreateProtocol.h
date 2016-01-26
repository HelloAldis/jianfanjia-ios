//
//  RequirementCreateProtocol.h
//  jianfanjia
//
//  Created by Karos on 15/12/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#ifndef RequirementCreateProtocol_h
#define RequirementCreateProtocol_h

typedef enum {
    RequirementOperateTypeView,
    RequirementOperateTypeEdit
} RequirementOperateType;

@protocol RequirementCreateProtocol <NSObject>

@required
- (id)initToCreateRequirement;
- (id)initToViewRequirement:(Requirement *)requirement;

- (void)triggerEditEvent;
- (void)triggerDoneEvent;
- (BOOL)hasDataChanged;

@optional
- (void)keyboardShow:(CGFloat)keyboardHeight;
- (void)keyboardHide:(CGFloat)keyboardHeight;

@end

#endif /* RequirementCreateProtocol_h */
