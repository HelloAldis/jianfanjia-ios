//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCell.h"
#import "ViewControllerContainer.h"
#import "DesignerPageData.h"

typedef enum {
    Unorder = -1,
    OrderedWithoutResponse,

} PlanStatus;

@interface RequirementCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgHomeOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblCellNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblPubulishTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateTimeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnEditRequirement;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *designerAvatar;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *authIcon;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *designerName;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *designerStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnGoToWorkspace;

@property (strong, nonatomic) NSMutableArray *currentStatus;
@property (strong, nonatomic) DesignerPageData *designerPageData;
@property (strong, nonatomic) Requirement *requirement;

@end

@implementation RequirementCell

- (void)awakeFromNib {
    self.designerPageData = [[DesignerPageData alloc] init];
    self.currentStatus = [[NSMutableArray alloc] initWithCapacity:self.designerAvatar.count];
    for (id obj in self.designerAvatar) {
        [self.currentStatus addObject:[NSNumber numberWithInt:Unorder]];
    }
    
    for (UIImageView *imageView in self.designerAvatar) {
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDesignerAvatar:)];
        [imageView setCornerRadius:30];
        [imageView addGestureRecognizer:gesture];
    }
}

- (void)initWithRequirement:(Requirement *)requirement {
    self.requirement = requirement;
    @weakify(self);
    [requirement.order_designerids enumerateObjectsUsingBlock:^(NSString*  _Nonnull designerId, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            DesignerHomePage *request = [[DesignerHomePage alloc] init];
            request._id = designerId;
            
            [API designerHomePage:request success:^{
                @strongify(self);
                [self.designerPageData refreshDesigner];
                UIImageView *imgView = self.designerAvatar[idx];
                [imgView setImageWithId:self.designerPageData.designer.imageid withWidth:kScreenWidth];
                
                UILabel *lblName = self.designerName[idx];
                lblName.text = self.designerPageData.designer.username;
                
                UILabel *lblStatus = self.designerStatus[idx];
                [self updateStatus:lblStatus withPlan:nil withIndex:idx];
            } failure:^{
                
            }];
        });
        
    }];
}

- (void)tapDesignerAvatar:(UIGestureRecognizer*)gestureRecognizer {
    NSInteger touchedIndex = -1;
    for (UIImageView *imageView in self.designerAvatar) {
        if (gestureRecognizer.view == imageView) {
            touchedIndex++;
            break;
        }
    }
    
    if (touchedIndex == -1) {
        return;
    }
    
    
    
    [ViewControllerContainer showOrderDesigner:nil];
}

/**
   预约方案状态 plan status
 * 0. 已预约但没有响应
 * 1. 已拒绝业主
 * 7. 设计师无响应导致响应过期
 * 2. 已响应但是没有确认量房
 * 6. 已确认量房但是没有方案
 * 8. 设计师规定时间内没有上场方案，过期
 * 3. 提交了方案
 * 4. 方案被未中标
 * 5. 方案被选中
 **/

- (void)updateStatus:(UILabel *)lblStatus withPlan:(id)plan withIndex:(NSInteger)index {
    lblStatus.text = @"未预约";
}

@end
