//
//  SelectionEditCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat kAvtarInfoCellHeight;

@interface AvtarInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

- (void)initUI;

@end
