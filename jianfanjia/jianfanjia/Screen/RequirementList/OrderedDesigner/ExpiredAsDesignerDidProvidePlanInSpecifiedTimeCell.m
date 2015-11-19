//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ExpiredAsDesignerDidProvidePlanInSpecifiedTimeCell.h"

@interface ExpiredAsDesignerDidProvidePlanInSpecifiedTimeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnReplace;

@end

@implementation ExpiredAsDesignerDidProvidePlanInSpecifiedTimeCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
    [self.btnReplace setCornerRadius:5];
    [self.btnReplace setBorder:1 andColor:[UIColor colorWithR:0xFE g:0x70 b:0x04].CGColor];
    
    @weakify(self);
    [[self.btnReplace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickButton];
    }];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self.imgAvatar setImageWithId:designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = designer.username;
    [DesignerBusiness setV:self.authIcon withAuthType:designer.auth_Type];
}

- (void)onClickButton {
    
}


@end
