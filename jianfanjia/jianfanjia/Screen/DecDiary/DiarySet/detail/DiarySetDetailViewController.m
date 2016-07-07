//
//  DesignerListViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/10/27.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiarySetDetailViewController.h"
#import "DiarySetAvtarInfoCell.h"
#import "DecDiary1StatusCell.h"
#import "DiarySetDetailDataManager.h"
#import "AddDiarySectionView.h"
#import "ViewControllerContainer.h"
#import "WebViewController.h"

static NSString *DiarySetAvtarInfoCellIdentifier = @"DiarySetAvtarInfoCell";
static NSString *DecDiaryStatusCellIdentifier = @"DecDiary1StatusCell";

@interface DiarySetDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIBarButtonItem *favoriteItem;
@property (strong, nonatomic) UIBarButtonItem *shareItem;

@property (strong, nonatomic) UIView *favoriateView;
@property (strong, nonatomic) UIImageView *favoriateImgView;
@property (strong, nonatomic) UILabel *lblFavoriateCount;

@property (strong, nonatomic) AddDiarySectionView *addDiarySectionView;
@property (strong, nonatomic) DiarySetAvtarInfoCell *avtarInfoCell;
@property (assign, nonatomic) BOOL wasFirstLoad;

@property (strong, nonatomic) DiarySetDetailDataManager *dataManager;
@property (strong, nonatomic) DiarySet *diarySet;

@end

@implementation DiarySetDetailViewController

- (instancetype)initWithDiarySet:(DiarySet *)diarySet {
    if (self = [super init]) {
        _diarySet = diarySet;
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
    if (!self.wasFirstLoad) {
        self.wasFirstLoad = YES;
        [self refresh:YES];
    } else {
        [self refresh:NO];
    }
}

#pragma mark - UI
- (void)initNav {
    [self initLeftWhiteBackInNav];
    [self initTransparentNavBar:UIBarStyleBlack];
    
    self.favoriateView = [[UIView alloc] initWithFrame:CGRectZero];
    self.favoriateImgView = [[UIImageView alloc] initWithImage:[self unfavoriateImage]];
    self.lblFavoriateCount = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.favoriateView addSubview:self.favoriateImgView];
    [self.favoriateView addSubview:self.lblFavoriateCount];
    
    self.lblFavoriateCount.text = [self.diarySet.favorite_count humCountString];
    if ([self.diarySet.is_my_favorite boolValue]) {
        [self.favoriteItem.customView setImage:[self favoriateImage]];
    } else {
        [self.favoriteItem.customView setImage:[self unfavoriateImage]];
    }
    
    [self layoutFavoriateView];
    
    @weakify(self);
    [self.favoriateView addTapBounceAnimation:^{
        @strongify(self);
        [self onClickFavoriteButton];
    }];
    self.favoriteItem = [[UIBarButtonItem alloc] initWithCustomView:self.favoriateView];
    self.favoriteItem.customView.tintColor = [UIColor whiteColor];
  
    self.shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_share_1"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickShare)];
    self.shareItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItems = @[self.shareItem, self.favoriteItem];
}

- (void)initUI {
    self.dataManager = [[DiarySetDetailDataManager alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(kNavWithStatusBarHeight, 0, kTabBarHeight, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.estimatedRowHeight = 300;
    [self.tableView registerNib:[UINib nibWithNibName:DiarySetAvtarInfoCellIdentifier bundle:nil] forCellReuseIdentifier:DiarySetAvtarInfoCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:DecDiaryStatusCellIdentifier bundle:nil] forCellReuseIdentifier:DecDiaryStatusCellIdentifier];
    
    self.addDiarySectionView = [AddDiarySectionView addDiarySectionView];
    [self.addDiarySectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAddDiary)]];
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return [DiaryBusiness isOwnDiarySet:self.diarySet] ? kAddDiarySectionViewHeight : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    return [DiaryBusiness isOwnDiarySet:self.diarySet] ? self.addDiarySectionView : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return self.dataManager.diarys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.avtarInfoCell) {
            DiarySetAvtarInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiarySetAvtarInfoCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.avtarInfoCell = cell;
        }
        
        [self.avtarInfoCell initWithDiarySet:self.diarySet tableView:self.tableView];
        return self.avtarInfoCell;
    }
    
    Diary *diary = self.dataManager.diarys[indexPath.row];
    diary.diarySet = self.diarySet;
    diary.author = self.diarySet.author;
    DecDiary1StatusCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DecDiaryStatusCellIdentifier];
    [cell initWithDiary:diary diarys:self.dataManager.diarys tableView:self.tableView hideTopLine:![DiaryBusiness isOwnDiarySet:self.diarySet] && indexPath.row == 0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kDiarySetAvtarInfoCellHeight;
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor *color = [UIColor colorWithR:0xF0 g:0xF5 b:0xF6];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((kNavWithStatusBarHeight - offsetY) / kNavWithStatusBarHeight);
        self.krs_FakeNavigationBar.backgroundColor = [color colorWithAlphaComponent:alpha];
        self.navigationItem.leftBarButtonItem.tintColor = kThemeTextColor;
        self.shareItem.tintColor = kThemeTextColor;
        self.favoriteItem.customView.tintColor = kThemeTextColor;
    } else {
        self.krs_FakeNavigationBar.backgroundColor = [color colorWithAlphaComponent:0];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        self.shareItem.tintColor = [UIColor whiteColor];
        self.favoriteItem.customView.tintColor = [UIColor whiteColor];
    }
}

