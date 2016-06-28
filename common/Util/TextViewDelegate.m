//
//  TextViewDelegate.m
//  jianfanjia
//
//  Created by Karos on 16/6/28.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "TextViewDelegate.h"

@implementation TextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL flag = YES;
    NSString *curStr = textView.text;
    NSInteger len = curStr.length +  (text.length - range.length);
    NSInteger lenDelta = len - self.maxInputLen;
    NSInteger replaceToIndex = text.length - lenDelta;
    
    if (lenDelta > 0 && replaceToIndex < text.length) {
        NSString *replaceStr = [text substringToIndex:replaceToIndex];
        
        NSString *updatedStr = [curStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        flag = NO;
        if (self.didChangeBlock) {
            self.didChangeBlock(updatedStr);
        }
    }
    
    return flag;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > self.maxInputLen) {
        textView.text = [textView.text substringToIndex:self.maxInputLen];
    }
    
    if (self.didChangeBlock) {
        self.didChangeBlock(textView.text);
    }
}

@end
