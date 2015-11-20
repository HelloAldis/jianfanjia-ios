//
//  OrderDesignerViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface OrderDesignerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithRequirement:(Requirement *)requirement;

@end
