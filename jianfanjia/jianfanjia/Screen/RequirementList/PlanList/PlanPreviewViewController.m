//
//  OrderDesignerViewController.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "PlanPreviewViewController.h"
#import "ViewControllerContainer.h"
#import "OrderedDesignerViewController.h"

@interface PlanPreviewViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlanTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDecHouseType;
@property (weak, nonatomic) IBOutlet UILabel *lblDecHouseTypeVal;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decAreaTopConstraint;
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
@property (strong, nonatomic) Requirement *requirement;
@property (assign, nonatomic) PlanSource from;
@property (copy, nonatomic) void(^refreshBlock)(void);

@end

@implementation PlanPreviewViewController

#pragma mark - init method
- (id)initWithPlan:(Plan *)plan forRequirement:(Requirement *)requirement from:(PlanSource)from refresh:(void(^)(void))refreshBlock {
    if (self = [super init]) {
        _plan = plan;
        _requirement = requirement;
        _from = from;
        _refreshBlock = refreshBlock;
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
    self.navigationItem.rightBarButtonItem.tintColor = kFinishedColor;
    
    self.title = self.plan.name;
}

- (void)initUI {
    [self.btnPriceDetail setBorder:1 andColor:kFinishedColor.CGColor];
    [self.btnPriceDetail setCornerRadius:5];
    [self.imgScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)]];
    
    @weakify(self);
    [self.plan.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(idx * kScreenWidth, 0, kScreenWidth, self.imgScrollView.bounds.size.height);
        [imgView setImageWithId:obj withWidth:kScreenWidth];
        [self.imgScrollView addSubview:imgView];
    }];
    
    self.imgScrollView.contentSize = CGSizeMake(kScreenWidth * self.plan.images.count, self.imgScrollView.bounds.size.height);
    self.imgScrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl.numberOfPages = self.plan.images.count;
    self.pageControl.hidden = self.plan.images.count <= 1;
    self.lblPlanTitle.text = [self.requirement.dec_type isEqualToString:kDecTypeHouse] ? [NSString stringWithFormat:@"%@%@期", self.requirement.cell, self.requirement.cell_phase] : self.requirement.cell;
    self.lblDecHouseTypeVal.text = [NameDict nameForHouseType:self.requirement.house_type];
    if (![self.requirement.dec_type isEqualToString:kDecTypeHouse]) {
        self.lblDecHouseType.text = @"";
        self.lblDecHouseTypeVal.text = @"";
        self.decAreaTopConstraint.constant = 0;
    }
    
    self.lblDecAreaVal.text = [NSString stringWithFormat:@"%@m²", self.requirement.house_area];
    self.lblDecTypeVal.text = [NameDict nameForDecStyle:self.requirement.dec_type];
    self.lblWorkTypeVal.text = [NameDict nameForWorkType:self.requirement.work_type];
    self.lblDurationVal.text = [NSString stringWithFormat:@"%@天", self.plan.duration];
    self.lblProjectPriceVal.text = [NSString stringWithFormat:@"%@元", self.plan.total_price];
    self.lblDesignDescriptionVal.text = self.plan.plan_description;
    
    [[self.btnPriceDetail rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onChoosePriceDetail];
    }];
    
    [[self.btnChoosePlan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onChoosePlan];
    }];
    
    NSString *status = self.plan.status;
    NSString *requiremntStatus = self.requirement.status;
    if ([status isEqualToString:kPlanStatusPlanWasChoosed]
        || [requiremntStatus isEqualToString:kRequirementStatusPlanWasChoosedWithoutAgreement]
        || [requiremntStatus isEqualToString:kRequirementStatusConfiguredAgreementWithoutWorkSite]
        || [requiremntStatus isEqualToString:kRequirementStatusConfiguredWorkSite]
        || [requiremntStatus isEqualToString:kRequirementStatusFinishedWorkSite]) {
        self.btnChoosePlan.enabled = NO;
        self.btnChoosePlan.backgroundColor = kUntriggeredColor;
    } else {
        self.btnChoosePlan.enabled = YES;
        self.btnChoosePlan.backgroundColor = kFinishedColor;
    }
}

#pragma mark - scroll view deleaget
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.imgScrollView) {
        NSInteger index = self.imgScrollView.contentOffset.x/kScreenWidth;
        self.pageControl.currentPage = index;
    }
}

#pragma mark - user action
- (void)onTapImage:(UIGestureRecognizer *)gesture {
    if (self.plan.images.count > 0) {
        [ViewControllerContainer showOnlineImages:self.plan.images index:self.pageControl.currentPage];
    }
}

- (void)onChoosePriceDetail {
    [ViewControllerContainer showPlanPriceDetail:self.plan];
}

- (void)onChoosePlan {
    @weakify(self);
    [MessageAlertViewController presentAlert:@"选定方案" msg:@"您确定要选定此方案吗？" second:nil rejectTitle:@"取消" reject:nil agreeTitle:@"确定" agree:^{
        @strongify(self);
        ChoosePlan *request = [[ChoosePlan alloc] init];
        request.planid = self.plan._id;
        request.designerid = self.plan.designerid;
        request.requirementid = self.plan.requirementid;
        
        [API choosePlan:request success:^{
            if (self.refreshBlock) {
                self.refreshBlock();
            }
            
            if (self.from == PlanSourceOrderDesignder) {
                [self navigateToOrderedDesignerScreen];
            } else {
                [self onClickBack];
            }
        } failure:^{
            
        } networkError:^{
            
        }];
    }];
}

- (void)navigateToOrderedDesignerScreen {
    NSArray *controllers = [[self.navigationController.viewControllers reverseObjectEnumerator] allObjects];
    UIViewController *purposeController = nil;
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[OrderedDesignerViewController class]]) {
            purposeController = controller;
            break;
        }
    }
    
    [self.navigationController popToViewController:purposeController animated:YES];
}

@end
