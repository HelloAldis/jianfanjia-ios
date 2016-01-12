//
//  StringUtil.m
//  jianfanjia
//
//  Created by JYZ on 15/12/4.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+ (NSString *)convertNil2Empty:(NSString *)aStr {
    return aStr ? aStr : @"";
}

+ (NSString *)rawImageUrl:(NSString *)imageid {
    NSString *url = [NSString stringWithFormat:@"%@image/%@", kApiUrl, imageid];
    return url;
}

+ (NSString *)thumbnailImageUrl:(NSString *)imageid width:(NSInteger)width {
    width = width * kScreenScale;
    NSString *url = [NSString stringWithFormat:@"%@thumbnail/%@/%@", kApiUrl, [NSNumber numberWithInteger:width] ,imageid];
    return url;
}

+ (NSString *)beautifulImageUrl:(NSString *)imageid title:(NSString *)title {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:kApiUrl];
    NSString *url = [NSString stringWithFormat:@"http://%@/zt/mobile/sharemito.html?imageId=%@&title=%@", components.host, imageid, [StringUtil encodeString:title]];
    
    return url;
}

+ (NSString*)encodeString:(NSString*)unencodedString {
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
