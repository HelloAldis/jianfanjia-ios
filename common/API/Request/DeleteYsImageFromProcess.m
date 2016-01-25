//
//  UploadImageToProcess.m
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DeleteYsImageFromProcess.h"

@implementation DeleteYsImageFromProcess

@dynamic _id;
@dynamic section;
@dynamic key;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
