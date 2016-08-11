//
//  RequirementCreateViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/3.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementCreateViewController.h"
#import "HouseRequirementCreateViewController.h"
#import "BusinessRequirementCreateViewController.h"

@interface RequirementCreateViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIViewController *currentDisplayController;
@property (strong, nonatomic) HouseRequirementCreateViewController *houseRequirementController;
@property (strong, nonatomic) BusinessRequirementCreateViewController *businessRequirementController;

@property (strong, nonatomic) Requirement *editingRequirement;

@end

@implementation RequirementCreateViewController

#pragma mark - init method
- (id)initToViewRequirement:(Requirement *)requirement {
    return [self initWithRequirement:requirement];
}

- (id)initWithRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        _editingRequirement = requirement;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - Nav
- (void)initNav {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initLeftBackInNav];
    if ([self.editingRequirement.dec_type isEqualToString:kDecTypeBusiness]) {
        self.title = @"商装";
    } else {
        self.title = @"家装";
    }
}

#pragma mark - UI
- (void)initUI {
    [self initChildView];
}

#pragma mark - child controller 
- (void)initChildView {
    if ([self.editingRequirement.dec_type isEqualToString:kDecTypeBusiness]) {
        self.businessRequirementController = [[BusinessRequirementCreateViewController alloc] initToViewRequirement:self.editingRequirement];
        [self addChildViewController:self.businessRequirementController];
        self.currentDisplayController = self.businessRequirementController;
        [self.containerView addSubview:self.currentDisplayController.view];
    } else {
        self.houseRequirementController = [[HouseRequirementCreateViewController alloc] initToViewRequirement:self.editingRequirement];
        [self addChildViewController:self.houseRequirementController];
        self.currentDisplayController = self.houseRequirementController;
        [self.containerView addSubview:self.currentDisplayController.view];
    }
    
    self.currentDisplayController.view.frame = self.containerView.bounds;
}

@end
