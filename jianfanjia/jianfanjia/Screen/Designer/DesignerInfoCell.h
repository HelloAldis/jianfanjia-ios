//
//  DesignerInfoCell.h
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDesignerInfoCellHeight 294

@interface DesignerInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignerName;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCountTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderCountTitle;

- (void)initWithDesigner:(Designer *)designer;
- (void)enableTransaparent:(BOOL)trans;

@end
