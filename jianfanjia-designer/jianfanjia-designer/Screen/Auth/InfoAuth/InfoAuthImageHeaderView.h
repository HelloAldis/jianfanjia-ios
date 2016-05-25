//
//  ProductAuthImageHeaderView.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInfoAuthImageHeaderViewHeight 36

@interface InfoAuthImageHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

+ (InfoAuthImageHeaderView *)infoAuthImageHeaderView;

@end
