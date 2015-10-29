//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementListViewController.h"

@interface RequirementListViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *view1;

@end

@implementation RequirementListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapProductImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDesignerImage:)];
    tapProductImage.numberOfTapsRequired = 1;
    tapProductImage.numberOfTouchesRequired = 1;
    [self.view1 addGestureRecognizer:tapProductImage];
}

- (void)onTapDesignerImage:(UIGestureRecognizer *)sender {
    DDLogDebug(@"%@", @"onTapProductImage");
}


@end
