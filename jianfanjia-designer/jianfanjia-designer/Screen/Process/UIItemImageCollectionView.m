//
//  UIItemImageCollectionView.m
//  jianfanjia
//
//  Created by Karos on 15/11/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UIItemImageCollectionView.h"
#import "ItemExpandImageCell.h"

@implementation UIItemImageCollectionView

- (CGSize)intrinsicContentSize {
    return self.viewContentSize;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:nil];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:nil];
    [super touchesEnded:touches withEvent:event];
}

@end
