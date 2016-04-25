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
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
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
    self.title = self.name;
}

- (void)initUI {
    [self.fldOneLine setCornerRadius:5];
    [self.btnSave setCornerRadius:5];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.fldOneLine.leftView = paddingView;
    self.fldOneLine.leftViewMode = UITextFieldViewModeAlways;
    self.fldOneLine.text = self.value;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.fldOneLine.rac_textSignal subscribeNext:^(NSString *value) {
        [self.btnSave enableBgColor:[value length] > 0];
    }];
}

#pragma mark - user action
- (void)onClickDone {
    if (self.DoneBlock) {
        self.DoneBlock(self.fldOneLine.text);
    }
    [self clickBack];
}

- (IBAction)onClickSave:(id)sender {
    if (self.DoneBlock) {
        self.DoneBlock(self.fldOneLine.text);
    }
    [self clickBack];
}

@end
