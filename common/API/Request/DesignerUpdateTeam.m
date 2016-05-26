//
//  SearchPrettyImage.m
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerUpdateTeam.h"

@interface DesignerUpdateTeam ()

@end

@implementation DesignerUpdateTeam

- (id)initWithTeam:(Team *)team {
    if (self = [super init]) {
        [self merge:team];
    }
    
    return self;
}

@end