#pragma mark - api request
- (void)refresh:(BOOL)showPlsWait {
    [self.tableView reloadData];
    if (showPlsWait) {
        [HUDUtil showWait];
    }
    
    GetDiarySetDetail *request = [[GetDiarySetDetail alloc] init];
    request.diarySetid = self.diarySet._id;
    [API getDiarySetDetail:request success:^{
        [self.dataManager refresh];
        [self.diarySet merge:self.dataManager.diarySet];
        self.diarySet.author = self.dataManager.diarySet.author;
        self.diarySet.view_count = self.dataManager.diarySet.view_count;
        [self.tableView reloadData];
    } failure:^{
        
    } networkError:^{
        
    }];
}

#pragma mark - user action
- (void)onTapAddDiary {
    [ViewControllerContainer showDiaryAdd:@[self.diarySet]];
}

- (void)onClickShare {
    if (self.dataManager.diarys.count == 0) {
        [HUDUtil showErrText:@"您还没有发布装修日记哦～"];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"%@（%@）", self.diarySet.title, [DiaryBusiness diarySetInfo:self.diarySet]];
    NSString *description = [NSString stringWithFormat:@"我在简繁家发现了一个不错的装修日记，分享给大家！"];
    [[ShareManager shared] share:[ViewControllerContainer getCurrentTopController] topic:ShareTopicDiary image:self.avtarInfoCell.diarySetBGImgView.image title:title description:description targetLink:[StringUtil mobileUrl:[NSString stringWithFormat:@"tpl/diary/book/%@", self.diarySet._id]] delegate:nil];
}

- (void)onClickFavoriteButton {
    [[LoginEngine shared] showLogin:^(BOOL logined) {
        if (logined) {
            if (![self.diarySet.is_my_favorite boolValue]) {
                [self setFavoriate:YES withAnimation:YES];
                
                FavoriteDiarySet *request = [[FavoriteDiarySet alloc] init];
                request._id = self.diarySet._id;
                
                [API favoriteDiarySet:request success:^{
                    self.diarySet.is_my_favorite = @1;
                    [self.favoriteItem.customView setImage:[self favoriateImage]];
                    [HUDUtil showSuccessText:@"收藏成功"];
                } failure:^{
                    [HUDUtil showErrText:@"收藏失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setFavoriate:NO withAnimation:YES];
                    });
                } networkError:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setFavoriate:NO withAnimation:YES];
                    });
                }];
            } else {
                [self setFavoriate:NO withAnimation:YES];
                
                UnfavoriteDiarySet *request = [[UnfavoriteDiarySet alloc] init];
                request._id = self.diarySet._id;
                
                [API unfavoriteDiarySet:request success:^{
                    self.diarySet.is_my_favorite = @0;
                    [self.favoriteItem.customView setImage:[self unfavoriateImage]];
                    [HUDUtil showSuccessText:@"取消收藏成功"];
                } failure:^{
                    [HUDUtil showErrText:@"取消收藏失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setFavoriate:YES withAnimation:YES];
                    });
                } networkError:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self setFavoriate:YES withAnimation:YES];
                    });
                }];
            }
        }
    }];
}

- (void)layoutFavoriateView {
    CGRect rect = [self.lblFavoriateCount textRectForBounds:CGRectMake(0, 0, NSIntegerMax, 30) limitedToNumberOfLines:1];
    
    self.favoriateImgView.frame = CGRectMake(0, 0, [self favoriateImage].size.width, [self favoriateImage].size.height);
    self.lblFavoriateCount.frame = CGRectMake(12 + CGRectGetMaxX(self.favoriateImgView.frame), (CGRectGetHeight(self.favoriateImgView.frame) - rect.size.height) / 2, rect.size.width, rect.size.height);
    self.favoriateView.frame = CGRectMake(0, 0, CGRectGetMaxX(self.lblFavoriateCount.frame), CGRectGetHeight(self.favoriateImgView.frame));
}

- (UIImage *)favoriateImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"diary_favoriate_yes"];
    });
    return img;
}

- (UIImage *)unfavoriateImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        img = [UIImage imageNamed:@"diary_favoriate_no"];
    });
    return img;
}

- (void)setFavoriate:(BOOL)favoriated withAnimation:(BOOL)animation {
    DiarySet *diary = self.diarySet;
    UIImageView *imgView = self.favoriateImgView;
    UILabel *lblCount = self.lblFavoriateCount;
    if ([diary.is_my_favorite boolValue] == favoriated) return;
    
    UIImage *image = favoriated ? [self favoriateImage] : [self unfavoriateImage];
    int newCount = diary.favorite_count.intValue;
    newCount = favoriated ? newCount + 1 : newCount - 1;
    if (newCount < 0) newCount = 0;
    if (favoriated && newCount < 1) newCount = 1;
    
    NSString *newCountDesc;
    if (newCount > 0) {
        newCountDesc = [@(newCount) humCountString];
    } else {
        newCountDesc = @"";
    }
    
    diary.is_my_favorite = [NSNumber numberWithBool:favoriated];
    diary.favorite_count = @(newCount);
    
    if (!animation) {
        imgView.image = image;
        lblCount.text = newCountDesc;
        return;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [imgView.layer setValue:@(1.7) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        imgView.image = image;
        lblCount.text = newCountDesc;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [imgView.layer setValue:@(0.9) forKeyPath:@"transform.scale"];
            [self layoutFavoriateView];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [imgView.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:^(BOOL finished) {
            }];
        }];
    }];
}

@end
