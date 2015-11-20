//
//  EvaluateDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "EvaluateDesignerViewController.h"

typedef NS_ENUM(NSInteger, EvaluateDesignerType) {
    View,
    New
};

@interface EvaluateDesignerViewController ()
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
@property (strong, nonatomic) NSString *requirementid;
@property (assign, nonatomic) NSInteger respondSpeedStar;
@property (assign, nonatomic) EvaluateDesignerType type;
@property (assign, nonatomic) NSInteger serviceAttitudeStar;

@end

@implementation EvaluateDesignerViewController

#pragma mark - init method
- (id)initWithDesigner:(Designer *)designer withRequirment:(NSString *)requirementid {
    if (self = [super init]) {
        _designer = designer;
        _requirementid = requirementid;
        _type = designer.evaluation ? View : New;
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
    [self.btnPublish setCornerRadius:5];
    
    [self.imgAvatar setImageWithId:self.designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = self.designer.username;
    [DesignerBusiness setStars:self.evaluatedStars withStar:(double)(self.designer.respond_speed.doubleValue + self.designer.service_attitude.doubleValue) / 2 fullStar:[UIImage imageNamed:@"star_middle"] emptyStar:[UIImage imageNamed:@"star_middle_empty"]];
    
    if (self.type == New) {
        @weakify(self);
        [[self.tvComment.rac_textSignal
          filterNonSpace:^BOOL{
              return YES;
          }]
         subscribeNext:^(NSString *value) {
             @strongify(self);
             if (value.length > 0) {
                 self.btnPublish.enabled = YES;
                 self.btnPublish.alpha = 1;
             } else {
                 self.btnPublish.enabled = NO;
                 self.btnPublish.alpha = 0.5;
             }
         }];
        
        [[self.btnPublish rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self onClickPublishBtn];
        }];
        
        [self.respondSpeedStars enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickRespondSpeedStar:)]];
        }];
        
        [self.serviceAttitudeStars enumerateObjectsUsingBlock:^(UIImageView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            [obj addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickServiceAttitudeStar:)]];
        }];
    } else {
        [DesignerBusiness displayStars:self.respondSpeedStars withAmount:self.designer.evaluation.respond_speed.integerValue withStar:[UIImage imageNamed:@"star_big"]];
        [DesignerBusiness displayStars:self.serviceAttitudeStars withAmount:self.designer.evaluation.service_attitude.integerValue withStar:[UIImage imageNamed:@"star_big"]];
        
        self.btnPublish.hidden = YES;
        self.lblEvaluateTitle.hidden = YES;
        self.tvComment.editable = NO;
        self.tvComment.backgroundColor = [UIColor colorWithR:0xED g:0xEF b:0xF1];
    }
}

#pragma mark - init nav
- (void)initNav {
    [self initLeftBackInNav];
}

#pragma mark - user action
- (void)onClickPublishBtn {
    EvaluateDesigner *request = [[EvaluateDesigner alloc] init];
    request.designerid = self.designer._id;
    request.requirementid = self.requirementid;
    request.respond_speed = [NSNumber numberWithInteger:self.respondSpeedStar];
    request.service_attitude = [NSNumber numberWithInteger:self.serviceAttitudeStar];
    request.comment = self.tvComment.text;
    request.is_anonymous = @"0";
    
    [API evaluateDesigner:request success:^{
        [self clickBack];
    } failure:^{
    
    }];
}

- (void)onClickRespondSpeedStar:(UIGestureRecognizer *)gesture {
    self.respondSpeedStar = [DesignerBusiness setStars:self.respondSpeedStars withTouchStar:(UIImageView *)gesture.view fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
}

- (void)onClickServiceAttitudeStar:(UIGestureRecognizer *)gesture {
    self.serviceAttitudeStar = [DesignerBusiness setStars:self.serviceAttitudeStars withTouchStar:(UIImageView *)gesture.view fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
}

@end
