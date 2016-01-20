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

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) NSString *requirementid;
@property (assign, nonatomic) NSInteger respondSpeedStar;
@property (assign, nonatomic) NSInteger serviceAttitudeStar;

@end

@implementation EvaluateDesignerViewController

#pragma mark - init method
- (id)initWithDesigner:(Designer *)designer withRequirment:(NSString *)requirementid {
    if (self = [super init]) {
        _designer = designer;
        _requirementid = requirementid;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNav];
    [self initUI];
}

#pragma mark - init UI 
- (void)initUI {
    [self.imgAvatar setCornerRadius:30];
    [self.tvComment setCornerRadius:5];
    
    [self.imgAvatar setImageWithId:self.designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = self.designer.username;
    [DesignerBusiness setStars:self.evaluatedStars withStar:(double)(self.designer.respond_speed.doubleValue + self.designer.service_attitude.doubleValue) / 2 fullStar:[UIImage imageNamed:@"star_middle"] emptyStar:[UIImage imageNamed:@"star_middle_empty"]];
    [DesignerBusiness setV:self.authIcon withAuthType:self.designer.auth_type];
    
    [DesignerBusiness displayStars:self.respondSpeedStars withAmount:self.designer.evaluation.respond_speed.integerValue withStar:[UIImage imageNamed:@"star_big"]];
    [DesignerBusiness displayStars:self.serviceAttitudeStars withAmount:self.designer.evaluation.service_attitude.integerValue withStar:[UIImage imageNamed:@"star_big"]];
    
    self.lblEvaluateTitle.hidden = YES;
    self.tvComment.editable = NO;
    self.tvComment.backgroundColor = self.view.backgroundColor;
    self.tvComment.text = self.designer.evaluation.comment;
}

#pragma mark - init nav
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"评价设计师";
}

@end
