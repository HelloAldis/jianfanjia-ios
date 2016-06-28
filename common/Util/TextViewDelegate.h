//
//  TextViewDelegate.h
//  jianfanjia
//
//  Created by Karos on 16/6/28.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TextViewDelegateDidChangeBlock)(NSString *string);

@interface TextViewDelegate : NSObject <UITextViewDelegate>

@property (nonatomic, assign) NSInteger maxInputLen;
@property (nonatomic, copy) TextViewDelegateDidChangeBlock didChangeBlock;

@end
