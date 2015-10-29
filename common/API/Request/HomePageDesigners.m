//
//  HomePageDesigners.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HomePageDesigners.h"

@implementation HomePageDesigners

@dynamic from;
@dynamic limit;

- (void)success {
    NSMutableDictionary *dict = [DataManager shared].data;
    
    NSMutableArray *arr = [dict objectForKey:@"designers"];
    NSMutableArray *designers = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    for (NSMutableDictionary *d in arr) {
        Designer *designer = [[Designer alloc] initWith:d];
        [designers addObject:designer];
        designer.product = [[Product alloc] initWith:[d objectForKey:@"product"]];
    }
    
    if (self.from.integerValue == 0) {
        [DataManager shared].homePageDesigners = designers;
        
        if ([dict objectForKey:@"requirement"]) {
            [DataManager shared].homePageRequirement = [[Requirement alloc] initWith:[dict objectForKey:@"requirement"]];
        }
        
        arr = [[dict objectForKey:@"requirement"] objectForKey:@"designers"];
        designers = [[NSMutableArray alloc] initWithCapacity:[arr count]];
        for (NSMutableDictionary *d in arr) {
            [designers addObject:[[Designer alloc] initWith:d]];
        }
        [DataManager shared].homePageRequirementDesigners = designers;
    } else {
        [[DataManager shared].homePageDesigners addObjectsFromArray:designers];
    }
}

@end
