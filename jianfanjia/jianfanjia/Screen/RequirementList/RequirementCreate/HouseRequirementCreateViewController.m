//
//  RequirementCreateViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HouseRequirementCreateViewController.h"
#import "SelectHouseTypeViewController.h"
#import "SelectPopulationViewController.h"
#import "SelectCommunicationTypeViewController.h"
#import "SelectWorkTypeViewController.h"
#import "SelectSexTypeViewController.h"
#import "SelectDecorationStyleViewController.h"
#import "ViewControllerContainer.h"
#import "DecPackage365View.h"

@interface HouseRequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectCity;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectCityVal;
@property (weak, nonatomic) IBOutlet UITextField *fldBasicAddresVal;
@property (weak, nonatomic) IBOutlet UITextField *fldDetailAddresVal;
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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *part3TopConstraint;
@property (weak, nonatomic) IBOutlet UIView *buildAreaView;
@property (weak, nonatomic) IBOutlet UIView *decTotalBudgetView;
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

@property (strong, nonatomic) DecPackage365View *decPkg365View;
@property (assign, nonatomic) BOOL wasShowPkg;
@property (assign, nonatomic) CGFloat keyboardHeight;

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
    [self initDecPkg];
}

#pragma mark - init dec pkg
- (void)initDecPkg {
    CGRect frame = [self.scrollView convertRect:self.decTotalBudgetView.bounds fromView:self.decTotalBudgetView];
    self.decPkg365View = [[DecPackage365View alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), kScreenWidth, kDecPackage365ViewHeight)];
    self.decPkg365View.alpha = 0;
    [self.scrollView insertSubview:self.decPkg365View belowSubview:self.decTotalBudgetView.superview];
}

- (void)showDecPkg {
    [self.decPkg365View updateData:self.editingRequirement];
    
    if (!self.wasShowPkg) {
        self.wasShowPkg = YES;
        
        CGFloat constant = self.part3TopConstraint.constant;
        constant += kDecPackage365ViewHeight;
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height += kDecPackage365ViewHeight;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.decPkg365View.alpha = 1;
            self.part3TopConstraint.constant = constant;
            self.scrollView.contentSize = contentSize;
        }];
    }
}

- (void)hideDecPkg {
    if (self.wasShowPkg) {
        self.wasShowPkg = NO;
        
        CGFloat constant = self.part3TopConstraint.constant;
        constant -= kDecPackage365ViewHeight;
        CGSize contentSize = self.scrollView.contentSize;
        contentSize.height -= kDecPackage365ViewHeight;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.decPkg365View.alpha = 0;
            self.part3TopConstraint.constant = constant;
            self.scrollView.contentSize = contentSize;
        }];
    }
}

- (void)scrollToMakeDecPkgVisible {
    CGRect frame = [self.scrollView convertRect:self.buildAreaView.bounds fromView:self.buildAreaView];
    CGPoint offset = self.scrollView.contentOffset;
    offset.y = CGRectGetMinY(frame);
    
    if (self.editType == RequirementOperateTypeEdit) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.scrollView setContentOffset:offset animated:NO];
        }];
    }
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
                                                           self.fldBasicAddresVal.rac_textSignal,
                                                           self.fldDetailAddresVal.rac_textSignal,
                                                           self.fldDecorationAreaVal.rac_textSignal,
                                                           self.fldDecorationBudgetVal.rac_textSignal
                                                           ]
                                 
                                                   reduce:^id(
                                                              NSString *city,
                                                              NSString *houseType,
                                                              NSString *workType,
                                                              NSString *population,
                                                              NSString *decStyle,
                                                              NSString *basicAddress,
                                                              NSString *detailAddress,
                                                              NSNumber *decArea,
                                                              NSNumber *decBudget) {
                                                       
                                                                if (city.length > 0
                                                                    && houseType.length > 0
                                                                    && workType.length > 0
                                                                    && population.length > 0
                                                                    && decStyle.length > 0
                                                                    && basicAddress.length > 0
                                                                    && detailAddress.length > 0
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
    
    [[RACSignal combineLatest:@[self.fldDecorationAreaVal.rac_textSignal,
                                self.fldDecorationBudgetVal.rac_textSignal
                                ]]
                 subscribeNext:^(RACTuple *tuple) {
                     NSUInteger area = [tuple.first integerValue];
                     NSUInteger budget = [tuple.second integerValue];
                     
                     self.editingRequirement.house_area = @(area);
                     self.editingRequirement.total_price = @(budget);
                     
                     if ([RequirementBusiness isPkg365ByArea:area]) {
                         self.editingRequirement.package_type = kDecPackage365;
                         [self showDecPkg];
                         [self scrollToMakeDecPkgVisible];
                     } else {
                         self.editingRequirement.package_type = kDecPackageDefault;
                         [self hideDecPkg];
                     }
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
    //Basic address
    self.fldBasicAddresVal.text = self.editingRequirement.basic_address;
    //Detail address
    self.fldDetailAddresVal.text = self.editingRequirement.detail_address;
    //Area
    self.fldDecorationAreaVal.text = [self.editingRequirement.house_area stringValue];
    //Budget
    self.fldDecorationBudgetVal.text = [self.editingRequirement.total_price stringValue];
}

#pragma mark - ui to model
- (void)uiToModel {
    @weakify(self);
    //Basic address
    [[self.fldBasicAddresVal rac_textSignal]
     subscribeNext:^(NSString *value) {
        @strongify(self);
        self.editingRequirement.basic_address = value;
     }];
    
    //Detail address
    [[self.fldDetailAddresVal rac_textSignal]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.editingRequirement.detail_address = value;
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
        controller = [[SelectCityViewController alloc] initWithAddress:self.lblSelectCityVal.text valueBlock:^(id value) {
            self.lblSelectCityVal.text = value;
            self.lblSelectCityVal.textColor = kThemeTextColor;
            
            NSArray *addressArr = [value componentsSeparatedByString:@" "];
            self.editingRequirement.province = addressArr[0];
            self.editingRequirement.city = addressArr[1];
            self.editingRequirement.district = addressArr[2];
        } limitCity:YES];
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
    self.fldBasicAddresVal.enabled = enable;
    self.fldDetailAddresVal.enabled = enable;
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
            [ViewControllerContainer showRequirementList];
            [DataManager shared].homePageNeedRefresh = YES;
        } failure:^{
            [self enableRightBarItem:YES];
        } networkError:^{
            [self enableRightBarItem:YES];
        }];
    } else {
        SendUpdateRequirement *sendUpdateRequirement = [[SendUpdateRequirement alloc] initWithRequirement:self.editingRequirement];
        
        [API sendUpdateRequirement:sendUpdateRequirement success:^{
            [ViewControllerContainer showRequirementList];
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
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.basic_address other:self.editingRequirement.basic_address]
        || ![NSString compareStrWithIgnoreNil:self.originRequirement.detail_address other:self.editingRequirement.detail_address]
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
    self.keyboardHeight = keyboardHeight;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
}

- (void)keyboardHide:(CGFloat)keyboardHeight {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
