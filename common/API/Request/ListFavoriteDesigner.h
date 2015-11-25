//
//  ListFavoriteDesigner.h
//  jianfanjia
//
//  Created by JYZ on 15/11/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface ListFavoriteDesigner : BaseRequest

@property (assign, nonatomic) NSNumber *from;
@property (assign, nonatomic) NSNumber *limit;

@end
