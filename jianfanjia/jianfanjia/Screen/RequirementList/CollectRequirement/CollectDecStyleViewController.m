//
//  CollectDecStyleViewController.m
//  jianfanjia
//
//  Created by Karos on 15/12/23.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CollectDecStyleViewController.h"
#import "ViewControllerContainer.h"

static const NSInteger DecStyleCount = 7;
static const NSInteger DecStyleWidth = 240;
static const NSInteger MaxCollectedStyleCount = 3;

@interface CollectDecStyleViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblDecStyleVal;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (assign, nonatomic) NSInteger itemSpace;

@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *curCollectedStyles;

@property (assign, nonatomic) NSInteger curPage;
@property (assign, nonatomic) CGFloat preOffsetX;

@end

@implementation CollectDecStyleViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initUI];
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
    
    [self.btnNext setCornerRadius:5];
    [self.btnNext setBackgroundColor:kUntriggeredColor];
    self.btnNext.enabled = NO;
    
    @weakify(self);
    [[self.btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickNext];
    }];
    self.curCollectedStyles = [NSMutableArray array];
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)initUI {
    if (self.scrollView.contentSize.width != 0)
        return;
    
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat firstItemX = (scrollWidth - DecStyleWidth) / 2;
    CGFloat space = [self getBestSpace];
    self.itemSpace = space;
    self.buttonArray = [NSMutableArray arrayWithCapacity:DecStyleCount];
    for (NSInteger i = 0; i < DecStyleCount; i++) {
        CGFloat itemX = (DecStyleWidth + space) * i + (kIsPad ? 0 : firstItemX);
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(itemX, (CGRectGetHeight(self.scrollView.frame) - DecStyleWidth) / 2, DecStyleWidth, DecStyleWidth)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"collect_dec_style_%@", @(i)]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        [button setCornerRadius:DecStyleWidth / 2];
    }
    
    if (!kIsPad) {
        self.scrollView.contentSize = CGSizeMake(firstItemX * 2 + (DecStyleWidth + space) * DecStyleCount - space, DecStyleWidth);
    } else {
        self.scrollView.contentSize = CGSizeMake((DecStyleWidth + space) * DecStyleCount - space, DecStyleWidth);
    }
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
}

#pragma mark - user action
- (void)onClickStyle:(UIButton *)button {
    if ([self.curCollectedStyles containsObject:button]) {
        [self.curCollectedStyles removeObject:button];
        [button setBorder:0 andColor:nil];
    } else if (self.curCollectedStyles.count < MaxCollectedStyleCount) {
        [self.curCollectedStyles addObject:button];
        [button setBorder:4 andColor:kFinishedColor.CGColor];
    }
    
    if (self.curCollectedStyles.count > 0) {
        self.lblDecStyleVal.text = [[self.curCollectedStyles map:^id(id obj) {
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

#pragma mark - util
- (CGFloat)getBestSpace {
    CGFloat bestSpace = 30;
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    if (!kIsPad) {
        CGFloat firstItemX = (scrollWidth - DecStyleWidth) / 2;
        CGFloat secondItemX = scrollWidth - DecStyleWidth / 8;
        CGFloat space = secondItemX - firstItemX - DecStyleWidth;
        
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
    
    if (self.curPage > DecStyleCount - 1) {
        self.curPage = DecStyleCount - 1;
    }

    CGFloat pageSize = DecStyleWidth + self.itemSpace;
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
