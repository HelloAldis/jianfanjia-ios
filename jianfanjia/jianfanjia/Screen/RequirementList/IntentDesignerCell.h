//
//  IntentDesignerCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntentDesignerCell : UITableViewCell

@property (strong, nonatomic) Designer *designer;

- (void)initWithDesigner:(Designer *)designer;

@end
