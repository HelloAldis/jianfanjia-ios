//
//  UploadImageToProcess.h
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DeleteYsImageFromProcess : BaseRequest

@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSString* section;
@property (strong, nonatomic) NSString* key;

@end
