//
//  UpdateOneLineTextViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UpdateMultipleLineTextViewController.h"
#import "ViewControllerContainer.h"

static const CGFloat kMaxMessageHeight = 300;

@interface UpdateMultipleLineTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvMultipleLine;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftCharCount;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeightConstraint;
@property (copy, nonatomic) void (^DoneBlock)(id value);
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;
@property (assign, nonatomic) NSUInteger maxCount;

@end

@implementation UpdateMultipleLineTextViewController

#pragma mark - init method
- (id)initWithName:(NSString *)name value:(NSString *)value max:(NSUInteger)maxCount done:(void(^)(id value))DoneBlock {
    if (self = [super init]) {
        _name = name;
        _value = value;
        _maxCount = maxCount;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tvMultipleLine setCornerRadius:5];
    [self.btnSave setCornerRadius:5];
    
    self.tvMultipleLine.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 20);
    self.tvMultipleLine.text = self.value;
    
    @weakify(self);
    TextViewDelegate *delegate = [[TextViewDelegate alloc] init];
    delegate.maxInputLen = self.maxCount;
    delegate.didChangeBlock = ^(NSString *value){
        @strongify(self);
        if ([value trim].length == 0) {
            self.tvMultipleLine.text = [value trim];
            [self refreshUI:[value trim]];
        } else {
            [self refreshUI:value];
            CGSize size = [self.tvMultipleLine sizeThatFits:CGSizeMake(self.tvMultipleLine.bounds.size.width, CGFLOAT_MAX)];
            CGFloat contentHeight = self.lblLeftCharCount.bounds.size.height + size.height;
            self.tvHeightConstraint.constant = MAX(80, MIN(contentHeight, kMaxMessageHeight));
        }
    };

    self.tvMultipleLine.reverseDelegate = delegate;
    self.tvMultipleLine.delegate = delegate;
}

#pragma mark - user action
- (IBAction)onClickSave:(id)sender {
    if (self.DoneBlock) {
        self.DoneBlock(self.tvMultipleLine.text);
    }
    [self clickBack];
}

- (void)refreshUI:(NSString *)msg {
    self.lblLeftCharCount.text = [NSString stringWithFormat:@"%@", @(MAX(self.maxCount - msg.length, 0))];
    [self.btnSave enableBgColor:msg.length > 0];
}

@end
