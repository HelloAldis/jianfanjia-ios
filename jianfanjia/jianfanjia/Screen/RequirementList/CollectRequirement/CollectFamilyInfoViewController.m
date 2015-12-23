//
//  CollectDecStyleViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CollectFamilyInfoViewController.h"
#import "ViewControllerContainer.h"

static const NSInteger FamilyInfoCount = 4;
static const NSInteger FamilyInfoWidth = 240;
static const NSInteger MaxCollectedFamilyInfoCount = 1;

@interface CollectFamilyInfoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDecStyleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (assign, nonatomic) NSInteger itemSpace;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *curCollectedFamilys;

@property (assign, nonatomic) NSInteger curPage;
@property (assign, nonatomic) CGFloat preOffsetX;

@end

@implementation CollectFamilyInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
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
    
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat firstItemX = (scrollWidth - FamilyInfoWidth) / 2;
    CGFloat space = [self getBestSpace];
    self.itemSpace = space;
    self.curCollectedFamilys = [NSMutableArray array];
    self.buttonArray = [NSMutableArray arrayWithCapacity:FamilyInfoCount];
    for (NSInteger i = 0; i < FamilyInfoCount; i++) {
        CGFloat itemX = (FamilyInfoWidth + space) * i + (kIsPad ? 0 : firstItemX);
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemX, (CGRectGetHeight(self.scrollView.frame) - FamilyInfoWidth) / 2, FamilyInfoWidth, FamilyInfoWidth)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"collect_family_info_%@", @(i)]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        [button setCornerRadius:FamilyInfoWidth / 2];
    }
    
    if (!kIsPad) {
        self.scrollView.contentSize = CGSizeMake(firstItemX * 2 + (FamilyInfoWidth + space) * FamilyInfoCount - space, FamilyInfoWidth);
    } else {
        self.scrollView.contentSize = CGSizeMake((FamilyInfoWidth + space) * FamilyInfoCount - space, FamilyInfoWidth);
    }
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
}

#pragma mark - user action
- (void)onClickStyle:(UIButton *)button {
    if ([self.curCollectedFamilys containsObject:button]) {
        [self.curCollectedFamilys removeObject:button];
        [button setBorder:0 andColor:nil];
    } else if (self.curCollectedFamilys.count < MaxCollectedFamilyInfoCount) {
        [self.curCollectedFamilys addObject:button];
        [button setBorder:4 andColor:kFinishedColor.CGColor];
    }
    
    if (self.curCollectedFamilys.count > 0) {
        NSArray *populations = [NameDict getAllPopulationType];
        self.lblDecStyleVal.text = [[self.curCollectedFamilys map:^id(id obj) {
            NSInteger index = [self.buttonArray indexOfObject:obj];
            return populations[index];
        }] join:@", "];
        self.lblDecStyleVal.textColor = kFinishedColor;
        [self.btnNext setBackgroundColor:kFinishedColor];
        self.btnNext.enabled = YES;
    } else {
        self.lblDecStyleVal.text = @"常驻人口";
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
    request.dec_process = [DataManager shared].collectedDecPhase;
    request.dec_styles = [DataManager shared].collectedDecStyle;
    request.family_description = [DataManager shared].collectedFamilyInfo;
    
    [API updateUserInfo:request success:^{
        [HUDUtil hideWait];
        [ViewControllerContainer showSignupSuccess];
    } failure:^{
        [HUDUtil hideWait];
    } networkError:^{
        [HUDUtil hideWait];
    }];
}

#pragma mark - util
- (CGFloat)getBestSpace {
    CGFloat bestSpace = 30;
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    if (!kIsPad) {
        CGFloat firstItemX = (scrollWidth - FamilyInfoWidth) / 2;
        CGFloat secondItemX = scrollWidth - FamilyInfoWidth / 8;
        CGFloat space = secondItemX - firstItemX - FamilyInfoWidth;
        
        if (space > bestSpace) {
            bestSpace = space;
        }
    } else {
        bestSpace = 30;
    }
    
    return bestSpace;
}

#pragma mark - scroll view delegate
- (CGPoint)nearestTargetOffset:(CGPoint)curOffset {
    if (curOffset.x > self.preOffsetX) {
        self.curPage++;
    } else if (curOffset.x < self.preOffsetX) {
        self.curPage--;
    }
    
    if (self.curPage < 0) {
        self.curPage = 0;
    }
    
    if (self.curPage > FamilyInfoCount - 1) {
        self.curPage = FamilyInfoCount - 1;
    }

    CGFloat pageSize = FamilyInfoWidth + self.itemSpace;
    CGFloat targetX = pageSize * self.curPage;
    self.preOffsetX = targetX;
    return CGPointMake(targetX, curOffset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGPoint targetOffset = [self nearestTargetOffset:scrollView.contentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

@end
