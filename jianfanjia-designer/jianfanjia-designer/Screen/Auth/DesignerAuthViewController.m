//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerAuthViewController.h"
#import "DesignerAuthCell.h"
#import "ViewControllerContainer.h"

static const NSInteger COUNT_IN_ONE_ROW = 2;
static const NSInteger CELL_SPACE = 0;
static const NSInteger SECTION_LEFT = 0;

static NSString *DesignerAuthCellIdentifier = @"DesignerAuthCell";
static NSArray *cellArr = nil;
static NSArray *authArr = nil;

@interface DesignerAuthViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) Designer *designer;

@end

@implementation DesignerAuthViewController

+ (void)initialize {
    if ([self class] == [DesignerAuthViewController class]) {
        cellArr = @[AuthCellTypeBasicInfo,
                    AuthCellTypeUid,
                    AuthCellTypeProduct,
                    AuthCellTypeTeam,
                    AuthCellTypeEmail,
                    ];
        authArr = @[@"0",
                    @"0",
                    @"",
                    @"0",
                    @"0",
                    ];
    }
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshInfo];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"设计师认证中心";
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:DesignerAuthCellIdentifier bundle:nil] forCellWithReuseIdentifier:DesignerAuthCellIdentifier];
    
    self.collectionLayout.minimumLineSpacing = CELL_SPACE;
    self.collectionLayout.minimumInteritemSpacing = CELL_SPACE;
    CGFloat cellWidth = (kScreenWidth - SECTION_LEFT * 2 - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    self.collectionLayout.itemSize = CGSizeMake(cellWidth, kDesignerAuthCellHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cellArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DesignerAuthCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DesignerAuthCellIdentifier forIndexPath:indexPath];
    [cell initWithDesigner:self.designer cellType:cellArr[indexPath.row] authType:authArr[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType = cellArr[indexPath.row];
    
    if ([cellType isEqualToString:AuthCellTypeBasicInfo]) {
        [ViewControllerContainer showInfoAuth:self.designer canEdit:YES];
    } else if ([cellType isEqualToString:AuthCellTypeUid]) {
        [ViewControllerContainer showIDAuth:self.designer];
    } else if ([cellType isEqualToString:AuthCellTypeProduct]) {
        [ViewControllerContainer showProductAuth];
    } else if ([cellType isEqualToString:AuthCellTypeTeam]) {
        [ViewControllerContainer showTeamAuth];
    } else if ([cellType isEqualToString:AuthCellTypeEmail]) {
        if ([self.designer.email_auth_type isEqualToString:kAuthTypeUnsubmitVerify] || [self.designer.email_auth_type isEqualToString:kAuthTypeVerifyNotPass] || [self.designer.email_auth_type isEqualToString:kAuthTypeBreakRule]) {
            [ViewControllerContainer showEmailAuthRequest:self.designer];
        } else if ([self.designer.email_auth_type isEqualToString:kAuthTypeSubmitedVerifyButNotPass]) {
            [ViewControllerContainer showEmailAuthReviewing:self.designer];
        } else if ([self.designer.email_auth_type isEqualToString:kAuthTypeVerifyPass]) {
            [ViewControllerContainer showEmailAuthSuccess:self.designer];
        }
    }
}

- (void)initData {
    NSString *basicAuthType = [GVUserDefaults standardUserDefaults].auth_type;
    NSString *teamAuthType = [GVUserDefaults standardUserDefaults].work_auth_type;
    NSString *uidAuthType = [GVUserDefaults standardUserDefaults].uid_auth_type;
    NSString *emailAuthType = [GVUserDefaults standardUserDefaults].email_auth_type;
    
    authArr = @[basicAuthType,
                uidAuthType,
                @"",
                teamAuthType,
                emailAuthType,
                ];
    
    [self.collectionView reloadData];
}

#pragma mark - api request
- (void)refreshInfo {
    DesignerGetInfo *request = [[DesignerGetInfo alloc] init];
    [API designerGetInfo:request success:^{
        self.designer = [[Designer alloc] initWith:[DataManager shared].data];
        [self initData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

@end
