//
//  ReorderTableView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/24.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReorderTableViewDelegate <UITableViewDelegate>
@optional
- (CGRect)orderTableView:(UITableView *)tableView dragViewRectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)orderTableView:(UITableView *)tableView canDragAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ReorderTableView : UITableView

@end
