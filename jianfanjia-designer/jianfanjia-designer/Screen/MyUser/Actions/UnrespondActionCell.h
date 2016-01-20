//
//  RequirementCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseActionCell.h"

@interface UnrespondActionCell : BaseActionCell

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock;

@end
