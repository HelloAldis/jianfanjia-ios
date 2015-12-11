//
//  NSManagedObject+Ex.m
//  jianfanjia
//
//  Created by JYZ on 15/9/29.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "NSManagedObject+Ex.h"
#import "NSManagedObjectContext+Ex.h"

@implementation NSManagedObject (Ex)

#pragma mark + public
+ (instancetype) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "+Wdeprecated+declarations"
    return [self findFirstByAttribute:attribute
                            withValue:searchValue
                            inContext:[NSManagedObjectContext context]];
#pragma clang diagnostic pop
}

+ (instancetype)insertOne {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:[NSManagedObjectContext context]];
}

#pragma mark + find util

+ (instancetype) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstByAttribute:attribute withValue:searchValue inContext:context];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

#pragma mark + request util

+ (NSFetchRequest *) requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self requestAllWhere:attribute isEqualTo:searchValue inContext:context];
    [request setFetchLimit:1];
    
    return request;
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value
{
    return [self requestAllWhere:property isEqualTo:value inContext:[NSManagedObjectContext context]];
}


+ (NSFetchRequest *) requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];
    
    return request;
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)where args:(NSArray *)args
{
    return [self requestAllWhere:where args:args inContext:[NSManagedObjectContext context]];
}

+ (NSFetchRequest *) requestAllWhere:(NSString *)where args:(NSArray *)args inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:where argumentArray:args]];
    
    return request;
}

+ (NSFetchRequest *) createFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entityDescriptionInContext:context]];
    
    return request;
}

#pragma mark + entity util
+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [self entityName];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}

+ (NSString *) entityName;
{
    return [NSStringFromClass(self.class) componentsSeparatedByString:@"."].lastObject;
}

#pragma mark + execute request util
+ (id) executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    [request setFetchLimit:1];
    
    NSArray *results = [self executeFetchRequest:request inContext:context];
    if ([results count] == 0)
    {
        return nil;
    }
    return [results firstObject];
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request
{
    return [self executeFetchRequest:request inContext:[NSManagedObjectContext context]];
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        
        results = [context executeFetchRequest:request error:&error];
        
        if (results == nil)
        {
            DDLogError(@"fetch core data error %@", error);
        }
    }];
    return results;
}

+ (NSUInteger) executeCountForFetchRequest:(NSFetchRequest *)request
{
    return [self executeCountForFetchRequest:request inContext:[NSManagedObjectContext context]];
}

+ (NSUInteger) executeCountForFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSUInteger resultCount;
    [context performBlockAndWait:^{
        NSError *error = nil;
        
        resultCount = [context countForFetchRequest:request error:&error];
        
        if (!error)
        {
            DDLogError(@"fetch core data error %@", error);
        }
    }];
    return resultCount;
}

@end
