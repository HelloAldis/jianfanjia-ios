//
//  CustomAlertViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "SetMeasureHouseTimeViewController.h"

@interface SetMeasureHouseTimeViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (strong, nonatomic) Requirement *requirement;
@property (copy, nonatomic) MeasureHouseCompletionBlock completion;

@end

@implementation SetMeasureHouseTimeViewController

+ (void)showSetMeasureHouseTime:(Requirement *)requirement completion:(MeasureHouseCompletionBlock)completion {
    SetMeasureHouseTimeViewController *alert = [[SetMeasureHouseTimeViewController alloc] initWithRequirement:requirement completion:completion];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alert];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (id)initWithRequirement:(Requirement *)requirement completion:(MeasureHouseCompletionBlock)completion {
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
    self.title = @"设置量房时间";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_delete"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickDismiss)];

    NSDictionary * dict = [NSDictionary dictionaryWithObject:kThemeTextColor forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUI {
    [self.btnPhone setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnPhone setCornerRadius:5];
    [self.btnOk setCornerRadius:5];
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    NSDate *now = [self getNowDate];
    [self.datePicker setMinimumDate:now];
    self.lblDateTime.text = [self.datePicker.date yyyy_Nian_MM_Yue_dd_Ri_HH_mm];
    self.lblPhone.text = self.requirement.user.phone;
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    NSDate *date = datePicker.date;
    self.lblDateTime.text = [date yyyy_Nian_MM_Yue_dd_Ri_HH_mm];
}

#pragma mark - util
- (NSDate *)getNowDate {
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:now];
    NSInteger minute = components.minute;
    NSInteger second = components.second;
    minute = 10 - minute % 10;
    
    now = [cal dateByAddingUnit:NSCalendarUnitMinute value:minute toDate:now options:0];
    now = [cal dateByAddingUnit:NSCalendarUnitSecond value:-second toDate:now options:0];
    
    return now;
}

#pragma mark - user actions 
- (IBAction)onClickPhone:(id)sender {
    [PhoneUtil call:self.requirement.user.phone];
}

- (void)onClickDismiss {
    if (self.completion) {
        self.completion(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickOk:(id)sender  {
    NSDate *now = [self getNowDate];
    NSDate *selectedDate = self.datePicker.date;
    if ([self.datePicker.date compare:now] == NSOrderedAscending) {
        selectedDate = now;
    }
    
    [HUDUtil showWait];
    DesignerRespondUser *request = [[DesignerRespondUser alloc] init];
    request.requirementid = self.requirement._id;
    request.house_check_time = @([selectedDate getLongMilSecond]);
    
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
