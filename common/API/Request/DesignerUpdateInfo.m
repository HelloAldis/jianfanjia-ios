//
//  SearchPrettyImage.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerUpdateInfo.h"

@interface DesignerUpdateInfo ()

@end

@implementation DesignerUpdateInfo

- (id)initWithDesigner:(Designer *)designer {
    if (self = [super init]) {
        [self merge:designer];
    }
    
    return self;
}

@end
