//
//  RequirementCreateViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HouseRequirementCreateViewController.h"
#import "SelectCityViewController.h"
#import "SelectHouseTypeViewController.h"
#import "SelectPopulationViewController.h"
#import "SelectCommunicationTypeViewController.h"
#import "SelectWorkTypeViewController.h"
#import "SelectSexTypeViewController.h"
#import "SelectDecorationStyleViewController.h"
#import "MessageAlertViewController.h"

@interface HouseRequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCity;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCityVal;
@property (weak, nonatomic) IBOutlet UITextField *fldCellVal;
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
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPopulation;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectPopulationVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectPreferredStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectPreferredStyleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCommunicationType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCommunicationTypeVal;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectSexType;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectSexTypeVal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectCityTrailingConstriant;

@property (weak, nonatomic) IBOutlet UIView *selectCityView;
@property (weak, nonatomic) IBOutlet UIView *selectHouseTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectWorkTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectPopulationView;
@property (weak, nonatomic) IBOutlet UIView *selectPreferredStyleView;
@property (weak, nonatomic) IBOutlet UIView *selectCommunicationTypeView;
@property (weak, nonatomic) IBOutlet UIView *selectSexTypeView;

@property (strong, nonatomic) UIGestureRecognizer *selectCityGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectHouseTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectWorkTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectPopulationGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectPreferredStyleGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectCommunicationTypeGesture;
@property (strong, nonatomic) UIGestureRecognizer *selectSexTypeGesture;

@property (strong, nonatomic) Requirement *originRequirement;
@property (strong, nonatomic) Requirement *editingRequirement;
@property (assign, nonatomic) RequirementOperateType editType;

@property (strong, nonatomic) RACDisposable *doneSignalDisposale;

@end

@implementation HouseRequirementCreateViewController

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
    if (self = [super init]) {
        _editingRequirement = requirement;
        _editType = editType;
        _originRequirement = [[Requirement alloc] init];
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self listenProperties];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.doneSignalDisposale) {
        [self.doneSignalDisposale dispose];
    }
}

#pragma mark - UI
- (void)initUI {
    [self bindGestures];
    [self initDefaultValue];
    [self uiToModel];
}

#pragma mark - init default value
- (void)initDefaultValue {
    if ([@"" isEqualToString:self.editingRequirement._id]) {
        [self displayDefaultValueToUI];
    }
    
    if (self.editType == RequirementOperateTypeView) {
        [self enableSubviews:NO];
        [self displayValueToUI];
    }
    
    [self.originRequirement merge:self.editingRequirement];
}

#pragma mark - listen properties
- (void)listenProperties {
    self.doneSignalDisposale = [[RACSignal combineLatest:@[
                                                           RACObserve(self.lblSelectCityVal, text),
                                                           RACObserve(self.lblSelectHouseTypeVal, text),
                                                           RACObserve(self.lblSelectWorkTypeVal, text),
                                                           RACObserve(self.lblSelectPopulationVal, text),
                                                           RACObserve(self.lblSelectPreferredStyleVal, text),
                                                           self.fldCellVal.rac_textSignal,
                                                           self.fldPhaseVal.rac_textSignal,
                                                           self.fldBuildingVal.rac_textSignal,
                                                           self.fldUnitVal.rac_textSignal,
                                                           self.fldRoomVal.rac_textSignal,
                                                           self.fldDecorationAreaVal.rac_textSignal,
                                                           self.fldDecorationBudgetVal.rac_textSignal
                                                           ]
                                 
                                                   reduce:^id(
                                                              NSString *city,
                                                              NSString *houseType,
                                                              NSString *workType,
                                                              NSString *population,
                                                              NSString *decStyle,
                                                              NSString *cell,
                                                              NSString *phase,
                                                              NSString *building,
                                                              NSString *unit,
                                                              NSString *room,
                                                              NSNumber *decArea,
                                                              NSNumber *decBudget) {
                                                       
                                                                if (city.length > 0
                                                                    && ![city isEqualToString:kTipsForSelectCity]
                                                                    && houseType.length > 0
                                                                    && workType.length > 0
                                                                    && population.length > 0
                                                                    && decStyle.length > 0
                                                                    && cell.length > 0
                                                                    && phase.length > 0
                                                                    && building.length > 0
                                                                    && unit.length > 0
                                                                    && room.length > 0
                                                                    && [decArea intValue] > 0
                                                                    && [decBudget intValue] > 0) {
                                                                    return @(YES);
                                                                } else {
                                                                    return @(NO);
                                                                }
                                                           }]
                                
                                            subscribeNext:^(id x) {
                                                            [self enableRightBarItem:[x boolValue]];
                                                       }];
}

