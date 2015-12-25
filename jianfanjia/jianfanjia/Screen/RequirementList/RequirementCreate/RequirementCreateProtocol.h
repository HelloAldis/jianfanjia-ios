//
//  RequirementCreateProtocol.h
//  jianfanjia
//
//  Created by Karos on 15/12/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#ifndef RequirementCreateProtocol_h
#define RequirementCreateProtocol_h

static NSString *kTipsForSelectCity = @"（目前仅支持湖北省武汉市）";

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

@end

#endif /* RequirementCreateProtocol_h */
