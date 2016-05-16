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
    [self initNav];
    
    [self.textView setCornerRadius:5];
    [self.btnDone setCornerRadius:5];

    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(id text) {
        @strongify(self);
        [self enableDoneButton:[text trim].length > 0];
    }];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"意见反馈";
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
        [self clickBack];
        [HUDUtil showText:@"感谢您的宝贵建议！" delayShow:0.3];
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
    [self.btnDone enableBgColor:enable];
}

@end
