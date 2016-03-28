//
//  DesignerPlanStatusBaseCell.h
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PlanStatusRefreshBlock)(void);

@interface DesignerPlanStatusBaseCell : UITableViewCell

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) Requirement *requirement;

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock;
- (void)initHeader:(UIImageView *)avatar name:(UILabel *)name idCheck:(UIImageView *)idCheck infoCheck:(UIImageView *)infoCheck stars:(NSArray <UIImageView *> *)evaluatedStars;
- (void)refresh;
- (void)onClickDesignerAvatar;

@end
