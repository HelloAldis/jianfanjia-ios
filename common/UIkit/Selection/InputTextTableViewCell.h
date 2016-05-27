//
//  MultipleLineTextTableViewCell.h
//  jianfanjia
//
//  Created by Karos on 16/1/12.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^InputTextEndBlock)(NSString *value);

@interface InputTextTableViewCell : UITableViewCell

- (void)initWithTitle:(NSString *)title value:(NSString *)value inputEndBlock:(InputTextEndBlock)inputEndBlock;

@end
