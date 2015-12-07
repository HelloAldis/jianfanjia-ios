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
    
    
    [RACObserve(self.btnDone, enabled) subscribeNext:^(NSNumber *newValue) {
        if (newValue.boolValue) {
            [self.btnDone setEnableAlpha];
        } else {
            [self.btnDone setDisableAlpha];
        }
    }];
    
    
    RAC(self.btnDone, enabled) = [RACSignal
                                   combineLatest:@[self.textView.rac_textSignal]
                                   reduce:^(NSString *text) {
                                       return @([text trim].length > 0);
                                   }];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"用户反馈";
}

- (IBAction)onClickDone:(id)sender {
    Feedback *request = [[Feedback alloc] init];
    request.content = [self.textView.text trim];
    request.platform = @"1";
    request.version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    @weakify(self);
    [API feedback:request success:^{
        @strongify(self);
        [HUDUtil showSuccessText:@"感谢你的宝贵建议！"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
