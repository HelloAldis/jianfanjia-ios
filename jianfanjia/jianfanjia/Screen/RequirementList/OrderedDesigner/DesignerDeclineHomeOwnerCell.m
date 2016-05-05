//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerDeclineHomeOwnerCell.h"
#import "ViewControllerContainer.h"

@interface DesignerDeclineHomeOwnerCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UIButton *btnReplace;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *vImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;

@end

@implementation DesignerDeclineHomeOwnerCell

- (void)awakeFromNib {
    [self.tagView setCornerRadius:self.tagView.bounds.size.height / 2];
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
    [self initHeader:self.imgAvatar name:self.lblUserNameVal tagView:self.tagView lblTag:self.lblTag infoCheck:self.vImage stars:self.evaluatedStars];
    
    NSString *status = self.requirement.status;
    [StatusBlock matchReqt:status actions:
     @[[ReqtPlanWasChoosed action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormTitleColor:kUntriggeredColor];
        }],
       [ReqtConfiguredAgreement action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormTitleColor:kUntriggeredColor];
        }],
       [ReqtConfiguredWorkSite action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormTitleColor:kUntriggeredColor];
        }],
       [ReqtFinishedWorkSite action:^{
            self.btnReplace.enabled = NO;
            [self.btnReplace setNormTitleColor:kUntriggeredColor];
        }],
       [ElseStatus action:^{
            self.btnReplace.enabled = YES;
            [self.btnReplace setNormTitleColor:kThemeTextColor];
        }],
       ]];
}

- (void)onClickReplaceButton {
    [ViewControllerContainer showReplaceOrderedDesigner:self.designer._id forRequirement:self.requirement];
}

@end
