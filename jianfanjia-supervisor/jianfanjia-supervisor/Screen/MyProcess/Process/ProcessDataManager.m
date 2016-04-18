//
//  ProcessDataManager.m
//  jianfanjia
//
//  Created by Karos on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ProcessDataManager.h"

@implementation ProcessDataManager

- (void)refreshProcessList {
    NSArray *arr = [DataManager shared].data;
    NSMutableArray *processArr = [NSMutableArray arrayWithCapacity:arr.count];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Process *process = [[Process alloc] initWith:obj];
        User *user = [[User alloc] initWith:[process.data objectForKey:@"user"]];
        Requirement *requirement = [[Requirement alloc] initWith:[process.data objectForKey:@"requirement"]];
        Plan *plan = [[Plan alloc] initWith:[process.data objectForKey:@"plan"]];
        process.user = user;
        process.requirement = requirement;
        process.plan = plan;
        requirement.plan = plan;
        
        [processArr addObject:process];
    }];
    
    self.processList = processArr;
}

- (void)refreshProcess {
    NSMutableDictionary *dicProcess = [DataManager shared].data;
    self.process = [[Process alloc] initWith:dicProcess];
    [self refreshSections:self.process];
}

- (void)refreshSections:(Process *)process {
    NSArray *arr = [process.data objectForKey:@"sections"];
    NSMutableArray *sectionArr = [NSMutableArray arrayWithCapacity:arr.count];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Section *section = [[Section alloc] initWith:obj];
        [sectionArr addObject:section];
        
        if ([self.process.going_on isEqualToString:section.name]) {
            self.preOngoingSectionIndex = self.ongoingSectionIndex;
            self.ongoingSectionIndex = idx;
        }
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
        item.status = self.selectedSection.status;
        self.ysItem = item;
        self.selectedSection.ys = [[Ys alloc] initWith:[self.selectedSection.data objectForKey:@"ys"]];
        self.selectedSection.schedule = [[Schedule alloc] initWith:[self.selectedSection.data objectForKey:@"reschedule"]];
    } else {
        self.ysItem = nil;
        self.selectedSection.ys = nil;
    }
    
    self.selectedItems = itemArr;
}

@end
