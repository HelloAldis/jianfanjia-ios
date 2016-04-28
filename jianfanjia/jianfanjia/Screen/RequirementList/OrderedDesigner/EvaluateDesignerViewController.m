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
        _type = designer.evaluation._id ? View : New;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
        @strongify(self);
        if (isShowing) {
            CGFloat keyboardHeight = keyboardRect.size.height;
            self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, keyboardHeight, 0);
            self.scrollView.contentOffset = CGPointMake(0, keyboardHeight-kNavWithStatusBarHeight);
        } else {
            self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
        }
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jfj_unsubscribeKeyboard];
}

#pragma mark - init UI 
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.imgAvatar setCornerRadius:30];
    [self.tvComment setCornerRadius:5];
    [self.btnPublish setCornerRadius:5];
    
    [self.imgAvatar setImageWithId:self.designer.imageid withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = self.designer.username;
    [DesignerBusiness setStars:self.evaluatedStars withStar:(double)(self.designer.respond_speed.doubleValue + self.designer.service_attitude.doubleValue) / 2 fullStar:[UIImage imageNamed:@"star_middle"] emptyStar:[UIImage imageNamed:@"star_middle_empty"]];
    [DesignerBusiness setV:self.authIcon withAuthType:self.designer.auth_type];
    
    if (self.type == New) {
        self.respondSpeedStar = 0;
        self.serviceAttitudeStar = 0;
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self, respondSpeedStar), RACObserve(self, serviceAttitudeStar)]
            reduce:^id(NSNumber *respondSpeedStar, NSNumber *serviceAttitudeStar){
              return @([respondSpeedStar integerValue] > 0 && [serviceAttitudeStar integerValue] > 0);
            }]
            subscribeNext:^(id x) {
                @strongify(self);
                if ([x boolValue]) {
                    self.btnPublish.enabled = YES;
                    self.btnPublish.backgroundColor = kFinishedColor;
                } else {
                    self.btnPublish.enabled = NO;
                    self.btnPublish.backgroundColor = kUntriggeredColor;
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
        [DesignerBusiness displayStars:self.respondSpeedStars withAmount:self.designer.evaluation.respond_speed.integerValue fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
        [DesignerBusiness displayStars:self.serviceAttitudeStars withAmount:self.designer.evaluation.service_attitude.integerValue fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
        
        self.btnPublish.hidden = YES;
        self.lblEvaluateTitle.hidden = YES;
        self.tvComment.editable = NO;
        self.tvComment.bgColor = self.view.bgColor;
        self.tvComment.text = self.designer.evaluation.comment;
    }
}

#pragma mark - init nav
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"评价设计师";
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
    
    } networkError:^{
        
    }];
}

- (void)onClickRespondSpeedStar:(UIGestureRecognizer *)gesture {
    self.respondSpeedStar = [DesignerBusiness setStars:self.respondSpeedStars withTouchStar:(UIImageView *)gesture.view fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
}

- (void)onClickServiceAttitudeStar:(UIGestureRecognizer *)gesture {
    self.serviceAttitudeStar = [DesignerBusiness setStars:self.serviceAttitudeStars withTouchStar:(UIImageView *)gesture.view fullStar:[UIImage imageNamed:@"star_big"] emptyStar:[UIImage imageNamed:@"star_big_empty"]];
}

@end
