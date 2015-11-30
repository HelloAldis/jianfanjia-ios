//
//  UIImagePickerController+Ex.m
//  jianfanjia
//
//  Created by likaros on 15/11/30.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UIImagePickerController+Ex.h"

static NSString* UIImagePickerControllerDelegateBlocksKey = @"UIImagePickerControllerDelegateBlocksKey";

@implementation UIImagePickerController (Ex)

- (id)useBlocksForDelegate {
    UIImagePickerControllerDelegateBlocks* delegate = [[UIImagePickerControllerDelegateBlocks alloc] init];
    objc_setAssociatedObject (self, &UIImagePickerControllerDelegateBlocksKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = delegate;
    return self;
}

- (void)onDidFinishPickingMediaWithInfo:(UIImagePickerControllerDidFinishPickingMediaWithInfoBlock)block {
    [((UIImagePickerControllerDelegateBlocks*)self.delegate) setDidFinishPickingMediaWithInfoBlock:block];
}

@end

@implementation UIImagePickerControllerDelegateBlocks

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info  {
    if (self.didFinishPickingMediaWithInfoBlock) {
        self.didFinishPickingMediaWithInfoBlock(picker, info);
    }
}

@end
