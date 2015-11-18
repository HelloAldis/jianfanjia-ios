//
//  AboutViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/11/18.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end

@implementation AboutViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"关于我们";
}


@end
