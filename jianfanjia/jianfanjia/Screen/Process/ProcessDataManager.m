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
    [self refreshSelectedItems];
}

- (void)switchToSelectedSection:(NSInteger)index {
    self.selectedSectionIndex = index;
}

- (Section *)selectedSection {
    return self.sections[self.selectedSectionIndex];
}

- (void)refreshSelectedItems {
    NSArray *arr = [self.selectedSection.data objectForKey:@"items"];
    NSMutableArray *itemArr = [arr map:^id(id obj) {
        return [[Item alloc] initWith:obj];
    }];
    
    self.selectedItems = itemArr;
}

@end