#pragma mark - model to ui
- (void)displayDefaultValueToUI {
    //house type @"2":@"三居"
    self.editingRequirement.house_type = @"2";
    //work type @"0":@"设计＋施工(半包)
    self.editingRequirement.work_type = @"0";
    //decoration type @"0":@"家装"
    self.editingRequirement.dec_type = @"0";
    //population
    self.editingRequirement.family_description = [GVUserDefaults standardUserDefaults].family_description.length > 0 ? [GVUserDefaults standardUserDefaults].family_description : @"三口之家";
    //decoration style @"2":@"现代"
    self.editingRequirement.dec_style = [GVUserDefaults standardUserDefaults].dec_styles.count > 0 ? [GVUserDefaults standardUserDefaults].dec_styles[0] : @"2";
    //communication type @"0":@"不限"
    self.editingRequirement.communication_type = @"0";
    //sex type @"2":@"不限"
    self.editingRequirement.prefer_sex = @"2";
    
    //City
    self.lblSelectCityVal.text = kTipsForSelectCity;
    self.lblSelectCityVal.textColor = kUntriggeredColor;
    //House type
    self.lblSelectHouseTypeVal.text = [NameDict nameForHouseType:self.editingRequirement.house_type];
    //Work type
    self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:self.editingRequirement.work_type];
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
    //Population
    self.lblSelectPopulationVal.text = self.editingRequirement.family_description;
    //Decoration style
    self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:self.editingRequirement.dec_style];
    //Communication type
    self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:self.editingRequirement.communication_type];
    //Sex type
    self.lblSelectSexTypeVal.text = [NameDict nameForSexType:self.editingRequirement.prefer_sex];
    //Cell
    self.fldCellVal.text = self.editingRequirement.cell;
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

#pragma mark - ui to model
- (void)uiToModel {
    @weakify(self);
    //Cell
    [[self.fldCellVal rac_textSignal]
     subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.cell = value;
     }];
    
    //Phase
    [[self.fldPhaseVal rac_textSignal]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.fldPhaseVal.text = value;
         self.editingRequirement.cell_phase = value;
     }];
    
    //Building
    [[self.fldBuildingVal rac_textSignal]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.fldBuildingVal.text = value;
         self.editingRequirement.cell_building = value;
     }];
    
    //Unit
    [[self.fldUnitVal rac_textSignal]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.fldUnitVal.text = value;
         self.editingRequirement.cell_unit = value;
     }];
    
    //Room number
    [[self.fldRoomVal rac_textSignal]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.fldRoomVal.text = value;
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
         self.fldDecorationAreaVal.text = value;
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
- (void)bindGestures {
    self.selectCityGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectHouseTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectWorkTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectPopulationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectPreferredStyleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectCommunicationTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    self.selectSexTypeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSection:)];
    
    [self.selectCityView addGestureRecognizer:self.selectCityGesture];
    [self.selectHouseTypeView addGestureRecognizer:self.selectHouseTypeGesture];
    [self.selectWorkTypeView addGestureRecognizer:self.selectWorkTypeGesture];
    [self.selectPopulationView addGestureRecognizer:self.selectPopulationGesture];
    [self.selectPreferredStyleView addGestureRecognizer:self.selectPreferredStyleGesture];
    [self.selectCommunicationTypeView addGestureRecognizer:self.selectCommunicationTypeGesture];
    [self.selectSexTypeView addGestureRecognizer:self.selectSexTypeGesture];
}

- (void)onTapSection:(UIGestureRecognizer *)gesture {
    UIView *tapView = gesture.view;
    UIViewController *controller;

    if (tapView == self.selectCityView) {
        //City
        controller = [[SelectCityViewController alloc] initWithAddress:[self.lblSelectCityVal.text isEqualToString:kTipsForSelectCity] ? @"" : self.lblSelectCityVal.text valueBlock:^(id value) {
            self.lblSelectCityVal.text = value;
            self.lblSelectCityVal.textColor = kThemeTextColor;
            
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
        } curValue:self.editingRequirement.house_type];
    } else if (tapView == self.selectWorkTypeView) {
        //Work type
        controller = [[SelectWorkTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.work_type = value == nil ? @"" : value;
            self.lblSelectWorkTypeVal.text = [NameDict nameForWorkType:value];
        } curValue:self.editingRequirement.work_type];
    } else if (tapView == self.selectPopulationView) {
        //Population
        controller = [[SelectPopulationViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.family_description = value == nil ? @"" : value;
            self.lblSelectPopulationVal.text = value;
        } curValue:self.editingRequirement.family_description];
    } else if (tapView == self.selectPreferredStyleView) {
        //Decoration style
        controller = [[SelectDecorationStyleViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.dec_style = value == nil ? @"" : value;
            self.lblSelectPreferredStyleVal.text = [NameDict nameForDecStyle:value];
        } curValue:self.editingRequirement.dec_style];
    } else if (tapView == self.selectCommunicationTypeView) {
        //Communication type
        controller = [[SelectCommunicationTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.communication_type = value == nil ? @"" : value;
            self.lblSelectCommunicationTypeVal.text = [NameDict nameForCommunicationType:value];
        } curValue:self.editingRequirement.communication_type];
    } else if (tapView == self.selectSexTypeView) {
        //Sex type
        controller = [[SelectSexTypeViewController alloc] initWithValueBlock:^(id value) {
            self.editingRequirement.prefer_sex = value == nil ? @"" : value;
            self.lblSelectSexTypeVal.text = [NameDict nameForSexType:value];
        } curValue:self.editingRequirement.prefer_sex];
        [(SelectSexTypeViewController *)controller setSelectSexType:SelectSexTypeRequirementPrefer];
    }
    
    if (controller) {
        [self navigateToSelection:controller];
    }
}

