//
//  ProcessCD.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessCD.h"
#import "ProcessToData.h"


@implementation ProcessCD

// Insert code here to add functionality to your managed object subclass

+ (void)initialize {
    ProcessToData *transformer = [[ProcessToData alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"ProcessToData"];
}

- (void)update:(Process *)process {
    if (self.process) {
        [self.process merge:process];
        self.process = [self.process copy];
    } else {
        self.process = process;
    }
    
    self.final_designerid = [process final_designerid];
    self.userid = [process userid];
    self.processid = [process _id];
}

@end
