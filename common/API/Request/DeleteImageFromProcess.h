//
//  DeleteImageFromProcess.h
//  jianfanjia
//
//  Created by Karos on 15/12/1.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteImageFromProcess : BaseRequest

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *section;
@property (strong, nonatomic) NSString *item;
@property (strong, nonatomic) NSNumber *index;

@end
