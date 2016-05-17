//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SetWorksiteStartTimeViewController.h"

@interface SetWorksiteStartTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectTotalDays;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectWorkType;
@property (weak, nonatomic) IBOutlet UIView *headerLine;

@property (strong, nonatomic) Requirement *requirement;
@property (copy, nonatomic) WorksiteStartCompletionBlock completion;

@end

@implementation SetWorksiteStartTimeViewController

+ (void)showSetMeasureHouseTime:(Requirement *)requirement completion:(WorksiteStartCompletionBlock)completion {
    SetWorksiteStartTimeViewController *alert = [[SetWorksiteStartTimeViewController alloc] initWithRequirement:requirement completion:completion];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alert];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (id)initWithRequirement:(Requirement *)requirement completion:(WorksiteStartCompletionBlock)completion {
    if (self = [super init]) {
        _requirement = requirement;
        _completion = completion;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - init UI
- (void)initNav {
    [StatusBlock matchReqt:self.requirement.status actions:
     @[[ReqtPlanWasChoosed action:^{
            self.title = @"设置开工时间";
        }],
       [ElseStatus action:^{
            self.title = @"合同概况";
        }]
       ]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickDismiss)];

    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUI {
    [self.btnOk setCornerRadius:5];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setMinimumDate:[self getMinDate]];
    self.lblDateTime.text = [self.datePicker.date yyyy_Nian_MM_Yue_dd_Ri];
    self.lblProjectTotalPrice.text = [NSString stringWithFormat:@"本工程装修合同总价为人民币 (大写) %@ (%@元)。", [self.requirement.plan.total_price humRmbUppercaseString], [self.requirement.plan.total_price humRmbString]];
    ;
    self.lblProjectWorkType.text = [NSString stringWithFormat:@"%@", [NameDict nameForWorkType:self.requirement.work_type]];
    
    NSNumber *worksiteStartTime = self.requirement.start_at;
    NSDate *startDate;
    if (worksiteStartTime) {
        startDate = [NSDate dateWithTimeIntervalSince1970:[worksiteStartTime doubleValue] / 1000];
    } else {
        startDate = self.datePicker.date;
    }
    
    [self updateProjectTotalDay:startDate];
    
    if (worksiteStartTime) {
        self.btnOk.hidden = YES;
        self.lblDateTime.hidden = YES;
        self.datePicker.hidden = YES;
        self.headerLine.hidden = YES;
    } else {
        self.btnOk.hidden = NO;
        self.lblDateTime.hidden = NO;
        self.datePicker.hidden = NO;
        self.headerLine.hidden = NO;
    }
}

- (NSDate *)getMinDate {
    NSDate *minDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    minDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:minDate options:0];
    
    return minDate;
}

- (void)updateProjectTotalDay:(NSDate *)startDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:startDate];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:self.requirement.plan.duration.integerValue toDate:startDate options:0];
    NSDateComponents *endComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:endDate];
    
    self.lblProjectTotalDays.text = [NSString stringWithFormat:@"总工期：%@天,\n开工日期：%@年%@月%@日，\n竣工日期：%@年%@月%@日。", self.requirement.plan.duration, @(startComponents.year), @(startComponents.month), @(startComponents.day), @(endComponents.year), @(endComponents.month), @(endComponents.day)];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    NSDate *date = datePicker.date;
    self.lblDateTime.text = [date yyyy_Nian_MM_Yue_dd_Ri];
    [self updateProjectTotalDay:date];
}

#pragma mark - user actions
- (void)onClickDismiss {
    if (self.completion) {
        self.completion(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickOk:(id)sender  {
    [HUDUtil showWait];
    DesignerConfigAgreement *request = [[DesignerConfigAgreement alloc] init];
    request.requirementid = self.requirement._id;
    request.start_at = @([self.datePicker.date getLongMilSecond]);
    
    [API designerConfigAgreement:request success:^{
        [HUDUtil hideWait];
        if (self.completion) {
            self.completion(YES);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^{
        [HUDUtil hideWait];
        [HUDUtil showErrText:[DataManager shared].errMsg];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

@end
