//
//  DesignerHomePage.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerHomePage.h"

@implementation DesignerHomePage

@dynamic _id;

- (void)pre {
    [DataManager shared].designerPageDesigner = nil;
}

- (void)success {
    NSMutableDictionary *dict = [DataManager shared].data;
    [DataManager shared].designerPageDesigner = [[Designer alloc] initWith:dict];
}

@end
