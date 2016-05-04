//
//  DesignerInfoCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TaggedDesignerInfoView.h"

@interface TaggedDesignerInfoView ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *designerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderCount;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignerName;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starts;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) NSArray *designers;

@end

@implementation TaggedDesignerInfoView

+ (TaggedDesignerInfoView *)taggedDesignerInfoView {
    TaggedDesignerInfoView *obj = [[[NSBundle mainBundle] loadNibNamed:@"TaggedDesignerInfoView" owner:nil options:nil] lastObject];
    [obj initUI];
    
    return obj;
}

#pragma mark - init ui
- (void)initUI {
    [self setCornerRadius:5];
    [self setBorder:1 andColor:[UIColor colorWithR:0xCB g:0xCC b:0xCD].CGColor];
    [self.btnAdd setCornerRadius:self.btnAdd.frame.size.height / 2.0];
    [self.btnAdd setBorder:2 andColor:[kThemeColor CGColor]];
    [self.designerImageView setCornerRadius:self.designerImageView.frame.size.height / 2.0];
    self.backgroundImageView.clipsToBounds = YES;
}

#pragma mark - init data
- (void)initWithDesigners:(NSArray *)designers {
    self.designers = designers;
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    
    [self showBackground:designer];
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

- (void)showBackground:(Designer *)designer {
    NSArray *arr = [designer.data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Product *product = [[Product alloc] initWith:dict];
        [products addObject:product];
    }
    
    if (products.count > 0) {
        ProductImage *image = [products[0] imageAtIndex:0];
        [self.backgroundImageView setImageWithId:image.imageid withWidth:self.frame.size.width];
    }
}

- (void)refreshAdd {
    if ([self.designer.is_my_favorite boolValue]) {
        [self.btnAdd setNormTitle:@"取消意向"];
        [self.btnAdd setBgColor:[UIColor whiteColor]];
        [self.btnAdd setNormTitleColor:kThemeColor];
    } else {
        [self.btnAdd setNormTitle:@"添加意向"];
        [self.btnAdd setBgColor:kThemeColor];
        [self.btnAdd setNormTitleColor:[UIColor whiteColor]];
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

#pragma mark - reload data
- (void)reloadData:(ReuseScrollView *)scrollView {
    [self initWithDesigner:self.designers[self.page]];
    [self playAnimation:scrollView];
}

- (void)playAnimation:(ReuseScrollView *)scrollView {
    const CGFloat deltaW = 30;
    const CGFloat deltaH = 60;
    
    CGFloat pageSize = scrollView.cellSize.width;
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat origin = self.frame.origin.x;
    CGFloat delta = fabs(origin - offset);
    CGFloat deltaFactor = delta / pageSize;
    
    CGRect originFrame = [scrollView getOriginCellFrame:self.page];
    CGRect frame = CGRectMake(originFrame.origin.x + deltaW * deltaFactor / 2, originFrame.origin.y + deltaH * deltaFactor / 2, originFrame.size.width - deltaW * deltaFactor, originFrame.size.height - deltaH * deltaFactor);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

@end
