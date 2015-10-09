//
//  BaseRequest.h
//  AURA
//
//  Created by KindAzrael on 14-10-11.
//  Copyright (c) 2014年 AURA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : BaseDynamicObject

/**
 call before the request send, subclass can override this method
 */
- (void)pre;

/**
 call when receive response no matter response is failure and success, subclass can override this method
 */
- (void)all;

/**
 call when response is failure, subclass can override this method
 */
- (void)failure;

/**
 call when response is success, subclass can override this method
 */
- (void)success;

/**
 do not override this method
 */
- (void)handle:(id)response success:(void (^)(void))success failure:(void (^)(void))failure;

/**
 handle http error here
 */
- (void)handleHttpError:(NSError *)err failure:(void (^)(void))failure;

@end
