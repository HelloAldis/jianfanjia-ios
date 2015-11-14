//
//  RequirementCreateViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCreateViewController.h"
#import "SelectCityViewController.h"
#import "SelectHouseTypeViewController.h"
#import "SelectPopulationViewController.h"
#import "SelectCommunicationTypeViewController.h"
#import "SelectWorkTypeViewController.h"
#import "SelectDecorationTypeViewController.h"
#import "SelectSexTypeViewController.h"

@interface RequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCity;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCityVal;
@property (weak, nonatomic) IBOutlet UITextField *fldStreetVal;
@property (weak, nonatomic) IBOutlet UITextField *fldCommunityVal;
@property (weak, nonatomic) IBOutlet UITextField *fldPhaseVal;
@property (weak, nonatomic) IBOutlet UITextField *fldBuildingVal;
@property (weak, nonatomic) IBOutlet UITextField *fldUnitVal;
@property (weak, nonatomic) IBOutlet UITextField *fldRoomVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectHouseType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectHouseTypeVal;
@property (weak, nonatomic) IBOutlet UITextField *fldDecorationAreaVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectWorkType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectWorkTypeVal;
@property (weak, nonatomic) IBOutlet UITextField *fldDecorationBudgetVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectDecorationType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectDecorationTypeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPopulation;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectPopulationVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPreferredStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectPreferredStyleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCommunicationType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCommunicationTypeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSexType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectSexTypeVal;

@property (strong, nonatomic) Requirement *editingRequirement;
@property (assign, nonatomic) RequirementEditType editType;

@end

@implementation RequirementCreateViewController

#pragma mark - init method
- (id)initToCreateRequirement {
    Requirement *newRequirement = [[Requirement alloc] init];
    return [self initWithRequirement:newRequirement withType:Create];
}


- (id)initWithRequirement:(Requirement *)requirement withType:(RequirementEditType) editType {
    self = [super init];
    if (self) {
        _editingRequirement = requirement;
        _editType = editType;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}


#pragma mark - UI
- (void)initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithR:0xfe g:0x70 b:0x04];
    self.title = @"填写装修需求";
}

- (void)initUI {
    @weakify(self);
    //Select city
    [[self.btnSelectCity rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectCityViewController *controller = [[SelectCityViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    RAC(self.lblSelectCityVal, text) = [RACSignal
                                        combineLatest:@[RACObserve([DataManager shared], requirementPageSelectedProvince), RACObserve([DataManager shared], requirementPageSelectedCity), RACObserve([DataManager shared], requirementPageSelectedArea)]
                                        reduce:^(NSString *province, NSString *city, NSString *area) {
                                            @strongify(self);
                                            self.editingRequirement.province = province;
                                            self.editingRequirement.city = city;
                                            self.editingRequirement.district = area;
                                            
                                            return [NSString stringWithFormat:@"%@ %@ %@",
                                                    province == nil ? @"" : province,
                                                    city == nil ? @"" : city,
                                                    area == nil ? @"" : area];
                                        }];
    
    //Select house type
    [[self.btnSelectHouseType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectHouseTypeViewController *controller = [[SelectHouseTypeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedHouseType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.house_type = value;
        self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:value];
    }];
    
    //Select work type
    [[self.btnSelectWorkType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectWorkTypeViewController *controller = [[SelectWorkTypeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedWorkType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.work_type = value;
        self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:value];
    }];
    
    //Select decoration type
    [[self.btnSelectDecorationType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedDecorationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.dec_type = value;
        self.lblSelectDecorationTypeVal.text = [NameDict nameForWorkType:value];
    }];
    
    //Select population
    [[self.btnSelectPopulation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectPopulationViewController *controller = [[SelectPopulationViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedPopulationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.family_description = value;
        self.lblSelectPopulationVal.text = value;
    }];
    
    //Select communication type
    [[self.btnSelectCommunicationType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectCommunicationTypeViewController *controller = [[SelectCommunicationTypeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedCommunicationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.communication_type = value;
        self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:value];
    }];
    
    //Select sex type
    [[self.btnSelectSexType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectSexTypeViewController *controller = [[SelectSexTypeViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedSexType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.prefer_sex = value;
        self.lblSelectSexTypeVal.text = [NameDict nameForSexType:value];
    }];
    
    //District
    [[self.fldDecorationAreaVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.district = value;
    }];
    
    //Street
    [[self.fldStreetVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.street = value;
    }];
    
    //Cell
    [[self.fldCommunityVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.cell = value;
    }];

    //Phase
    [[self.fldPhaseVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.cell_phase = value;
    }];
    
    //Building
    [[self.fldBuildingVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.cell_building = value;
    }];
    
    //Unit
    [[self.fldUnitVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.cell_unit = value;
    }];
    
    //Room number
    [[self.fldRoomVal rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.cell_detail_number = value;
    }];
    
    //Budget
    [[[[self.fldDecorationBudgetVal rac_textSignal]
        filter:^BOOL(NSString *value) {
            return false;
        }]
        map:^NSNumber* (NSString *value) {
            return @20;
        }]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
            self.editingRequirement.total_price = value;
        }];
    
    
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDone {
    
}

@end
