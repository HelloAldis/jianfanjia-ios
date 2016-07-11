//
//  DesignerInfoCell.m
//  jianfanjia
//
//  Created by JYZ on 15/11/5.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TaggedDesignerInfoView.h"
#import "ViewControllerContainer.h"

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
@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) NSArray *designers;
@property (copy, nonatomic) void (^done)(NSString * designerid);

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
    [self setBorder:0.5 andColor:[UIColor colorWithR:0xE6 g:0xE7 b:0xE8].CGColor];
    [self.btnAdd setCornerRadius:self.btnAdd.frame.size.height / 2.0];
    [self.btnAdd setBorder:2 andColor:[kThemeColor CGColor]];
    [self.designerImageView setCornerRadius:self.designerImageView.frame.size.height / 2.0];
    [self.designerImageView setBorder:1 andColor:[UIColor whiteColor].CGColor];
    self.backgroundImageView.clipsToBounds = YES;
    
    [self.backgroundImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackground:)]];
    [self.designerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTabDesignerAvatar:)]];
}

#pragma mark - init data
- (void)initWithDoneBlock:(void (^)(NSString * designerid))block {
    self.done = block;
}

- (void)initWithDesigner:(Designer *)designer {
    self.designer = designer;
    
    [self showBackground:designer];
    [self.designerImageView setUserImageWithId:designer.imageid];
    self.lblDesignerName.text = designer.username;
    self.lblViewCount.text = [designer.view_count humCountString];
    self.lblProductCount.text = [designer.authed_product_count stringValue];
    self.lblOrderCount.text = [designer.order_count stringValue];
    
    double star = (self.designer.service_attitude.doubleValue + self.designer.respond_speed.doubleValue)/2;
    UIImage *full = [UIImage imageNamed:@"star_middle"];
    UIImage *empty = [UIImage imageNamed:@"star_middle_empty"];
    [DesignerBusiness setStars:self.starts withStar:star fullStar:full emptyStar:empty];
    [DesignerBusiness setV:self.vImageView withAuthType:designer.auth_type];
}

- (void)showBackground:(Designer *)designer {
    NSArray *arr = [designer.data objectForKey:@"products"];
    NSMutableArray *products = [[NSMutableArray alloc] initWithCapacity:arr.count];
    
    for (NSMutableDictionary *dict in arr) {
        Product *product = [[Product alloc] initWith:dict];
        [products addObject:product];
    }
    
    if (products.count > 0) {
        self.product = products[0];
        ProductImage *image = [self.product imageAtIndex:0];
        [self.backgroundImageView setImageWithId:image.imageid withWidth:kScreenWidth];
    }
}

- (IBAction)onClickOrder:(id)sender {
    if (self.done) {
        self.done(self.designer._id);
    }
}

- (void)onTapBackground:(UIGestureRecognizer *)g {
    [ViewControllerContainer showProduct:self.product._id];
}

- (void)onTabDesignerAvatar:(UIGestureRecognizer *)g {
    [ViewControllerContainer showDesigner:self.designer._id];
}

#pragma mark - reload data
- (void)reloadData:(ReuseScrollView *)scrollView item:(id)item {
    if (self.page == self.curPage + 1 || self.page == self.curPage - 1 || self.page == self.curPage) {
        [self initWithDesigner:item];
        [self playAnimation:scrollView];
    }
}

- (void)playAnimation:(ReuseScrollView *)scrollView {
    const CGFloat deltaH = 55;

    CGFloat pageSize = scrollView.cellSize.width;
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat origin = self.frame.origin.x;
    CGFloat delta = fabs(origin - offset);
    CGFloat deltaFactor = delta / pageSize / 2;
    
    CGRect originFrame = [scrollView getOriginCellFrame:self.page];
    CGRect frame = CGRectMake(originFrame.origin.x, originFrame.origin.y + deltaH * deltaFactor / 2, originFrame.size.width, originFrame.size.height - deltaH * deltaFactor);
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

@end
