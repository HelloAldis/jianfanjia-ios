//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "OrderDesignerViewController.h"
#import "MatchDesignerCell.h"
#import "IntentDesignerCell.h"
#import "MatchDesignerSection.h"
#import "IntentDesignerSection.h"

@interface OrderDesignerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *matchDesigners;
@property (strong, nonatomic) NSString *userId;

@end

@implementation OrderDesignerViewController

#pragma mark - init method
- (id)initWithMatchDesigner:(NSArray *)matchDesigners {
    if (self = [super init]) {
        _matchDesigners = matchDesigners;
        _userId = [GVUserDefaults standardUserDefaults].userid;
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MatchDesignerCell" bundle:nil] forCellReuseIdentifier:@"MatchDesignerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntentDesignerCell" bundle:nil] forCellReuseIdentifier:@"IntentDesignerCell"];
    
    [self initNav];
}

#pragma mark - UI
- (void)initNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithR:0xfe g:0x70 b:0x04];
    
    UIView *customeTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
    UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    lblCount.text = @"3";
    lblCount.textAlignment = NSTextAlignmentRight;
    lblCount.textColor = [UIColor colorWithR:0xfe g:0x70 b:0x04];
    lblCount.font = [UIFont systemFontOfSize:17];
    UILabel *fixedString = [[UILabel alloc] initWithFrame:CGRectMake(lblCount.frame.size.width, 0, 100, 44)];
    fixedString.text = @" 位可预约";
    fixedString.textColor = [UIColor colorWithR:0x34 g:0x49 b:0x5e];
    fixedString.font = [UIFont systemFontOfSize:17];
    [customeTitleView addSubview:lblCount];
    [customeTitleView addSubview:fixedString];
    self.navigationItem.titleView = customeTitleView;
}


#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MatchDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MatchDesignerCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        IntentDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntentDesignerCell" forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        MatchDesignerSection *section = [MatchDesignerSection sectionView];
        return section;
    } else {
        IntentDesignerSection *section = [IntentDesignerSection sectionView];
        return section;
    }
}

#pragma mark - user action
- (void)onClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickDone {
    
}

@end
