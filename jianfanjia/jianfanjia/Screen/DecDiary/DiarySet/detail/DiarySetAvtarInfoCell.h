//
//  SelectionEditCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat kDiarySetAvtarInfoCellHeight;

@interface DiarySetAvtarInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *avtarView;
@property (weak, nonatomic) IBOutlet UIImageView *diarySetBGImgView;
@property (strong, nonatomic) CAGradientLayer *gradient;

- (void)initWithDiarySet:(DiarySet *)diarySet tableView:(UITableView *)tableView;
- (void)updateSubViewsAlpha:(CGFloat)alpha;

@end
