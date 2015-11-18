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
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"用户反馈";
}

- (IBAction)onClickDone:(id)sender {
    
}

@end
