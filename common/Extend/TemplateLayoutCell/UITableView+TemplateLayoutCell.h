//
//  UITableView+TemplateLayoutCell.h
//  jianfanjia
//
//  Created by Karos on 16/7/18.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (TemplateLayoutCell)

- (__kindof UITableViewCell *)templateCellForReuseIdentifier:(NSString *)identifier;

@end
