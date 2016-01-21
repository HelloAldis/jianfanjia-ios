//
//  BaseActionCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/1/20.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);

@interface BaseActionCell : UITableViewCell

@property (nonatomic, strong) Requirement *requirement;
@property (nonatomic, copy) ActionBlock actionBlock;

- (void)initWithRequirement:(Requirement *)requirement actionBlock:(ActionBlock)actionBlock;
- (void)initHeaderData:(UIImageView *)imgHomeOwner gender:(UIImageView *)imgUserGender name:(UILabel *)lblUserName cell:(UILabel *)lblCellNameVal info:(UILabel *)lblRequirementfInfo updateTime:(UILabel *)lblUpdateTimeVal;

- (void)handleTapHeaderView:(UIGestureRecognizer*)gestureRecognizer;
- (void)onClickViewPlan;
- (void)onClickContact;

@end
