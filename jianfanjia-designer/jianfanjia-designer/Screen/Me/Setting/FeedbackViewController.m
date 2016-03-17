//
//  FeedbackViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.textView setCornerRadius:5];
    [self.btnDone setCornerRadius:5];
    [self initNav];
    
    
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(id text) {
        @strongify(self);
        [self enableDoneButton:[text trim].length > 0];
    }];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"用户反馈";
}

- (IBAction)onClickDone:(id)sender {
    [self enableDoneButton:NO];
    Feedback *request = [[Feedback alloc] init];
    request.content = [self.textView.text trim];
    request.platform = @"1";
    request.version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    self.textView.text = nil;
    @weakify(self);
    [API feedback:request success:^{
        @strongify(self);
        [self.view endEditing:YES];
        [HUDUtil showSuccessText:@"感谢您的宝贵建议！"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^{
        [self enableDoneButton:YES];
    } networkError:^{
        [self enableDoneButton:YES];
    }];
}

- (void)dealloc {
    DDLogDebug(@"dealloc");
}

- (void)enableDoneButton:(BOOL)enable {
    if (enable) {
        self.btnDone.enabled = YES;
        [self.btnDone setEnableAlpha];
    } else {
        self.btnDone.enabled = NO;
        [self.btnDone setDisableAlpha];
    }
}

@end
