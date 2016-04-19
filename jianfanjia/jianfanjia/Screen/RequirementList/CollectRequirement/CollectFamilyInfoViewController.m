//
//  CollectDecStyleViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CollectFamilyInfoViewController.h"
#import "ViewControllerContainer.h"
#import "TouchDelegateView.h"

static const NSInteger FamilyInfoCount = 4;
static const NSInteger FamilyInfoWidth = 240;
static const NSInteger FamilyInfoItemSpace = 30;
static const NSInteger MaxCollectedFamilyInfoCount = 1;

@interface CollectFamilyInfoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet TouchDelegateView *styleView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDecStyleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *curCollectedFamilys;
@property (assign, nonatomic) NSInteger pageSize;

@end

@implementation CollectFamilyInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initData];
}

#pragma mark - init UI
- (void)initNav {
    self.navigationController.navigationBarHidden = NO;
    [self initLeftBackInNav];

    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey: NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUI {
    [self.btnNext setCornerRadius:5];
    [self.btnNext setBackgroundColor:kUntriggeredColor];
    self.btnNext.enabled = NO;
    
    @weakify(self);
    [[self.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickNext];
    }];
    
    self.curCollectedFamilys = [NSMutableArray array];
    self.pageSize = FamilyInfoWidth + FamilyInfoItemSpace;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    [self.styleView addSubview:self.scrollView];
    self.styleView.touchDelegateView = self.scrollView;
}

- (void)initData {
    if (self.scrollView.contentSize.width != 0)
        return;
    self.scrollView.frame = CGRectMake((CGRectGetWidth(self.styleView.frame) - self.pageSize) / 2, (CGRectGetHeight(self.styleView.frame) - self.pageSize) / 2, self.pageSize, self.pageSize);
    
    self.buttonArray = [NSMutableArray arrayWithCapacity:FamilyInfoCount];
    for (NSInteger i = 0; i < FamilyInfoCount; i++) {
        CGFloat itemX = (self.pageSize) * i + FamilyInfoItemSpace / 2;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemX, (CGRectGetHeight(self.scrollView.frame) - FamilyInfoWidth) / 2, FamilyInfoWidth, FamilyInfoWidth)];
        [button setNormBgImg:[UIImage imageNamed:[NSString stringWithFormat:@"collect_family_info_%@", @(i)]]];
        [button addTarget:self action:@selector(onClickStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        [button setCornerRadius:FamilyInfoWidth / 2];
    }
    
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat lastItemExtraContentWidth = scrollWidth - FamilyInfoWidth;
    self.scrollView.contentSize = CGSizeMake((self.pageSize) * FamilyInfoCount - FamilyInfoItemSpace + lastItemExtraContentWidth, FamilyInfoWidth);
}

#pragma mark - user action
- (void)onClickStyle:(UIButton *)button {
    if ([self.curCollectedFamilys containsObject:button]) {
        [self.curCollectedFamilys removeObject:button];
        [button setBorder:0 andColor:nil];
    } else if (self.curCollectedFamilys.count < MaxCollectedFamilyInfoCount) {
        [self.curCollectedFamilys addObject:button];
        [button setBorder:4 andColor:kFinishedColor.CGColor];
    } else {
        UIButton *firstButton = [self.curCollectedFamilys objectAtIndex:0];
        [self.curCollectedFamilys removeObjectAtIndex:0];
        [firstButton setBorder:0 andColor:nil];
        [self.curCollectedFamilys addObject:button];
        [button setBorder:4 andColor:kFinishedColor.CGColor];
    }
    
    if (self.curCollectedFamilys.count > 0) {
        NSArray *populations = [NameDict getAllPopulationType];
        NSArray *sortedArr = [self.curCollectedFamilys sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(UIButton*  _Nonnull obj1, UIButton*  _Nonnull obj2) {
            if (obj1.tag < obj2.tag) {
                return NSOrderedAscending;
            } else if (obj1.tag > obj2.tag) {
                return NSOrderedDescending;
            }
            
            return NSOrderedSame;
        }];
        
        self.lblDecStyleVal.text = [[sortedArr map:^id(id obj) {
            NSInteger index = [self.buttonArray indexOfObject:obj];
            return populations[index];
        }] join:@", "];
        self.lblDecStyleVal.textColor = kFinishedColor;
        [self.btnNext setBackgroundColor:kFinishedColor];
        self.btnNext.enabled = YES;
    } else {
        self.lblDecStyleVal.text = @"常住人口";
        self.lblDecStyleVal.textColor = kThemeTextColor;
        [self.btnNext setBackgroundColor:kUntriggeredColor];
        self.btnNext.enabled = NO;
    }
}

- (void)onClickNext {
    NSArray *populations = [NameDict getAllPopulationType];
    [DataManager shared].collectedFamilyInfo = [self.curCollectedFamilys map:^id(id obj) {
        NSInteger index = [self.buttonArray indexOfObject:obj];
        return populations[index];
    }][0];
    [self updateUserInfo];
}

- (void)updateUserInfo {
    [HUDUtil showWait];
    UpdateUserInfo *request = [[UpdateUserInfo alloc] init];
    request.dec_progress = [DataManager shared].collectedDecPhase;
    request.dec_styles = [DataManager shared].collectedDecStyle;
    request.family_description = [DataManager shared].collectedFamilyInfo;
    
    [API updateUserInfo:request success:^{
        UserGetInfo *getUser = [[UserGetInfo alloc] init];
        [API userGetInfo:getUser success:^{
            [HUDUtil hideWait];
            [ViewControllerContainer showTab];
        } failure:^{
            [HUDUtil hideWait];
        } networkError:^{
            [HUDUtil hideWait];
        }];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

@end
