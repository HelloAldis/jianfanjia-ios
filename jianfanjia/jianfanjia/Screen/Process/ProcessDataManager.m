//
//  ProcessDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessDataManager.h"

@implementation ProcessDataManager

- (void)refreshProcess {
    NSMutableDictionary *dicProcess = [DataManager shared].data;
    self.process = [[Process alloc] initWith:dicProcess];
    [self refreshSections:self.process];
}

- (void)refreshSections:(Process *)process {
    NSArray *arr = [process.data objectForKey:@"sections"];
    NSMutableArray *sectionArr = [arr map:^id(id obj) {
        return [[Section alloc] initWith:obj];
    }];
    
    self.sections = sectionArr;
}

- (void)switchToSelectedSection:(NSInteger)index {
    self.selectedSectionIndex = index;
    self.selectedSection = self.sections[self.selectedSectionIndex];
    if (self.selectedSection) {
        [self refreshSelectedItems];
    }
}

- (void)refreshSelectedItems {
    NSArray *arr = [self.selectedSection.data objectForKey:@"items"];
    NSMutableArray *itemArr = [arr map:^id(id obj) {
        return [[Item alloc] initWith:obj];
    }];
    
    if ([ProcessBusiness hasYs:self.selectedSectionIndex]) {
        Item *item = [[Item alloc] init];
        item.name = DBYS;
        item.ys = [[Ys alloc] initWith:[self.selectedSection.data objectForKey:@"ys"]];
        [itemArr insertObject:item atIndex:0];
        self.selectedSection.ys = item.ys;
    } else {
        self.selectedSection.ys = nil;
    }
    
    self.selectedItems = itemArr;
}

@end
