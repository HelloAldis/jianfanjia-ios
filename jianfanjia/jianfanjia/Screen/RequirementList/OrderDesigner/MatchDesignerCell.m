//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MatchDesignerCell.h"
#import "ViewControllerContainer.h"

@interface MatchDesignerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblMatchVal;
@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;

@end

@implementation MatchDesignerCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.imgCheck.image = [UIImage imageNamed:@"checked"];
    } else {
        self.imgCheck.image = [UIImage imageNamed:@"unchecked"];
    }
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = designer.username;
    self.lblMatchVal.text = [NSString stringWithFormat:@"%@%%", designer.match];
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_type];
}

- (void)onClickDesignerAvatar {
    [ViewControllerContainer showDesigner:self.designer._id];
}

@end
