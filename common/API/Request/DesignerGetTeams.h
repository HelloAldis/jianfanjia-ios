//
//  ProductHomePage.h
//  jianfanjia
//
//  Created by JYZ on 15/10/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DesignerGetTeams : BaseRequest

@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *limit;

@end
