//
//  UIImagePickerController+Ex.h
//  jianfanjia
//
//  Created by likaros on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIImagePickerControllerDidFinishPickingMediaWithInfoBlock)(UIImagePickerController* picker, NSDictionary* info);

@interface UIImagePickerController (Ex)

- (id)useBlocksForDelegate;
- (void)onDidFinishPickingMediaWithInfo:(UIImagePickerControllerDidFinishPickingMediaWithInfoBlock)block;

@end

@interface UIImagePickerControllerDelegateBlocks : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, copy) UIImagePickerControllerDidFinishPickingMediaWithInfoBlock didFinishPickingMediaWithInfoBlock;

@end
