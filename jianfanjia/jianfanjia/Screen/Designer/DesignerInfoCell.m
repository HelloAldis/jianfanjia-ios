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
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignerName;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starts;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (weak, nonatomic) Designer *designer;

@end

@implementation DesignerInfoCell

- (void)awakeFromNib {
    [self.btnAdd setCornerRadius:5];
    [self.btnAdd setBorder:2 andColor:[kThemeColor CGColor]];
    [self.designerImageView setCornerRadius:30];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    
    [self.designerImageView setUserImageWithId:designer.imageid];
    self.lblDesignerName.text = designer.username;
    self.lblViewCount.text = [designer.view_count stringValue];
    self.lblProductCount.text = [designer.authed_product_count stringValue];
    self.lblOrderCount.text = [designer.order_count stringValue];
    
    [self refreshAdd];
    
    double star = (self.designer.service_attitude.doubleValue + self.designer.respond_speed.doubleValue)/2;
    UIImage *full = [UIImage imageNamed:@"star_middle"];
    UIImage *empty = [UIImage imageNamed:@"star_middle_empty"];
    [DesignerBusiness setStars:self.starts withStar:star fullStar:full emptyStar:empty];
}

- (void)refreshAdd {
    if ([self.designer.is_my_favorite boolValue]) {
        [self.btnAdd setTitle:@"取消意向" forState:UIControlStateNormal];
        self.btnAdd.backgroundColor = [UIColor whiteColor];
        [self.btnAdd setTitleColor:kThemeColor forState:UIControlStateNormal];
    } else {
        [self.btnAdd setTitle:@"添加意向" forState:UIControlStateNormal];
        self.btnAdd.backgroundColor = kThemeColor;
        [self.btnAdd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

@end
