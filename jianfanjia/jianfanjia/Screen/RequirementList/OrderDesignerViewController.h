//
//  OrderDesignerViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDesignerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithMatchDesigner:(NSArray *)matchDesigners;

@end
