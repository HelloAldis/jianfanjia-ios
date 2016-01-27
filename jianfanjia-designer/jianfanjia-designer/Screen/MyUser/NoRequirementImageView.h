//
//  NoRequirementImageView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/1/27.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoRequirementImageView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirementTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirementDesc;

+ (NoRequirementImageView *)noRequirementImageView;

@end
