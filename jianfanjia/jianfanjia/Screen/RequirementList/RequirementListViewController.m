//
//  RequirementListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "RequirementListViewController.h"
#import "RequirementCreateViewController.h"

@interface RequirementListViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
@property (weak, nonatomic) IBOutlet UILabel *lblNoRequirement;

@end

@implementation RequirementListViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
}

#pragma mark - UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCreate:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithR:0xfe g:0x70 b:0x04];
    self.title = @"需求列表";
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor colorWithR:0x34 g:0x4a b:0x5c] forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

#pragma mark - actions
- (IBAction)onClickCreate:(id)sender {
    UIViewController *requirementCreateVC = [[RequirementCreateViewController alloc] initToCreateRequirement];
    [self.navigationController pushViewController:requirementCreateVC animated:YES];
}

@end
