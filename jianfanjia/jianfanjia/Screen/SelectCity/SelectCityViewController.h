//
//  SelectCityViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/9.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSelectionViewController.h"

@interface SelectCityViewController : BaseSelectionViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithAddress:(NSString *)currentAddress valueBlock:(ValueBlock)ValueBlock;

@end
