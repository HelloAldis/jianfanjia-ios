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

typedef enum {
    RequirementOperateTypeView,
    RequirementOperateTypeEdit
} RequirementOperateType;

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

@property (strong, nonatomic) UIGestureRecognizer *selectCityGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectHouseTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectWorkTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectDecTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectPopulationGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectPreferredStyleGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectCommunicationTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectSexTypeGesture;

@property (strong, nonatomic) Requirement *editingRequirement;
@property (assign, nonatomic) RequirementOperateType editType;

@end

@implementation RequirementCreateViewController

#pragma mark - init method
- (id)initToCreateRequirement {
    Requirement *newRequirement = [[Requirement alloc] init];
    newRequirement._id = @"";
    return [self initWithRequirement:newRequirement withType:RequirementOperateTypeEdit];
}

- (id)initToViewRequirement:(Requirement *)requirement {
    return [self initWithRequirement:requirement withType:RequirementOperateTypeView];
}

- (id)initWithRequirement:(Requirement *)requirement withType:(RequirementOperateType) editType {
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
    if ([@"" isEqualToString:self.editingRequirement._id]) {
        [self displayDefaultValueToUI];
        [self displayDoneButton];
    } else {
        if ([self.editingRequirement.status isEqualToString:kRequirementStatusUnorderAnyDesigner]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
            self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
        }
    }
    
    self.title = @"填写装修需求";
}

- (void)displayDoneButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal
                                                                combineLatest:@[
                                                                                RACObserve(self.lblSelectCityVal, text),
                                                                                RACObserve(self.lblSelectHouseTypeVal, text),
                                                                                RACObserve(self.lblSelectWorkTypeVal, text),
                                                                                RACObserve(self.lblSelectDecorationTypeVal, text),
                                                                                RACObserve(self.lblSelectPopulationVal, text),
                                                                                RACObserve(self.lblSelectPreferredStyleVal, text),
                                                                                self.fldStreetVal.rac_textSignal,
                                                                                self.fldCommunityVal.rac_textSignal,
                                                                                self.fldPhaseVal.rac_textSignal,
                                                                                self.fldBuildingVal.rac_textSignal,
                                                                                self.fldUnitVal.rac_textSignal,
                                                                                self.fldRoomVal.rac_textSignal,
                                                                                self.fldDecorationAreaVal.rac_textSignal,
                                                                                self.fldDecorationBudgetVal.rac_textSignal]
                                                            
                                                                        reduce:^id(
                                                                                NSString *city,
                                                                                NSString *houseType,
                                                                                NSString *workType,
                                                                                NSString *decType,
                                                                                NSString *population,
                                                                                NSString *decStyle,
                                                                                NSString *street,
                                                                                NSString *cell,
                                                                                NSString *phase,
                                                                                NSString *building,
                                                                                NSString *unit,
                                                                                NSString *room,
                                                                                NSString *decArea,
                                                                                NSString *decBudget) {
                                                                         
                                                                            if (city.length > 0
                                                                                && houseType.length > 0
                                                                                && workType.length > 0
                                                                                && decType.length > 0
                                                                                && population.length > 0
                                                                                && decStyle.length > 0
                                                                                && street.length > 0
                                                                                && cell.length > 0
                                                                                && phase.length > 0
                                                                                && building.length > 0
                                                                                && unit.length > 0
                                                                                && room.length > 0
                                                                                && decArea.length > 0
                                                                                && decBudget.length > 0) {
                                                                                return @(YES);
                                                                            } else {
                                                                                return @(NO);
                                                                            }
                                                                        }];
}

- (void)enableSubviews:(BOOL)enable {
    self.selectCityGesture.enabled = enable;
    self.selectHouseTypeGesture.enabled = enable;
    self.selectWorkTypeGesture.enabled = enable;
    self.selectDecTypeGesture.enabled = enable;
    self.selectPopulationGesture.enabled = enable;
    self.selectPreferredStyleGesture.enabled = enable;
    self.selectCommunicationTypeGesture.enabled = enable;
    self.selectSexTypeGesture.enabled = enable;
    self.fldStreetVal.enabled = enable;
    self.fldCommunityVal.enabled = enable;
    self.fldPhaseVal.enabled = enable;
    self.fldBuildingVal.enabled = enable;
    self.fldUnitVal.enabled = enable;
    self.fldRoomVal.enabled = enable;
    self.fldDecorationAreaVal.enabled = enable;
    self.fldDecorationBudgetVal.enabled = enable;
}

- (void)displayDefaultValueToUI {
    //house type @"2":@"三居"
    self.editingRequirement.house_type = @"2";
    //work type @"0":@"设计＋施工(半包)
    self.editingRequirement.work_type = @"0";
    //decoration type @"0":@"家装"
    self.editingRequirement.dec_type = @"0";
    //population 
    self.editingRequirement.family_description = @"三口之家";
    //decoration style @"2":@"现代"
    self.editingRequirement.dec_style = @"2";
    //communication type @"0":@"不限"
    self.editingRequirement.communication_type = @"0";
    //sex type @"2":@"不限"
    self.editingRequirement.prefer_sex = @"2";
    
    //House type
    self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:self.editingRequirement.house_type];
    //Work type
    self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:self.editingRequirement.work_type];
    //Decoration type
    self.lblSelectDecorationTypeVal.text = [NameDict nameForDecType:self.editingRequirement.dec_type];
    //Population
    self.lblSelectPopulationVal.text = self.editingRequirement.family_description;
    //Decoration style
    self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:self.editingRequirement.dec_style];
    //Communication type
    self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:self.editingRequirement.communication_type];
    //Sex type
    self.lblSelectSexTypeVal.text = [NameDict nameForSexType:self.editingRequirement.prefer_sex];
}

