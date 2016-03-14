//
//  AgreementViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"

@interface AgreementViewController : BaseViewController

- (id)initWithRequirement:(Requirement *)requirement popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock;

@end
