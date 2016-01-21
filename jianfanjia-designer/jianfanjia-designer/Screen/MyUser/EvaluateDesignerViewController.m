//
//  EvaluateDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "EvaluateDesignerViewController.h"

@interface EvaluateDesignerViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblEvaluateTitle;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *evaluatedStars;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *respondSpeedStars;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *serviceAttitudeStars;
@property (weak, nonatomic) IBOutlet UITextView *tvComment;

@property (strong, nonatomic) Evaluation *evaluation;
@property (strong, nonatomic) NSString *requirementid;
@property (assign, nonatomic) NSInteger respondSpeedStar;
@property (assign, nonatomic) NSInteger serviceAttitudeStar;

@end

@implementation EvaluateDesignerViewController

#pragma mark - init method
- (id)initWithEvaluation:(Evaluation *)evaluation  {
    if (self = [super init]) {
        _evaluation = evaluation;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNav];
    [self initUI];
    [self initData];
}

#pragma mark - init UI 
- (void)initUI {
    [self.imgAvatar setCornerRadius:30];
    [self.tvComment setCornerRadius:5];
    self.lblEvaluateTitle.hidden = YES;
    self.tvComment.editable = NO;
    self.tvComment.backgroundColor = self.view.backgroundColor;
}

- (void)initData {
    [self.imgAvatar setImageWithId:[GVUserDefaults standardUserDefaults].imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = [GVUserDefaults standardUserDefaults].username;
    [DesignerBusiness setStars:self.evaluatedStars withStar:(double)([GVUserDefaults standardUserDefaults].respond_speed.doubleValue + [GVUserDefaults standardUserDefaults].service_attitude.doubleValue) / 2 fullStar:[UIImage imageNamed:@"star_middle"] emptyStar:[UIImage imageNamed:@"star_middle_empty"]];
    [DesignerBusiness setV:self.authIcon withAuthType:[GVUserDefaults standardUserDefaults].auth_type];
    
    [DesignerBusiness displayStars:self.respondSpeedStars withAmount:self.evaluation.respond_speed.integerValue withStar:[UIImage imageNamed:@"star_big"]];
    [DesignerBusiness displayStars:self.serviceAttitudeStars withAmount:self.evaluation.service_attitude.integerValue withStar:[UIImage imageNamed:@"star_big"]];
    self.tvComment.text = self.evaluation.comment;
}

#pragma mark - init nav
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"业主的评价";
}

@end
