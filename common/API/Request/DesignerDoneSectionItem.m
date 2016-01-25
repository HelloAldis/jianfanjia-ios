//
//  DesignerDoneSectionItem.m
//  jianfanjia-designer
//
//  Created by Karos on 16/1/25.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DesignerDoneSectionItem.h"

@implementation DesignerDoneSectionItem

@dynamic _id;
@dynamic section;
@dynamic item;

- (void)failure {
    [HUDUtil showErrText:[DataManager shared].errMsg];
}

@end
