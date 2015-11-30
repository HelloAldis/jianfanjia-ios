//
//  UploadImage.m
//  jianfanjia
//
//  Created by JYZ on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UploadImage.h"

@implementation UploadImage

- (void)success {
    NSString *imageid = [DataManager shared].data;
    [DataManager shared].lastUploadImageid = imageid;
}

@end
