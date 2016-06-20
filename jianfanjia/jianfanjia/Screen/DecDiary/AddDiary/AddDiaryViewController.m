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

static NSString *AddDiaryDescCellIdentifier = @"AddDiaryDescCell";
static NSString *AddDiaryImgsCellIdentifier = @"AddDiaryImgsCell";

@interface AddDiaryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<EditCellItem *> *sectionArr1;
@property (nonatomic, strong) NSMutableArray<EditCellItem *> *totalArr;

@property (nonatomic, strong) NSArray<DiarySet *> *diarySets;
@property (nonatomic, strong) NSArray<NSString *> *diarySetsTitles;
@property (nonatomic, strong) EditCellItem *decPhaseItem;
@property (nonatomic, strong) EditCellItem *diarySetItem;

@property (nonatomic, strong) DiarySet *curDiarySet;
@property (nonatomic, strong) Diary *diary;
@property (nonatomic, copy) AddDiaryCompletion completion;

@end

@implementation AddDiaryViewController

- (instancetype)initWithDiarySets:(NSArray<DiarySet *> *)diarySets completion:(AddDiaryCompletion)completion {
    if (self = [super init]) {
        _diarySets = diarySets;
        _completion = completion;
        _diary = [[Diary alloc] init];
        _diary._id = @"";
        _diary.authorid = [GVUserDefaults standardUserDefaults].userid;
    }
    
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initUI];
}

#pragma mark - UI
- (void)initNav {
    self.title = @"新建日记";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack)];
    self.navigationItem.leftBarButtonItem.tintColor = kTextColor;
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onClickNext)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
}

- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:AddDiaryDescCellIdentifier bundle:nil] forCellReuseIdentifier:AddDiaryDescCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:AddDiaryImgsCellIdentifier bundle:nil] forCellReuseIdentifier:AddDiaryImgsCellIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, 0, 0);
    self.tableView.estimatedRowHeight = 300;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [EditCellItem registerCells:self.tableView];
    
    [self initCurDiarySet];
    self.diarySetsTitles = [self.diarySets map:^id(DiarySet *obj) {
        return obj.title;
    }];
    
    @weakify(self);
    self.decPhaseItem = [EditCellItem createSelection:@"装修阶段" value:self.diary.section_label allowsEdit:YES placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
        @strongify(self);
        [self.view endEditing:YES];
        SelectDecorationPhaseViewController *v = [[SelectDecorationPhaseViewController alloc] initWithValueBlock:^(id value) {
            curItem.value = value;
            self.diary.section_label = value;
            [self.tableView reloadData];
        } curValue:self.diary.section_label];
        
        [self.navigationController pushViewController:v animated:YES];
    }];
    
    self.diarySetItem = [EditCellItem createAttrSelection:[@"当前日记本" attrStrWithFont:[UIFont systemFontOfSize:14] color:kTextColor] attrValue:[self.curDiarySet.title attrStrWithFont:[UIFont systemFontOfSize:14] color:kThemeColor] allowsEdit:self.diarySets.count > 1 placeholder:@"请选择" tapBlock:^(EditCellItem *curItem) {
        @strongify(self);
        [self.view endEditing:YES];
        SelectStringViewController *v = [[SelectStringViewController alloc] initWithTitle:@"日记本选择" options:self.diarySetsTitles curValue:self.curDiarySet.title valueBlock:^(id value) {
            curItem.attrValue.mutableString.string = value;
            curItem.value = value;
            [self changeCurDiarySet:value];
            [self.tableView reloadData];
        }];
        
        [self.navigationController pushViewController:v animated:YES];
    }];
    
    self.sectionArr1 = @[self.decPhaseItem,
                         self.diarySetItem
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
                [cell initWithDiary:self.diary tableView:self.tableView];
                return cell;
            } else if (indexPath.row == 1) {
                AddDiaryImgsCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDiaryImgsCellIdentifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell initWithDiary:self.diary tableView:self.tableView];
                return cell;
            }
        }
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.sectionArr1[indexPath.row] dequeueReusableCell:tableView indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else if (indexPath.section == 1) {
        return [self.sectionArr1[indexPath.row] cellheight];
    }
    
    return 0.0;
}

#pragma mark - user action
- (void)onClickBack {
    [self.view endEditing:YES];
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if (self.completion) {
            self.completion(NO);
        }
    }];
}

- (void)onClickNext {
    [self.view endEditing:YES];
    self.diary.diarySetid = self.curDiarySet._id;
    AddDiary *request = [[AddDiary alloc] initWithDiary:self.diary];
    [HUDUtil showWait];
    [API addDiary:request success:^{
        self.curDiarySet.latest_section_label = self.diary.section_label;
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.completion) {
                self.completion(YES);
            }
        }];
    } failure:^{
        
    } networkError:^{
        
    }];
}

#pragma mark - other
- (void)changeCurPhase {
    NSArray *allPhase = [NameDict getAllDecorationPhase];
    if (!self.curDiarySet.latest_section_label) {
        self.diary.section_label = allPhase[0];
        self.decPhaseItem.value = self.diary.section_label;
        return;
    }
    
    NSInteger index = [allPhase indexOfObject:self.curDiarySet.latest_section_label];
    index = MIN(index + 1, allPhase.count - 1);
    self.diary.section_label = allPhase[index];
    self.decPhaseItem.value = self.diary.section_label;
}

- (void)initCurDiarySet {
    if (self.diarySets.count > 0) {
        self.curDiarySet = self.diarySets[0];
    }
    
    [self changeCurPhase];
}

- (void)changeCurDiarySet:(NSString *)title {
    NSInteger index = [self.diarySets indexOfObjectPassingTest:^BOOL(DiarySet * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([title isEqualToString:obj.title]) {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    self.curDiarySet = self.diarySets[index];
    [self changeCurPhase];
}

- (void)refreshNextButtonStatus {
    [[RACObserve(self, totalArr) flattenMap:^RACStream *(NSArray *items) {
        NSMutableArray *signals = [NSMutableArray array];
        [signals addObject:RACObserve(self.diary, content)];
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
