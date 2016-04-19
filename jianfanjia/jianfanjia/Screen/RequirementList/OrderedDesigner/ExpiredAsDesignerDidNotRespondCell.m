//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "ExpiredAsDesignerDidNotRespondCell.h"
#import "ViewControllerContainer.h"

@interface ExpiredAsDesignerDidNotRespondCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnReplace;

@property (weak, nonatomic) IBOutlet UIImageView *imgIdCardChecked;
@property (weak, nonatomic) IBOutlet UIImageView *imgBaseInfoChecked;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation ExpiredAsDesignerDidNotRespondCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
    [self.imgAvatar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDesignerAvatar)]];
    
    @weakify(self);
    [[self.btnReplace rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickReplaceButton];
    }];
}

- (void)initWithDesigner:(Designer *)designer withRequirement:(Requirement *)requirement withBlock:(PlanStatusRefreshBlock)refreshBlock {
    [super initWithDesigner:designer withRequirement:requirement withBlock:refreshBlock];
    [self initHeader:self.imgAvatar name:self.lblUserNameVal idCheck:self.imgIdCardChecked infoCheck:self.imgBaseInfoChecked stars:self.evaluatedStars];
    
    NSString *status = self.requirement.status;
    [StatusBlock matchReqt:status actions:
     @[[ReqtPlanWasChoosed action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormColor:kUntriggeredColor];
        }],
       [ReqtConfiguredAgreement action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormColor:kUntriggeredColor];
        }],
       [ReqtConfiguredWorkSite action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormColor:kUntriggeredColor];
        }],
       [ReqtFinishedWorkSite action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormColor:kUntriggeredColor];
        }],
       [ElseStatus action:^{
            self.btnReplace.enabled = YES;
            [self.btnReplace setNormColor:kThemeTextColor];
        }],
       ]];
}

- (void)onClickReplaceButton {
    [ViewControllerContainer showReplaceOrderedDesigner:self.designer._id forRequirement:self.requirement];
}

@end
