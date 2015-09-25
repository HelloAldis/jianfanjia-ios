//
//  DesignerCDDao.h
//  jianfanjia
//
//  Created by JYZ on 15/9/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseDao.h"
#import "DesignerCD.h"

@interface DesignerCDDao : BaseDao

+ (DesignerCD *)findOneByDesignerid:(NSString *)designerid;
+ (NSArray *)find;
+ (DesignerCD *)insertOne;
+ (void)insertOrUpdate:(Designer *)designer;

@end
