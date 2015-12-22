//
//  PrettyPictureDataManager.h
//  jianfanjia
//
//  Created by Karos on 15/12/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeautifulImageDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *beautifulImages;

- (void)refreshBeautifulImage;
- (void)loadMoreBeautifulImage;

@end
