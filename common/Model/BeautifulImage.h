//
//  BeautifulImage.h
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseModel.h"

@class LeafImage;

@interface BeautifulImage : BaseModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *house_type;
@property (nonatomic, strong) NSString *dec_style;
@property (nonatomic, strong) NSArray *images;

- (LeafImage *)leafImageAtIndex:(NSInteger )index;

@end
