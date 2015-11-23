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
#import "SelectDecorationStyleViewController.h"

static float kKeyboardHeight = 480;
static NSTimeInterval kKeyboardDuration = 2.0;

@interface RequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
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
    newRequirement._id = @"";
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
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
        [self navigateToSelection:controller];
    }];
    
    RAC(self.lblSelectCityVal, text) = [RACSignal
                                        combineLatest:@[RACObserve([DataManager shared], requirementPageSelectedProvince), RACObserve([DataManager shared], requirementPageSelectedCity), RACObserve([DataManager shared], requirementPageSelectedArea)]
                                        reduce:^(NSString *province, NSString *city, NSString *area) {
                                            @strongify(self);
                                            self.editingRequirement.province = province == nil ? @"" : province;
                                            self.editingRequirement.city = city == nil ? @"" : city;
                                            self.editingRequirement.district = area == nil ? @"" : area;
                                            
                                            return [NSString stringWithFormat:@"%@ %@ %@",
                                                    self.editingRequirement.province
                                                    ,
                                                    self.editingRequirement.city
                                                    ,
                                                    self.editingRequirement.district
                                                    ];
                                        }];
    
    //Select house type
    [[self.btnSelectHouseType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectHouseTypeViewController *controller = [[SelectHouseTypeViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedHouseType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.house_type = value == nil ? @"" : value;
        self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:value];
    }];
    
    //Select work type
    [[self.btnSelectWorkType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectWorkTypeViewController *controller = [[SelectWorkTypeViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedWorkType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.work_type = value == nil ? @"" : value;
        self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:value];
    }];
    
    //Select decoration type
    [[self.btnSelectDecorationType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectDecorationTypeViewController *controller = [[SelectDecorationTypeViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedDecorationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.dec_type = value == nil ? @"" : value;
        self.lblSelectDecorationTypeVal.text = [NameDict nameForDecType:value];
    }];
    
    //Select population
    [[self.btnSelectPopulation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectPopulationViewController *controller = [[SelectPopulationViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedPopulationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.family_description = value == nil ? @"" : value;
        self.lblSelectPopulationVal.text = value;
    }];
    
    //Select decoration style
    [[self.btnSelectPreferredStyle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectDecorationStyleViewController *controller = [[SelectDecorationStyleViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedDecorationStyle) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.dec_style = value == nil ? @"" : value;
        self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:value];
    }];
    
    //Select communication type
    [[self.btnSelectCommunicationType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectCommunicationTypeViewController *controller = [[SelectCommunicationTypeViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedCommunicationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.communication_type = value == nil ? @"" : value;
        self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:value];
    }];
    
    //Select sex type
    [[self.btnSelectSexType rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self);
        SelectSexTypeViewController *controller = [[SelectSexTypeViewController alloc] init];
        [self navigateToSelection:controller];
    }];
    
    [RACObserve([DataManager shared], requirementPageSelectedSexType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.prefer_sex = value == nil ? @"" : value;
        self.lblSelectSexTypeVal.text = [NameDict nameForSexType:value];
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
    [[[[self.fldPhaseVal rac_textSignal]
        filterNonDigit:^BOOL {
            return true;
        }]
        length:^NSInteger {
            return 3;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.editingRequirement.cell_phase = value;
        }];
    
    //Building
    [[[[self.fldBuildingVal rac_textSignal]
        filterNonDigit:^BOOL {
            return true;
        }]
        length:^NSInteger {
            return 3;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.editingRequirement.cell_building = value;
        }];
    
    //Unit
    [[[[self.fldUnitVal rac_textSignal]
        filterNonDigit:^BOOL {
            return true;
        }]
        length:^NSInteger {
            return 3;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.editingRequirement.cell_unit = value;
        }];
    
    //Room number
    [[[[self.fldRoomVal rac_textSignal]
        filterNonDigit:^BOOL {
            return true;
        }]
        length:^NSInteger {
            return 3;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.editingRequirement.cell_detail_number = value;
        }];
    
    //Area
    [[[[self.fldDecorationAreaVal rac_textSignal]
       filterNonDigit:^BOOL {
           return true;
       }]
      length:^NSInteger {
          return 6;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.editingRequirement.house_area = [NSNumber numberWithInteger:[value integerValue]];
     }];
    
    //Budget
    [[[self.fldDecorationBudgetVal.rac_textSignal
        filterNonDigit:^BOOL {
            return true;
        }]
        length:^NSInteger {
            return 4;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.fldDecorationBudgetVal.text = value;
            self.editingRequirement.total_price = [NSNumber numberWithInteger:[value integerValue]];
        }];
    
}

#pragma mark - navigation
- (void)navigateToSelection:(UIViewController *)controller {
    [self.view endEditing:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - user action
- (void)onClickDone {
    SendAddRequirement *sendAddRequirement = [[SendAddRequirement alloc] initWithRequirement:self.editingRequirement];
    
    [API sendAddRequirement:sendAddRequirement success:^{
        [self clickBack];
    } failure:^{
    
    }];
}

#pragma mark - keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *userInfo = [notification userInfo];

        // get keyboard rect in windwo coordinate
        DDLogDebug(@"%@", [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]);

        // get keyboard height
        kKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
        // get keybord anmation duration
        kKeyboardDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    });
    
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, kKeyboardHeight, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, kKeyboardHeight, 0);
}

- (void) keyboardWillHide:(NSNotification *)notification {
    [self.view endEditing:YES];
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, kKeyboardHeight, 0);
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
