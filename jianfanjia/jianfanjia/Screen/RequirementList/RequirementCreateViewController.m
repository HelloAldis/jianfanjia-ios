//
//  RequirementCreateViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCreateViewController.h"
#import "SelectCityViewController.h"

@interface RequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCity;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCityVal;

@end

@implementation RequirementCreateViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


#pragma mark - UI
- (void)initUI {
    [[self.btnSelectCity rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        SelectCityViewController *cityController = [[SelectCityViewController alloc] init];
        [self.navigationController pushViewController:cityController animated:YES];
    }];
    
    RAC(self.lblSelectCityVal, text) = [RACSignal
                                        combineLatest:@[RACObserve([DataManager shared], selectedProvince), RACObserve([DataManager shared], selectedCity), RACObserve([DataManager shared], selectedArea)]
                                        reduce:^(NSString *province, NSString *city, NSString *area) {
                                            return [NSString stringWithFormat:@"%@ %@ %@",
                                                    province == nil ? @"" : province,
                                                    city == nil ? @"" : city,
                                                    area == nil ? @"" : area];
                                        }];
}

@end
