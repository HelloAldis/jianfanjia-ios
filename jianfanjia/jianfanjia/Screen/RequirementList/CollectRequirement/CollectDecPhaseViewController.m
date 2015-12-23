//
//  CollectDecPhaseViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CollectDecPhaseViewController.h"
#import "ViewControllerContainer.h"

@interface CollectDecPhaseViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnDecPhases;

@end

@implementation CollectDecPhaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

#pragma mark - init UI
- (void)initNav {
    self.navigationController.navigationBarHidden = YES;
}

- (void)initUI {
    @weakify(self);
    [self.btnDecPhases enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [obj setCornerRadius:CGRectGetWidth(obj.frame) / 2];
        [obj setBorder:1 andColor:kThemeTextColor.CGColor];
        [obj addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - user action
- (void)onClickButton:(UIButton *)button {
    [DataManager shared].collectedDecPhase = button.titleLabel.text;
    [UIView playBounceAnimationFor:button completion:^{
        [ViewControllerContainer showCollectDecStyle];
    }];
}

@end
