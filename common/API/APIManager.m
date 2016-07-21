//
//  API.m
//  jianfanjia
//

#import "APIManager.h"

static NSString *kSessionKey = @"connect.sid";
static AFHTTPRequestOperationManager *_manager;

@implementation APIManager

+ (void)initialize {
    _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kApiUrl]];
    _manager.completionQueue = YYDispatchQueueGetForQOS(NSQualityOfServiceBackground);
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.requestSerializer.HTTPShouldHandleCookies = YES;
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    serializer.removesKeysWithNullValues = YES;
    _manager.responseSerializer = serializer;
}

+ (BOOL)isSessionExpired {
    BOOL isExpired = YES;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([cookie.name isEqualToString:kSessionKey]) {
            isExpired = [cookie.expiresDate compare:[NSDate date]] == NSOrderedAscending;
            break;
        }
    }
    
    return isExpired;
}

+ (void)clearCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

+ (void)GET:(NSString *)url handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError {
    [request pre];
    [_manager GET:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject){
               [request handle:responseObject success:success failure:failure];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [request handleHttpError:error networkError:networkError];
          }];
}

+ (void)POST:(NSString *)url data:(NSDictionary *)data handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError {
    [request pre];
    [_manager POST:url
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [request handle:responseObject success:success failure:failure];
   
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [request handleHttpError:error networkError:networkError];
          }];
}

+ (void)uploadImage:(UIImage *)image handler:(BaseRequest *)request success:(void (^)(void))success failure:(void (^)(void))failure networkError:(void (^)(void))networkError {
    [request pre];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kApiUrl, @"image/upload"];
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    mutableRequest.HTTPMethod = @"POST";
    [mutableRequest setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:[image data]];

    AFHTTPRequestOperation *operation = [_manager HTTPRequestOperationWithRequest:mutableRequest success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [request handle:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        [request handleHttpError:error networkError:networkError];
    }];
    
    [_manager.operationQueue addOperation:operation];
}

@end



