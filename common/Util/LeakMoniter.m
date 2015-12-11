//
//  LeakMoniter.m
//  SparkPay
//
//  Created by Az on 15/5/4.
//  Copyright (c) 2015年 Capital One Services, LLC. All rights reserved.
//

#import "LeakMoniter.h"
#import "Aspects.h"

static NSMutableDictionary *allocDict = nil;
static NSMutableDictionary *deallocDict = nil;

@implementation LeakMoniter

+ (void)start {
    allocDict = [[NSMutableDictionary alloc] init];
    deallocDict = [[NSMutableDictionary alloc] init];

    NSError *error = nil;
    [UIViewController aspect_hookSelector:@selector(initWithNibName:bundle:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
    [self handleAlloc:[[[aspectInfo instance] class] description]];
    } error:&error];
    DDLogDebug(@"error: %@", error);

    error = nil;
    [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
    [self handleDealloc:[[[aspectInfo instance] class] description]];
    } error:&error];
    DDLogDebug(@"error: %@", error);
    
//    NSError *error = nil;
//    [UIImage aspect_hookSelector:@selector(initWithData:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
//        [self handleAlloc:[[[aspectInfo instance] class] description]];
//    } error:&error];
//    DDLogDebug(@"error: %@", error);
//
//    error = nil;
//    [UIImage aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
//        [self handleDealloc:[[[aspectInfo instance] class] description]];
//    } error:&error];
//    DDLogDebug(@"error: %@", error);
  
//  error = nil;
//  [UIView aspect_hookSelector:@selector(awakeFromNib) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
//    [self handleAlloc:[[[aspectInfo instance] class] description]];
//  }  error:&error];
//  DDLogDebug(@"error: %@", error);
//  
//  error = nil;
//  [UIView aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
//    [self handleDealloc:[[[aspectInfo instance] class] description]];
//  } error:&error];
//  DDLogDebug(@"error: %@", error);
}

+ (void)handleAlloc:(NSString *)key {
  NSNumber *value = [allocDict objectForKey:key];
  if (value) {
    value = [NSNumber numberWithLong:([value longValue] + 1)];
  } else {
    value = [NSNumber numberWithLong:1L];
  }
  [allocDict setObject:value forKey:key];
}

+ (void)handleDealloc:(NSString *)key {
  NSNumber *value = [deallocDict objectForKey:key];
  if (value) {
    value = [NSNumber numberWithLong:([value longValue] + 1)];
  } else {
    value = [NSNumber numberWithLong:1L];
  }
  [deallocDict setObject:value forKey:key];
}

+ (void)end {
  DDLogDebug(@"alloc summary: %@", allocDict);
  DDLogDebug(@"dealloc summary: %@", deallocDict);
  
  for (NSString *key in [allocDict allKeys]) {
    NSNumber *alloc = [allocDict objectForKey:key];
    NSNumber *dealloc = [deallocDict objectForKey:key];
    
    if (![alloc isEqual:dealloc]) {
      DDLogDebug(@"%@ may be leak", key);
    }
  }
}

@end
