//
//  BeautifulImagePosition.h
//  jianfanjia
//
//  Created by Karos on 16/2/16.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@interface BeautifulImagePosition : BaseModel

@property (strong, nonatomic) NSArray *beautiful_images;
@property (strong, nonatomic) NSString *total;

- (BeautifulImage *)beautifulImageAtIndex:(NSInteger )index;

@end
