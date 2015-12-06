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

@property (weak, nonatomic) IBOutlet UIView *selectCityView;
@property (weak, nonatomic) IBOutlet UIView *selectHouseTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectWorkTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectDecTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectPopulationView;
@property (weak, nonatomic) IBOutlet UIView *selectPreferredStyleView;
@property (weak, nonatomic) IBOutlet UIView *selectCommunicationTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectSexTypeView;

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
    self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
    self.title = @"填写装修需求";
}

- (void)initUI {
    [self addTapSectionGesture:self.selectCityView];
    [self addTapSectionGesture:self.selectHouseTypeView];
    [self addTapSectionGesture:self.selectWorkTypeView];
    [self addTapSectionGesture:self.selectDecTypeView];
    [self addTapSectionGesture:self.selectPopulationView];
    [self addTapSectionGesture:self.selectPreferredStyleView];
    [self addTapSectionGesture:self.selectCommunicationTypeView];
    [self addTapSectionGesture:self.selectSexTypeView];
    
    @weakify(self);
    //City
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
    
    //House type
    [RACObserve([DataManager shared], requirementPageSelectedHouseType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.house_type = value == nil ? @"" : value;
        self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:value];
    }];
    
    //Work type
    [RACObserve([DataManager shared], requirementPageSelectedWorkType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.work_type = value == nil ? @"" : value;
        self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:value];
    }];
    
    //Decoration type
    [RACObserve([DataManager shared], requirementPageSelectedDecorationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.dec_type = value == nil ? @"" : value;
        self.lblSelectDecorationTypeVal.text = [NameDict nameForDecType:value];
    }];
    
    //Population
    [RACObserve([DataManager shared], requirementPageSelectedPopulationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.family_description = value == nil ? @"" : value;
        self.lblSelectPopulationVal.text = value;
    }];
    
    //Decoration style
    [RACObserve([DataManager shared], requirementPageSelectedDecorationStyle) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.dec_style = value == nil ? @"" : value;
        self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:value];
    }];
    
    //Communication type
    [RACObserve([DataManager shared], requirementPageSelectedCommunicationType) subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.communication_type = value == nil ? @"" : value;
        self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:value];
    }];
    
    //Sex type
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

#pragma mark - gestures
- (void)addTapSectionGesture:(UIView *)view {
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)]];
}

- (void)onTapSection:(UIGestureRecognizer *)gesture {
    UIView *tapView = gesture.view;
    UIViewController *controller;
    
    if (tapView == self.selectCityView) {
        NSString *currentAddress = self.editingRequirement.province ? [NSString stringWithFormat:@"%@ %@ %@",
                                    self.editingRequirement.province
                                    ,
                                    self.editingRequirement.city
                                    ,
                                    self.editingRequirement.district
                                                                       ] : nil;
        controller = [[SelectCityViewController alloc] initWithAddress:currentAddress];
    } else if (tapView == self.selectHouseTypeView) {
        controller = [[SelectHouseTypeViewController alloc] init];
    } else if (tapView == self.selectWorkTypeView) {
        controller = [[SelectWorkTypeViewController alloc] init];
    } else if (tapView == self.selectDecTypeView) {
        controller = [[SelectDecorationTypeViewController alloc] init];
    } else if (tapView == self.selectPopulationView) {
        controller = [[SelectPopulationViewController alloc] init];
    } else if (tapView == self.selectPreferredStyleView) {
        controller = [[SelectDecorationStyleViewController alloc] init];
    } else if (tapView == self.selectCommunicationTypeView) {
        controller = [[SelectCommunicationTypeViewController alloc] init];
    } else if (tapView == self.selectSexTypeView) {
        controller = [[SelectSexTypeViewController alloc] init];
    }
    
    if (controller) {
        [self navigateToSelection:controller];
    }
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

        // get keyboard height
        kKeyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
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
