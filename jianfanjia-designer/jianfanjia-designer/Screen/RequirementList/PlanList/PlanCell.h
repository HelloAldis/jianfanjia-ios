//
//  MatchDesignerCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanCell : UITableViewCell

- (void)initWithPlan:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement;

@end
