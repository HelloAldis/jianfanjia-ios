//
//  RequirementCreateProtocol.h
//  jianfanjia
//
//  Created by Karos on 15/12/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#ifndef RequirementCreateProtocol_h
#define RequirementCreateProtocol_h

@protocol RequirementCreateProtocol <NSObject>

@required
- (void)triggerEditEvent;
- (void)triggerDoneEvent;
- (BOOL)hasDataChanged;
- (BOOL)allowsSubmit;

@end

#endif /* RequirementCreateProtocol_h */
