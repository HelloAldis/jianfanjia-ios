//
//  Reschedule.h
//  jianfanjia
//
//  Created by likaros on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface Reschedule : BaseRequest

@property (strong, nonatomic) NSString* processid;
@property (strong, nonatomic) NSString* userid;
@property (strong, nonatomic) NSString* designerid;
@property (strong, nonatomic) NSString* section;
@property (strong, nonatomic) NSNumber* updated_date;

@end