- (void)navigateToSelection:(UIViewController *)controller {
    [self.view endEditing:YES];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - util
- (void)enableSubviews:(BOOL)enable {
    self.selectCityGesture.enabled = enable;
    self.selectHouseTypeGesture.enabled = enable;
    self.selectWorkTypeGesture.enabled = enable;
    self.selectPopulationGesture.enabled = enable;
    self.selectPreferredStyleGesture.enabled = enable;
    self.selectCommunicationTypeGesture.enabled = enable;
    self.selectSexTypeGesture.enabled = enable;
    self.fldCellVal.enabled = enable;
    self.fldPhaseVal.enabled = enable;
    self.fldBuildingVal.enabled = enable;
    self.fldUnitVal.enabled = enable;
    self.fldRoomVal.enabled = enable;
    self.fldDecorationAreaVal.enabled = enable;
    self.fldDecorationBudgetVal.enabled = enable;
    self.btnSelectCity.hidden = !enable;
    self.btnSelectHouseType.hidden = !enable;
    self.btnSelectWorkType.hidden = !enable;
    self.btnSelectPopulation.hidden = !enable;
    self.btnSelectPreferredStyle.hidden = !enable;
    self.btnSelectCommunicationType.hidden = !enable;
    self.btnSelectSexType.hidden = !enable;
    if (enable) {
        self.selectCityTrailingConstriant.constant = 15;
    } else {
        self.selectCityTrailingConstriant.constant = 0;
    }
}

- (void)enableRightBarItem:(BOOL)enable {
    self.parentViewController.navigationItem.rightBarButtonItem.enabled = enable;
}

#pragma mark - trigger event
- (void)triggerEditEvent {
    self.editType = RequirementOperateTypeEdit;
    [self enableRightBarItem:YES];
    [self enableSubviews:YES];
}

- (void)triggerDoneEvent {
    [self enableRightBarItem:NO];
    if ([@"" isEqualToString:self.editingRequirement._id]) {
        SendAddRequirement *sendAddRequirement = [[SendAddRequirement alloc] initWithRequirement:self.editingRequirement];
        
        [API sendAddRequirement:sendAddRequirement success:^{
            [self.navigationController popViewControllerAnimated:YES];
            [DataManager shared].homePageNeedRefresh = YES;
        } failure:^{
            [self enableRightBarItem:YES];
        } networkError:^{
            [self enableRightBarItem:YES];
        }];
    } else {
        SendUpdateRequirement *sendUpdateRequirement = [[SendUpdateRequirement alloc] initWithRequirement:self.editingRequirement];
        
        [API sendUpdateRequirement:sendUpdateRequirement success:^{
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^{
            [self enableRightBarItem:YES];
        } networkError:^{
            [self enableRightBarItem:YES];
        }];
    }
}

- (BOOL)hasDataChanged {
    if (self.editType == RequirementOperateTypeView) {
        return NO;
    }
    
    if (![NSString compareStrWithIgnoreNil:self.originRequirement.province other:self.editingRequirement.province]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.city other:self.editingRequirement.city]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.district other:self.editingRequirement.district]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.street other:self.editingRequirement.street]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.cell other:self.editingRequirement.cell]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.cell_phase other:self.editingRequirement.cell_phase]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.cell_building other:self.editingRequirement.cell_building]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.cell_unit other:self.editingRequirement.cell_unit]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.cell_detail_number other:self.editingRequirement.cell_detail_number]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.house_type other:self.editingRequirement.house_type]
        || ![NSNumber compareNumWithIgnoreNil:self.originRequirement.house_area other:self.editingRequirement.house_area]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.work_type other:self.editingRequirement.work_type]
        || ![NSNumber compareNumWithIgnoreNil:self.originRequirement.total_price other:self.editingRequirement.total_price]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.family_description other:self.editingRequirement.family_description]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.dec_style other:self.editingRequirement.dec_style]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.communication_type other:self.editingRequirement.communication_type]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.prefer_sex other:self.editingRequirement.prefer_sex]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - keyboard
- (void)keyboardShow:(CGFloat)keyboardHeight {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
}

- (void)keyboardHide:(CGFloat)keyboardHeight {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