- (void)displayValueToUI {
     //City
    self.lblSelectCityVal.text = [NSString stringWithFormat:@"%@ %@ %@", self.editingRequirement.province, self.editingRequirement.city, self.editingRequirement.district];
    //House type
    self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:self.editingRequirement.house_type];
    //Work type
    self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:self.editingRequirement.work_type];
    //Decoration type
    self.lblSelectDecorationTypeVal.text = [NameDict nameForDecType:self.editingRequirement.dec_type];
    //Population
    self.lblSelectPopulationVal.text = self.editingRequirement.family_description;
    //Decoration style
    self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:self.editingRequirement.dec_style];
    //Communication type
    self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:self.editingRequirement.communication_type];
    //Sex type
    self.lblSelectSexTypeVal.text = [NameDict nameForSexType:self.editingRequirement.prefer_sex];
    //Street
    self.fldStreetVal.text = self.editingRequirement.street;
    //Cell
    self.fldCommunityVal.text = self.editingRequirement.cell;
    //Phase
    self.fldPhaseVal.text = self.editingRequirement.cell_phase;
    //Building
    self.fldBuildingVal.text = self.editingRequirement.cell_building;
    //Unit
    self.fldUnitVal.text = self.editingRequirement.cell_unit;
    //Room number
    self.fldRoomVal.text = self.editingRequirement.cell_detail_number;
    //Area
    self.fldDecorationAreaVal.text = [self.editingRequirement.house_area stringValue];
    //Budget
    self.fldDecorationBudgetVal.text = [self.editingRequirement.total_price stringValue];
}

- (void)initUI {
    self.selectCityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectHouseTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectWorkTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectDecTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectPopulationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectPreferredStyleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectCommunicationTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectSexTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    
    [self.selectCityView addGestureRecognizer:self.selectCityGesture];
    [self.selectHouseTypeView addGestureRecognizer:self.selectHouseTypeGesture];
    [self.selectWorkTypeView addGestureRecognizer:self.selectWorkTypeGesture];
    [self.selectDecTypeView addGestureRecognizer:self.selectDecTypeGesture];
    [self.selectPopulationView addGestureRecognizer:self.selectPopulationGesture];
    [self.selectPreferredStyleView addGestureRecognizer:self.selectPreferredStyleGesture];
    [self.selectCommunicationTypeView addGestureRecognizer:self.selectCommunicationTypeGesture];
    [self.selectSexTypeView addGestureRecognizer:self.selectSexTypeGesture];
    
    if (self.editType == RequirementOperateTypeView) {
        [self enableSubviews:NO];
        [self displayValueToUI];
    }
    
    @weakify(self);
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
    [[[[self.fldDecorationBudgetVal rac_textSignal]
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
- (void)onTapSection:(UIGestureRecognizer *)gesture {
    UIView *tapView = gesture.view;
    UIViewController *controller;

    if (tapView == self.selectCityView) {
        //City
        controller = [[SelectCityViewController alloc] initWithAddress:self.lblSelectCityVal.text valueBlock:^(id value) {
            self.lblSelectCityVal.text = value;
            NSArray *addressArr = [value componentsSeparatedByString:@" "];
            self.editingRequirement.province = addressArr[0];
            self.editingRequirement.city = addressArr[1];
            self.editingRequirement.district = addressArr[2];
        }];
    } else if (tapView == self.selectHouseTypeView) {
        //House type
        controller = [[SelectHouseTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.house_type = value == nil ? @"" : value;
            self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:value];
        }];
    } else if (tapView == self.selectWorkTypeView) {
        //Work type
        controller = [[SelectWorkTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.work_type = value == nil ? @"" : value;
            self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:value];
        }];
    } else if (tapView == self.selectDecTypeView) {
        //Decoration type
        controller = [[SelectDecorationTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.dec_type = value == nil ? @"" : value;
            self.lblSelectDecorationTypeVal.text = [NameDict nameForDecType:value];
        }];
    } else if (tapView == self.selectPopulationView) {
        //Population
        controller = [[SelectPopulationViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.family_description = value == nil ? @"" : value;
            self.lblSelectPopulationVal.text = value;
        }];
    } else if (tapView == self.selectPreferredStyleView) {
        //Decoration style
        controller = [[SelectDecorationStyleViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.dec_style = value == nil ? @"" : value;
            self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:value];
        }];
    } else if (tapView == self.selectCommunicationTypeView) {
        //Communication type
        controller = [[SelectCommunicationTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.communication_type = value == nil ? @"" : value;
            self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:value];
        }];
    } else if (tapView == self.selectSexTypeView) {
        //Sex type
        controller = [[SelectSexTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.prefer_sex = value == nil ? @"" : value;
            self.lblSelectSexTypeVal.text = [NameDict nameForSexType:value];
        }];
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
- (void)onClickEdit {
    self.editType = RequirementOperateTypeEdit;
    [self displayDoneButton];
    [self enableSubviews:YES];
}

- (void)onClickDone {
    if ([@"" isEqualToString:self.editingRequirement._id]) {
        SendAddRequirement *sendAddRequirement = [[SendAddRequirement alloc] initWithRequirement:self.editingRequirement];
        
        [API sendAddRequirement:sendAddRequirement success:^{
            [self clickBack];
            [DataManager shared].homePageNeedRefresh = YES;
        } failure:^{
            
        } networkError:^{
            
        }];
    } else {
        SendUpdateRequirement *sendUpdateRequirement = [[SendUpdateRequirement alloc] initWithRequirement:self.editingRequirement];
        
        [API sendUpdateRequirement:sendUpdateRequirement success:^{
            [self clickBack];
        } failure:^{
            
        } networkError:^{
            
        }];
    }
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

@end
