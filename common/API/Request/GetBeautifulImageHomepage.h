//
//  GetBeautifulImageHomepage.h
//  jianfanjia
//
//  Created by Karos on 15/12/21.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface GetBeautifulImageHomepage : BaseRequest

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSNumber *previous_count;
@property (nonatomic, strong) NSNumber *next_count;

@end
