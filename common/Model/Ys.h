//
//  Ys.h
//  jianfanjia
//
//  Created by JYZ on 15/9/25.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@class YsImage;

@interface Ys : BaseModel

@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSMutableArray *images;

- (YsImage *)ysImageAtIndex:(NSInteger )index;

@end
