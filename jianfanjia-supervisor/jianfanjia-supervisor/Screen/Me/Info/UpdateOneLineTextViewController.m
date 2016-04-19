//
//  UpdateOneLineTextViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UpdateOneLineTextViewController.h"
#import "ViewControllerContainer.h"

@interface UpdateOneLineTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fldOneLine;
@property (copy, nonatomic) void (^DoneBlock)(id value);
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;

@end

@implementation UpdateOneLineTextViewController

#pragma mark - init method
- (id)initWithName:(NSString *)name value:(NSString *)value done:(void(^)(id value))DoneBlock {
    if (self = [super init]) {
        _name = name;
        _value = value;
        _DoneBlock = DoneBlock;
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
    [self initLeftBackInNav];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    
    self.title = self.name;
}

- (void)initUI {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.fldOneLine.leftView = paddingView;
    self.fldOneLine.leftViewMode = UITextFieldViewModeAlways;
    self.fldOneLine.text = self.value;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.fldOneLine.rac_textSignal subscribeNext:^(NSString *value) {
        if ([value length] > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }];
}

#pragma mark - user action
- (void)onClickDone {
    if (self.DoneBlock) {
        self.DoneBlock(self.fldOneLine.text);
    }
    [self clickBack];
}

@end
