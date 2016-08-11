//
//  DesignerInfoCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerInfoCell.h"

@interface DesignerInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgHandings;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starts;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;

@property (strong, nonatomic) Designer *designer;

@end

@implementation DesignerInfoCell

- (void)awakeFromNib {
    [self.btnAdd setCornerRadius:self.btnAdd.frame.size.height / 2.0];
    [self.btnAdd setBorder:2 andColor:[kThemeColor CGColor]];
    [self.designerImageView setCornerRadius:self.designerImageView.frame.size.width / 2.0];
    [self.designerImageView setBorder:1 andColor:[UIColor whiteColor].CGColor];
    [self.tagView setCornerRadius:self.tagView.frame.size.height / 2.0];
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    
    [self.designerImageView setUserImageWithId:designer.imageid];
    self.lblDesignerName.text = designer.username;
    self.lblViewCount.text = [designer.view_count humCountString];
    self.lblProductCount.text = [designer.authed_product_count stringValue];
    self.lblOrderCount.text = [designer.order_count stringValue];
    self.lblTag.text = [DesignerBusiness designerTagTextByArr:designer.tags];
    self.tagView.bgColor = [DesignerBusiness designerTagColorByArr:designer.tags];
    
    [self refreshAdd];
    
    double star = (self.designer.service_attitude.doubleValue + self.designer.respond_speed.doubleValue)/2;
    UIImage *full = [UIImage imageNamed:@"star_middle"];
    UIImage *empty = [UIImage imageNamed:@"star_middle_empty"];
    [DesignerBusiness setStars:self.starts withStar:star fullStar:full emptyStar:empty];
    [DesignerBusiness setV:self.vImageView withAuthType:designer.auth_type];
    
    BOOL isJiangXin = [DesignerBusiness containsJiangXinDingZhiTag:designer.tags];
    self.imgHandings.hidden = !isJiangXin;
    self.tagView.hidden = isJiangXin;
}

- (void)refreshAdd {
    if ([self.designer.is_my_favorite boolValue]) {
        [self.btnAdd setNormTitle:@"取消关注"];
        [self.btnAdd setBgColor:[UIColor clearColor]];
        [self.btnAdd setNormTitleColor:kThemeColor];
        self.imgAdd.hidden = YES;
    } else {
        [self.btnAdd setNormTitle:@"添加关注"];
        [self.btnAdd setBgColor:kThemeColor];
        [self.btnAdd setNormTitleColor:[UIColor whiteColor]];
        self.imgAdd.hidden = NO;
    }
}

- (IBAction)onClickAdd:(id)sender {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            [self addDesignerIntent];
        }
    }];
}

- (void)addDesignerIntent {
    if (self.designer && ![self.designer.is_my_favorite boolValue]) {
        AddFavoriateDesigner *request = [[AddFavoriateDesigner alloc] init];
        request._id = self.designer._id;
        @weakify(self);
        [API addFavoriateDesigner:request success:^{
            @strongify(self);
            self.designer.is_my_favorite = @YES;
            [self refreshAdd];
        } failure:^{
            
        } networkError:^{
            
        }];
    } else if (self.designer && [self.designer.is_my_favorite boolValue]) {
        DeleteFavoriteDesigner *request = [[DeleteFavoriteDesigner alloc] init];
        request._id = self.designer._id;
        @weakify(self);
        [API deleteFavoriateDesigner:request success:^{
            @strongify(self);
            self.designer.is_my_favorite = @NO;
            [self refreshAdd];
        } failure:^{
            
        } networkError:^{
            
        }];
    }
}

- (void)enableTransaparent:(BOOL)trans {
    if (trans) {
        self.bgColor = [UIColor clearColor];
        self.lblViewCount.textColor = [UIColor whiteColor];
        self.lblProductCount.textColor = [UIColor whiteColor];
        self.lblOrderCount.textColor = [UIColor whiteColor];
        self.lblDesignerName.textColor = [UIColor whiteColor];
        self.lblViewCountTitle.textColor = [UIColor whiteColor];
        self.lblProductCountTitle.textColor = [UIColor whiteColor];
        self.lblOrderCountTitle.textColor = [UIColor whiteColor];
    } else {
        self.bgColor = [UIColor whiteColor];
        self.lblViewCount.textColor = kThemeTextColor;
        self.lblProductCount.textColor = kThemeTextColor;
        self.lblOrderCount.textColor = kThemeTextColor;
        self.lblDesignerName.textColor = kThemeTextColor;
        self.lblViewCountTitle.textColor = kTextColor;
        self.lblProductCountTitle.textColor = kTextColor;
        self.lblOrderCountTitle.textColor = kTextColor;
    }
}

@end
