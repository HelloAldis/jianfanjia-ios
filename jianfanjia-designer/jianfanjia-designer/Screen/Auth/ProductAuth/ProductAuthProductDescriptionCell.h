//
//  ProductAuthProductDescriptionCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProductAuthProductDescriptionCellHeight 230

@interface ProductAuthProductDescriptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *tvDesc;

- (void)initWithProduct:(Product *)product;

@end
