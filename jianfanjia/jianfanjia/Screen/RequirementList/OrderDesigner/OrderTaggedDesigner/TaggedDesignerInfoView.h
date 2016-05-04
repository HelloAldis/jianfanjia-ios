//
//  DesignerInfoCell.h
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReuseScrollView.h"

@interface TaggedDesignerInfoView : ReuseCell

+ (TaggedDesignerInfoView *)taggedDesignerInfoView;

- (void)initWithDesigner:(Designer *)designer;

@end
