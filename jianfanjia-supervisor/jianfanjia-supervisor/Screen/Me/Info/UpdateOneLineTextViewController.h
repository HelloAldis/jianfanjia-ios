//
//  UpdateOneLineTextViewController.h
//  jianfanjia
//
//  Created by Karos on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateOneLineTextViewController : BaseViewController

- (id)initWithName:(NSString *)name value:(NSString *)value done:(void(^)(id value))DoneBlock;

@end
