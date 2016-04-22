//
//  EvaluateDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "EvaluateDesignerViewController.h"

@interface EvaluateDesignerViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblEvaluateTitle;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *respondSpeedStars;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *serviceAttitudeStars;
@property (weak, nonatomic) IBOutlet UITextView *tvComment;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) Evaluation *evaluation;

@end

@implementation EvaluateDesignerViewController

#pragma mark - init method
- (id)initWithDesigner:(Designer *)designer evaluation:(Evaluation *)evaluation  {
    if (self = [super init]) {
        _designer = designer;
        _evaluation = evaluation;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - init UI 
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.imgAvatar setCornerRadius:30];
    [self.tvComment setCornerRadius:5];
    self.lblEvaluateTitle.hidden = YES;
    self.tvComment.editable = NO;
    self.tvComment.backgroundColor = self.view.backgroundColor;
    
    [GVUserDefaults standardUserDefaults].imageid = self.designer.imageid;
    [GVUserDefaults standardUserDefaults].username = self.designer.username;
    [GVUserDefaults standardUserDefaults].respond_speed = self.designer.respond_speed;
    [GVUserDefaults standardUserDefaults].service_attitude = self.designer.service_attitude;
}

- (void)initData {
    [self.imgAvatar setImageWithId:[GVUserDefaults standardUserDefaults].imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = [GVUserDefaults standardUserDefaults].username;
    [DesignerBusiness setStars:self.evaluatedStars withStar:(double)([GVUserDefaults standardUserDefaults].respond_speed.doubleValue + [GVUserDefaults standardUserDefaults].service_attitude.doubleValue) / 2 fullStar:[UIImage imageNamed:@"star_middle"] emptyStar:[UIImage imageNamed:@"star_middle_empty"]];
    [DesignerBusiness setV:self.authIcon withAuthType:[GVUserDefaults standardUserDefaults].auth_type];
    
    [DesignerBusiness displayStars:self.respondSpeedStars withAmount:self.evaluation.respond_speed.integerValue fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
    [DesignerBusiness displayStars:self.serviceAttitudeStars withAmount:self.evaluation.service_attitude.integerValue fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
    
    self.lblEvaluateTitle.hidden = YES;
    self.btnPublish.hidden = YES;
    self.tvComment.editable = NO;
    self.tvComment.bgColor = self.view.bgColor;
    
    if (self.evaluation.comment) {
        self.tvComment.text = self.evaluation.comment;
    } else {
        self.tvComment.text = @"业主还没有对您进行评价";
        self.tvComment.font = [UIFont systemFontOfSize:16];
        self.tvComment.textAlignment = NSTextAlignmentCenter;
    }
}

#pragma mark - init nav
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"评价详情";
}

@end
