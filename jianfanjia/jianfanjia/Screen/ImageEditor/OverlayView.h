//
//  OverlayView.h
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView

@property (nonatomic, assign) BOOL gridHidden;

/**
 Shows and hides the interior grid lines
 */
- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated;


@end
