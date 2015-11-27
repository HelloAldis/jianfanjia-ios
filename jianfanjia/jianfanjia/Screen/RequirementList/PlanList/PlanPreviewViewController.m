//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanPreviewViewController.h"
#import "ViewControllerContainer.h"

@interface PlanPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDecHouseTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDecAreaVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDecTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblDurationVal;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectPriceVal;
@property (weak, nonatomic) IBOutlet UIButton *btnPriceDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignDescriptionVal;
@property (weak, nonatomic) IBOutlet UIButton *btnChoosePlan;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) Plan *plan;
@property (assign, nonatomic) NSInteger order;
@property (strong, nonatomic) Requirement *requirement;

@end

@implementation PlanPreviewViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan withOrder:(NSInteger)order forRequirement:(Requirement *)requirement {
    if (self = [super init]) {
        _plan = plan;
        _order = order;
        _requirement = requirement;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"详细报价" style:UIBarButtonItemStylePlain target:self action:@selector(onChoosePriceDetail)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithR:0xfe g:0x70 b:0x04];
    
    self.title = [NSString stringWithFormat:@"方案%ld", (long)self.order];
}

- (void)initUI {
    [self.btnPriceDetail setBorder:1 andColor:[UIColor colorWithR:0xFE g:0x70 b:0x04].CGColor];
    [self.btnPriceDetail setCornerRadius:5];
    
    @weakify(self);
    [self.plan.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(idx * kScreenWidth, 0, kScreenWidth, self.imgScrollView.bounds.size.height);
        [imgView setImageWithId:obj withWidth:kScreenWidth];
        [self.imgScrollView addSubview:imgView];
    }];
    
    self.imgScrollView.contentSize = CGSizeMake(kScreenWidth * self.plan.images.count, self.imgScrollView.bounds.size.height);
    
    self.lblPlanTitle.text = [NSString stringWithFormat:@"%@%@期", self.requirement.cell, self.requirement.cell_phase];
    self.lblDecHouseTypeVal.text = [NameDict nameForHouseType:self.requirement.house_type];
    self.lblDecAreaVal.text = [NSString stringWithFormat:@"%@m2", self.requirement.house_area];
    self.lblDecTypeVal.text = [NameDict nameForDecStyle:self.requirement.dec_type];
    self.lblWorkTypeVal.text = [NameDict nameForWorkType:self.requirement.work_type];
    self.lblDurationVal.text = [NSString stringWithFormat:@"%@天", self.plan.duration];
    self.lblProjectPriceVal.text = [NSString stringWithFormat:@"%@元", self.plan.total_price];
    self.lblDesignDescriptionVal.text = self.plan.description;
    
    [[self.btnPriceDetail rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onChoosePriceDetail];
    }];
    
    [[self.btnChoosePlan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onChoosePlan];
    }];
}

#pragma mark - scroll view deleaget
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.imgScrollView) {
        NSInteger index = self.imgScrollView.contentOffset.x/kScreenWidth;
        self.pageControl.currentPage = index;
    }
}

#pragma mark - user action
- (void)onChoosePriceDetail {
    [ViewControllerContainer showPlanPriceDetail:self.plan];
}

- (void)onChoosePlan {
    ChoosePlan *request = [[ChoosePlan alloc] init];
    request.planid = self.plan._id;
    request.designerid = self.plan.designerid;
    request.requirementid = self.plan.requirementid;
    
    [API choosePlan:request success:^{
        [self clickBack];
    } failure:^{
        
    }];
}

@end
