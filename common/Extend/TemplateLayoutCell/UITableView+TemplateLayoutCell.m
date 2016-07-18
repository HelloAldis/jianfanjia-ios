//
//  UITableView+TemplateLayoutCell.m
//  jianfanjia
//
//  Created by Karos on 16/7/18.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UITableView+TemplateLayoutCell.h"

@implementation UITableView (TemplateLayoutCell)

- (__kindof UITableViewCell *)templateCellForReuseIdentifier:(NSString *)identifier {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    
    NSMutableDictionary<NSString *, UITableViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewCell *templateCell = templateCellsByIdentifiers[identifier];
    
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithIdentifier:identifier];
        NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateCellsByIdentifiers[identifier] = templateCell;
    }
    
    return templateCell;
}

@end
