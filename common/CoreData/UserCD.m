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
        self.user = [self.user copy];
    } else {
        self.user = user;
    }
    
    self.userid = [user _id];
}

+ (void)insertOrUpdate:(User *)user {
    UserCD *userCD = [UserCD findFirstByAttribute:@"userid" withValue:user._id];
    
    if (userCD == nil) {
        userCD = [UserCD insertOne];
    }
    
    [userCD update:user];
    [NSManagedObjectContext save];
}

@end
