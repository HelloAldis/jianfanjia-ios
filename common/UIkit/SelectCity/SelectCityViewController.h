//
//  SelectCityViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ValueBlock)(id value);

@interface SelectCityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithAddress:(NSString *)currentAddress valueBlock:(ValueBlock)ValueBlock;
- (id)initWithAddress:(NSString *)currentAddress valueBlock:(ValueBlock)ValueBlock limitCity:(BOOL)limitCity;

@end
