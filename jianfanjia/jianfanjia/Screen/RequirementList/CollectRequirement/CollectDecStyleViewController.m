//
//  CollectDecStyleViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CollectDecStyleViewController.h"
#import "ViewControllerContainer.h"
#import "TouchDelegateView.h"

static const NSInteger DecStyleCount = 7;
static const NSInteger DecStyleWidth = 240;
static const NSInteger DecStyleItemSpace = 30;
static const NSInteger MaxCollectedStyleCount = 3;

@interface CollectDecStyleViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet TouchDelegateView *styleView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDecStyleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *curCollectedStyles;
@property (assign, nonatomic) NSInteger pageSize;

@end

@implementation CollectDecStyleViewController

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
    
    self.curCollectedStyles = [NSMutableArray array];
    self.pageSize = DecStyleWidth + DecStyleItemSpace;
    
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

    self.buttonArray = [NSMutableArray arrayWithCapacity:DecStyleCount];
    for (NSInteger i = 0; i < DecStyleCount; i++) {
        CGFloat itemX = (self.pageSize) * i + DecStyleItemSpace / 2;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemX, (CGRectGetHeight(self.scrollView.frame) - DecStyleWidth) / 2, DecStyleWidth, DecStyleWidth)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"collect_dec_style_%@", @(i)]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        [button setCornerRadius:DecStyleWidth / 2];
    }
    
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat lastItemExtraContentWidth = scrollWidth - DecStyleWidth;
    self.scrollView.contentSize = CGSizeMake((self.pageSize) * DecStyleCount - DecStyleItemSpace + lastItemExtraContentWidth, DecStyleWidth);
}

#pragma mark - user action
- (void)onClickStyle:(UIButton *)button {
    if ([self.curCollectedStyles containsObject:button]) {
        [self.curCollectedStyles removeObject:button];
        [button setBorder:0 andColor:nil];
    } else if (self.curCollectedStyles.count < MaxCollectedStyleCount) {
        [self.curCollectedStyles addObject:button];
        [button setBorder:4 andColor:kFinishedColor.CGColor];
    } else {
        UIButton *firstButton = [self.curCollectedStyles objectAtIndex:0];
        [self.curCollectedStyles removeObjectAtIndex:0];
        [firstButton setBorder:0 andColor:nil];
        [self.curCollectedStyles addObject:button];
        [button setBorder:4 andColor:kFinishedColor.CGColor];
    }
    
    if (self.curCollectedStyles.count > 0) {
        NSArray *sortedArr = [self.curCollectedStyles sortedArrayWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(UIButton*  _Nonnull obj1, UIButton*  _Nonnull obj2) {
            if (obj1.tag < obj2.tag) {
                return NSOrderedAscending;
            } else if (obj1.tag > obj2.tag) {
                return NSOrderedDescending;
            }
            
            return NSOrderedSame;
        }];
        
        self.lblDecStyleVal.text = [[sortedArr map:^id(id obj) {
            NSInteger index = [self.buttonArray indexOfObject:obj];
            
            return [NameDict nameForDecStyle:[@(index) stringValue]];
        }] join:@", "];
        self.lblDecStyleVal.textColor = kFinishedColor;
        [self.btnNext setBackgroundColor:kFinishedColor];
        self.btnNext.enabled = YES;
    } else {
        self.lblDecStyleVal.text = @"装修风格";
        self.lblDecStyleVal.textColor = kThemeTextColor;
        [self.btnNext setBackgroundColor:kUntriggeredColor];
        self.btnNext.enabled = NO;
    }
}

- (void)onClickNext {
    [DataManager shared].collectedDecStyle = [self.curCollectedStyles map:^id(id obj) {
        NSInteger index = [self.buttonArray indexOfObject:obj];
        return [@(index) stringValue];
    }];
    [ViewControllerContainer showCollectFamilyInfo];
}

@end
