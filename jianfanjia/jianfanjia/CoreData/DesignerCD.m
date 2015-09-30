//
//  DesignerCD.m
//  jianfanjia
//
//  Created by JYZ on 15/9/22.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerCD.h"
#import "DesignerToData.h"

@implementation DesignerCD

// Insert code here to add functionality to your managed object subclass

+ (void)initialize {
    DesignerToData *transformer = [[DesignerToData alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"DesignerToData"];
}

- (void)update:(Designer *)designer {
    if (self.designer) {
        [self.designer merge:designer];
        self.designer =  [self.designer copy];
    } else {
        self.designer = designer;
    }
    
    self.designerid = [designer _id];
}

+ (void)insertOrUpdate:(Designer *)designer {
    DesignerCD *designerCD = [DesignerCD findFirstByAttribute:@"designerid" withValue:designer._id];
    
    if (designerCD == nil) {
        designerCD = [DesignerCD insertOne];
    }
    [designerCD update:designer];

    [NSManagedObjectContext save];
}

@end
