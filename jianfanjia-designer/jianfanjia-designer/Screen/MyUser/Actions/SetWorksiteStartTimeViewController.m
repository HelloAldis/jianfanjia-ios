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
    if ([self.requirement.status isEqualToString:kRequirementStatusPlanWasChoosedWithoutAgreement]) {
        self.title = @"设置开工时间";
    } else {
        self.title = @"合同概况";
    }
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickDismiss)];

    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUI {
    [self.btnOk setCornerRadius:5];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setMinimumDate:[NSDate date]];
    self.lblDateTime.text = [self.datePicker.date yyyy_Nian_MM_Yue_dd_Ri];
    self.lblProjectTotalDays.text = [NSString stringWithFormat:@"总工期：%@天,\n开工日期：%@年%@月%@日，\n竣工日期：%@年%@月%@日。", @"", @"", @"", @"", @"", @"", @""];
    self.lblProjectTotalPrice.text = [NSString stringWithFormat:@"本工程装修合同总价为人民币（大写）%@（%@元）。", @"", [self.requirement.total_price humRmbString]];
    ;
    self.lblProjectWorkType.text = [NSString stringWithFormat:@"%@（清包，半包，全包）。", [NameDict nameForWorkType:self.requirement.work_type]];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    NSDate *date = datePicker.date;
    self.lblDateTime.text = [date yyyy_Nian_MM_Yue_dd_Ri_HH_mm];
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
    DesignerRespondUser *request = [[DesignerRespondUser alloc] init];
    request.requirementid = self.requirement._id;
    request.house_check_time = @([self.datePicker.date timeIntervalSince1970] * 1000);
    
    [API designerRespondUser:request success:^{
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
