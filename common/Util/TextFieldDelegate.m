//
//  TextViewDelegate.m
//  jianfanjia
//
//  Created by Karos on 16/6/28.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "TextFieldDelegate.h"

@implementation TextFieldDelegate

- (BOOL)textField:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
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

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
//- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//- (void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
