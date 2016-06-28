//
//  TextViewDelegate.h
//  jianfanjia
//
//  Created by Karos on 16/6/28.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TextFieldDelegateDidChangeBlock)(NSString *string);

@interface TextFieldDelegate : NSObject

@property (nonatomic, assign) NSInteger maxInputLen;
@property (nonatomic, copy) TextFieldDelegateDidChangeBlock didChangeBlock;

@end
