//
//  MeViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetUploadViewController.h"
#import "ViewControllerContainer.h"
#import "CellEditComponent.h"

#define kBottomInsert 80

@interface DiarySetUploadViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr2;
@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@property (nonatomic, strong) DiarySet *diarySet;
@property (nonatomic, strong) DiarySet *srcDiarySet;
@property (nonatomic, strong) DiarySetUploadDoneBlock done;

@end

@implementation DiarySetUploadViewController

- (instancetype)initWithDiarySet:(DiarySet *)diarySet done:(DiarySetUploadDoneBlock)done {
    if (self = [super init]) {
        _done = done;
        _srcDiarySet = diarySet;
        if (diarySet) {
            _diarySet = [[DiarySet alloc] init];
            [_diarySet merge:diarySet];
        } else {
            _diarySet = [[DiarySet alloc] init];
            _diarySet._id = @"";
            _srcDiarySet = [[DiarySet alloc] init];
            [_srcDiarySet merge:_diarySet];
        }
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    @weakify(self);
//    [self jfj_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, BOOL isShowing) {
//        @strongify(self);
//        if (isShowing) {
//            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert + keyboardRect.size.height, 0);
//            UIView *view = [self.tableView getFirstResponder];
//            CGRect rect = [self.tableView convertRect:view.bounds fromView:view.superview];
//            [self.tableView scrollRectToVisible:rect animated:YES];
//        } else {
//            self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
//        }
//    } completion:nil];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self jfj_unsubscribeKeyboard];
//}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
    self.title = @"日记本信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kBottomInsert, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [EditCellItem registerCells:self.tableView];
    
    @weakify(self);
    self.sectionArr1 = @[
                         [EditCellItem createField:@"日记本标题" value:self.diarySet.title placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.diarySet.title = curItem.value;
                             }
                         }],
                         ];
    
    self.sectionArr2 = @[
                         [EditCellItem createAttrField:[@"面积 (m²)" attrSubStr:@"(m²)" font:[UIFont systemFontOfSize:12] color:kTextColor] attrValue:self.diarySet.house_area ? [[NSMutableAttributedString alloc] initWithString:[self.diarySet.house_area stringValue]] : nil placeholder:@"请输入" itemEditBlock:^(EditCellItem *curItem, EditCellItemEditType itemEditType) {
                             @strongify(self);
                             if (itemEditType ==  EditCellItemEditTypeChange) {
                                 self.diarySet.house_area = @([curItem.value integerValue]);
                             }
                         } length:6 keyboard:UIKeyboardTypeNumberPad],
                         [EditCellItem createSelection:@"户型" value:[NameDict nameForHouseType:self.diarySet.house_type] allowsEdit:YES placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [self.view endEditing:YES];
                             SelectHouseTypeViewController *controller = [[SelectHouseTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForHouseType:value];
                                 self.diarySet.house_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.diarySet.house_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"装修风格" value:[NameDict nameForDecStyle:self.diarySet.dec_style] allowsEdit:YES placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [self.view endEditing:YES];
                             SelectDecorationStyleViewController *controller = [[SelectDecorationStyleViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForDecStyle:value];
                                 self.diarySet.dec_style = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.diarySet.dec_style];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                         }],
                         [EditCellItem createSelection:@"包工类型" value:[NameDict nameForWorkType:self.diarySet.work_type] allowsEdit:YES placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
                             @strongify(self);
                             [self.view endEditing:YES];
                             SelectWorkTypeViewController *controller = [[SelectWorkTypeViewController alloc] initWithValueBlock:^(id value) {
                                 curItem.value = [NameDict nameForWorkType:value];
                                 self.diarySet.work_type = value;
                                 
                                 [self.tableView reloadData];
                             } curValue:self.diarySet.work_type];
                             
                             [self.navigationController pushViewController:controller animated:YES];
                             
                         }]
                         ];
    
    self.totalArr = [NSMutableArray array];
    [self.totalArr addObjectsFromArray:self.sectionArr1];
    [self.totalArr addObjectsFromArray:self.sectionArr2];
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
        return self.sectionArr1.count;
    } else if (section == 1) {
        return self.sectionArr2.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr2[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath allowsEdit:YES];
        return cell;
    }
    
    return nil;
}

#pragma mark - user action
- (void)onClickBack {
    [self.view endEditing:YES];
    
    if ([self hasDataChanged]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出日记本编辑？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //Do nothing
        }];
        
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [super onClickBack];
        }];
        
        [alert addAction:cancel];
        [alert addAction:done];
        
        [[ViewControllerContainer getCurrentTopController] presentViewController:alert animated:YES completion:nil];
    } else {
        [super onClickBack];
    }
}

- (void)onClickNext {
    AddDiarySet *request = [[AddDiarySet alloc] initWithDiarySet:self.diarySet];
    [HUDUtil showWait];
    if ([self isNewDiarySet]) {
        [API addDiarySet:request success:^{
            DiarySet *diarySet = [[DiarySet alloc] initWith:[DataManager shared].data];
            [ViewControllerContainer showDiarySetDetail:diarySet fromNewDiarySet:YES];
            if (self.done) {
                self.done();
            }
        } failure:^{
            
        } networkError:^{
            
        }];
    } else {
        [API updateDiarySet:request success:^{
            [self.srcDiarySet merge:self.diarySet];
            [ViewControllerContainer showDiarySetDetail:self.diarySet fromNewDiarySet:NO];
            if (self.done) {
                self.done();
            }
        } failure:^{
            
        } networkError:^{
            
        }];
    }
}

#pragma mark - other
- (BOOL)isNewDiarySet {
    return self.diarySet == nil || self.diarySet._id == nil || [self.diarySet._id isEqualToString:@""];
}

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

- (BOOL)hasDataChanged {
    if (![NSString compareStrWithIgnoreNil:self.srcDiarySet.title other:self.diarySet.title]
        || ![NSNumber compareNumWithIgnoreNil:self.srcDiarySet.house_area other:self.diarySet.house_area]
        || ![NSString compareStrWithIgnoreNil:self.srcDiarySet.house_type other:self.diarySet.house_type]
        || ![NSString compareStrWithIgnoreNil:self.srcDiarySet.dec_style other:self.diarySet.dec_style]
        || ![NSString compareStrWithIgnoreNil:self.srcDiarySet.work_type other:self.diarySet.work_type]) {
        return YES;
    }
    
    return NO;
}

@end
