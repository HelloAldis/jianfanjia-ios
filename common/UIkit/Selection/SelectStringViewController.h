//
//  SelectRoomTypeViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSelectionViewController.h"

@interface SelectStringViewController : BaseSelectionViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithTitle:(NSString *)title options:(NSArray *)data curValue:(NSString *)curValue valueBlock:(ValueBlock)ValueBlock;

@end
