//
//  DesignerGetUserRequirements.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DesignerGetUserRequirements.h"

@implementation DesignerGetUserRequirements

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
