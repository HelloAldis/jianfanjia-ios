//
//  JYZWeakObjectContainer
//  jianfanjia
//
//  Created by Karos on 16/5/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "JYZWeakObjectContainer.h"
#import <objc/runtime.h>

@interface JYZWeakObjectContainer : NSObject
@property (nonatomic, weak) id object;
@end

@implementation JYZWeakObjectContainer

void jyz_objc_setAssociatedWeakObject(id container, void *key, id value)
{
    JYZWeakObjectContainer *wrapper = [[JYZWeakObjectContainer alloc] init];
    wrapper.object = value;
    objc_setAssociatedObject(container, key, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

id jyz_objc_getAssociatedWeakObject(id container, void *key)
{
    return [(JYZWeakObjectContainer *)objc_getAssociatedObject(container, key) object];
}

@end
