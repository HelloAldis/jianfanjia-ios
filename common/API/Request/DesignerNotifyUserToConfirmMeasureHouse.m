//
//  UploadImageToProcess.m
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerNotifyUserToConfirmMeasureHouse.h"

@implementation DesignerNotifyUserToConfirmMeasureHouse

@dynamic planid;
@dynamic userid;

- (void)failure {
    [HUDUtil showErrText:@"您今天已经提醒过了"];
}

@end
