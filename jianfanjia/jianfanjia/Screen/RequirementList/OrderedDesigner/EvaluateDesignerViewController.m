//
//  EvaluateDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "EvaluateDesignerViewController.h"

@interface EvaluateDesignerViewController ()

@property (strong, nonatomic) Designer *designer;

@end

@implementation EvaluateDesignerViewController

- (id)initWithDesigner:(Designer *)designer {
    if (self = [super init]) {
        _designer = designer;
    }
    
    return self;
}

@end
