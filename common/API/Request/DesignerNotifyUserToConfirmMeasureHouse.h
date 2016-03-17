//
//  UploadImageToProcess.h
//  jianfanjia
//
//  Created by Karos on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseRequest.h"

@interface DesignerNotifyUserToConfirmMeasureHouse : BaseRequest

@property (strong, nonatomic) NSString* planid;
@property (strong, nonatomic) NSString* userid;

@end
