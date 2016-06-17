//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "AddDiaryViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"
#import "AddDiaryDescCell.h"
#import "AddDiaryImgsCell.h"

#define kBottomInsert 80

static NSString *AddDiaryDescCellIdentifier = @"AddDiaryDescCell";
static NSString *AddDiaryImgsCellIdentifier = @"AddDiaryImgsCell";

@interface AddDiaryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@property (nonatomic, strong) NSArray<DiarySet *> *diarySets;
@property (nonatomic, strong) Diary *diary;

@end

@implementation AddDiaryViewController

- (instancetype)initWithDiarySets:(NSArray<DiarySet *> *)diarySets {
    if (self = [super init]) {
        _diarySets = diarySets;
        _diary = [[Diary alloc] init];
        _diary._id = @"";
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @weakify(self);
    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
        @strongify(self);
        if (isShowing) {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert + keyboardRect.size.height, 0);
            UIView *view = [self.tableView getFirstResponder];
            CGRect rect = [self.tableView convertRect:view.bounds fromView:view.superview];
            [self.tableView scrollRectToVisible:rect animated:YES];
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
        }
    } completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jfj_unsubscribeKeyboard];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"新建日记";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.rightBarButtonItem.tintColor = kTextColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:AddDiaryDescCellIdentifier bundle:nil] forCellReuseIdentifier:AddDiaryDescCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:AddDiaryImgsCellIdentifier bundle:nil] forCellReuseIdentifier:AddDiaryImgsCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [EditCellItem registerCells:self.tableView];
    
    @weakify(self);
    self.sectionArr1 = @[
                         [EditCellItem createSelection:@"装修阶段" value:nil allowsEdit:YES placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [self.view endEditing:YES];
                         }],
                         [EditCellItem createAttrSelection:[@"当前日记本" attrStrWithFont:[UIFont systemFontOfSize:14] color:kTextColor] attrValue:[@"心想压住" attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeColor] allowsEdit:YES placeholder:nil tapBlock:^(EditCellItem *curItem) {
                            
                         }]
                         ];
    
    self.totalArr = [NSMutableArray array];
    [self.totalArr addObjectsFromArray:self.sectionArr1];
    [self refreshNextButtonStatus];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return self.sectionArr1.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                AddDiaryDescCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDiaryDescCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell initWithDiary:self.diary];
                return cell;
            } else if (indexPath.row == 1) {
                AddDiaryImgsCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDiaryImgsCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell initWithDiary:self.diary];
                return cell;
            }
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    }
    
    return nil;
}

#pragma mark - user action
- (void)onClicCancel {
    
}

- (void)onClickNext {
//    AddDiarySet *request = [[AddDiarySet alloc] initWithDiarySet:self.diarySet];
//    [HUDUtil showWait];
//    if ([self isNewDiarySet]) {
//        [API addDiarySet:request success:^{
//            DiarySet *diarySet = [[DiarySet alloc] initWith:[DataManager shared].data];
//            [ViewControllerContainer showDiarySetDetail:diarySet];
//        } failure:^{
//            
//        } networkError:^{
//            
//        }];
//    } else {
//        [API updateDiarySet:request success:^{
//            DiarySet *diarySet = [[DiarySet alloc] initWith:[DataManager shared].data];
//            [ViewControllerContainer showDiarySetDetail:diarySet];
//        } failure:^{
//            
//        } networkError:^{
//            
//        }];
//    }
}

#pragma mark - other
- (void)refreshNextButtonStatus {
    [[RACObserve(self, totalArr) flattenMap:^RACStream *(NSArray *items) {
        NSMutableArray *signals = [NSMutableArray array];
        for (EditCellItem *item in items) {
            [signals addObject:RACObserve(item, value)];
        }
        
        return [RACSignal combineLatest:(signals)];
    }] subscribeNext:^(RACTuple *tuple) {
        __block BOOL isAllInputed = YES;
        [tuple.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]]|| [obj length] == 0) {
                isAllInputed = NO;
                *stop = YES;
            }
        }];
        
        self.navigationItem.rightBarButtonItem.enabled = isAllInputed;
    }];
}

@end
