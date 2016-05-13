//
//  JYZWeakObjectContainer
//  jianfanjia
//
//  Created by Karos on 16/5/13.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void jyz_objc_setAssociatedWeakObject(id container, void *key, id value);
extern id jyz_objc_getAssociatedWeakObject(id container, void *key);

