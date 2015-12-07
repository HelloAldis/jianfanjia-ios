//
//  UpdateOneLineTextViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/7.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "UpdateMultipleLineTextViewController.h"
#import "ViewControllerContainer.h"

@interface UpdateMultipleLineTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvMultipleLine;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftCharCount;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
    
    self.title = self.name;
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tvMultipleLine.text = self.value;
    
    @weakify(self);
    [[self.tvMultipleLine.rac_textSignal
        length:^NSInteger{
            return self.maxCount;
        }]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.tvMultipleLine.text = value;
            self.lblLeftCharCount.text = [NSString stringWithFormat:@"%@", @(self.maxCount - self.tvMultipleLine.text.length)];
            CGSize size = [self.tvMultipleLine sizeThatFits:CGSizeMake(self.tvMultipleLine.bounds.size.width, CGFLOAT_MAX)];
            self.tvHeightConstraint.constant = self.lblLeftCharCount.bounds.size.height + size.height;
        }];
}

#pragma mark - user action
- (void)onClickDone {
    if (self.DoneBlock) {
        self.DoneBlock(self.tvMultipleLine.text);
    }
    [self clickBack];
}

@end
