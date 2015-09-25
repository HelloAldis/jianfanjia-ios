//
//  UserCD.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UserCD.h"
#import "UserToData.h"


@implementation UserCD

// Insert code here to add functionality to your managed object subclass

+ (void)initialize {
    UserToData *transformer = [[UserToData alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"UserToData"];
}

- (void)update:(User *)user {
    if (self.user) {
        [self.user merge:user];
    } else {
        self.user = user;
    }
    
    self.userid = [user _id];
}

@end
