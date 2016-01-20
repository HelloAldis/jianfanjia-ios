//
//  ItemsBackgroundView.h
//  jianfanjia
//
//  Created by Karos on 15/12/16.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsBackgroundView : UIView
@property (weak, nonatomic) IBOutlet UIView *statusLine;

+ (ItemsBackgroundView *)itemsBackgroundView;

@end
