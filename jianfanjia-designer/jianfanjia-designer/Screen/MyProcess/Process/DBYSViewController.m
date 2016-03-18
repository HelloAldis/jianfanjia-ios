//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DBYSViewController.h"
#import "ItemImageCollectionCell.h"
#import "ViewControllerContainer.h"
#import "API.h"

static const NSInteger COUNT_IN_ONE_ROW = 2;
static const NSInteger CELL_SPACE = 10;

static const NSInteger SHUI_DIAN_YS = 5;
static const NSInteger NI_MU_YS = 7;
static const NSInteger YOU_QI_YS = 2;
static const NSInteger AN_ZHUANG_YS = 1;
static const NSInteger JUN_GONG_YS = 1;

static NSString *ImageCollectionCellIdentifier = @"ItemImageCollectionCell";

@interface DBYSViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *imgCollectionLayout;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmAccept;

@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) NSString *processid;
@property (copy, nonatomic) void(^refreshBlock)(void);

@property (strong, nonatomic) NSArray *imgArray;

@property (assign, nonatomic) BOOL isEditing;

@end

@implementation DBYSViewController

#pragma mark - init method
- (id)initWithSection:(Section *)section process:(NSString *)processid refresh:(void(^)(void))refreshBlock {
    if (self = [super init]) {
        _section = section;
        _processid = processid;
        _refreshBlock = refreshBlock;
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
    [self initLeftBackInNav];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickEdit)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kRightNavItemFontSize]} forState:UIControlStateNormal];
    
    self.title = @"对比验收";
}

- (void)initUI {
    [self.imgCollection registerNib:[UINib nibWithNibName:ImageCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:ImageCollectionCellIdentifier];
    self.imgCollectionLayout.minimumLineSpacing = CELL_SPACE;
    self.imgCollectionLayout.minimumInteritemSpacing = CELL_SPACE;
    CGFloat cellWidth = (kScreenWidth - 20 - (COUNT_IN_ONE_ROW - 1) * CELL_SPACE) / COUNT_IN_ONE_ROW;
    self.imgCollectionLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    self.imgCollectionLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    NSInteger imgArrCount = [self getDBYSImageCount:self.section];
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:imgArrCount];
    self.imgArray = imgArr;
    for (NSInteger i = 0; i < imgArrCount; i++) {
        YsImage *ysimage = [[YsImage alloc] init];
        ysimage.imageid = @"";
        [imgArr addObject:ysimage];
    }
    
    @weakify(self);
    [self.section.ys.images enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        YsImage *ysimage = [[YsImage alloc] initWith:obj];
        YsImage *ysimg = self.imgArray[[ysimage.key intValue]];
        ysimg.imageid = ysimage.imageid;
    }];
    
    [[self.btnConfirmAccept rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.btnConfirmAccept.enabled = NO;
        self.btnConfirmAccept.backgroundColor = kUntriggeredColor;
        NSInteger totalCount = [self getDBYSImageCount:self.section];
        NSInteger count = [self getCurrentImageCount];
        
        if (count == totalCount) {
            if ([self isAllSectionItemsFinished:self.section]) {
                NotifyUserToDBYS *request = [[NotifyUserToDBYS alloc] init];
                request._id = self.processid;
                request.section = self.section.name;
                
                [API designerNotifyUserToDBYS:request success:^{
                } failure:^{
                } networkError:^{
                }];
            } else {
                [self clickBack];
            }
        } else {
            [self clickBack];
        }
    }];
    
    [[RACObserve(self, imgArray) flattenMap:^RACStream *(NSArray *items) {
        NSMutableArray *signals = [NSMutableArray array];
        for (YsImage *img in items) {
            [signals addObject:RACObserve(img, imageid)];
        }
        
        return [RACSignal combineLatest:(signals)];
    }] subscribeNext:^(id x) {
        [self refreshButtonInBottom];
    }];
}

#pragma mark - util
- (NSInteger)getDBYSImageCount:(Section *)section {
    if ([section.name isEqualToString:SHUI_DIAN]) {
        return SHUI_DIAN_YS;
    } else if ([section.name isEqualToString:NI_MU]) {
        return NI_MU_YS;
    } else if ([section.name isEqualToString:YOU_QI]) {
        return YOU_QI_YS;
    } else if ([section.name isEqualToString:AN_ZHUANG]) {
        return AN_ZHUANG_YS;
    } else if ([section.name isEqualToString:JUN_GONG]) {
        return JUN_GONG_YS;
    }
    
    return 0;
}

- (void)refreshButtonInBottom {
    NSInteger totalCount = [self getDBYSImageCount:self.section];
    NSInteger count = [self getCurrentImageCount];
    
    if ([self.section.status isEqualToString:kSectionStatusAlreadyFinished]) {
        self.btnConfirmAccept.enabled = NO;
        self.btnConfirmAccept.backgroundColor = kUntriggeredColor;
        [self.btnConfirmAccept setTitle:@"已确认对比验收" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else if (count == totalCount) {
        if ([self isAllSectionItemsFinished:self.section]) {
            self.btnConfirmAccept.enabled = YES;
            self.btnConfirmAccept.backgroundColor = kFinishedColor;
            [self.btnConfirmAccept setTitle:@"提醒用户进行对比验收" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            self.btnConfirmAccept.enabled = NO;
            self.btnConfirmAccept.backgroundColor = kUntriggeredColor;
            [self.btnConfirmAccept setTitle:@"其他工序未完工，您还不能提醒业主验收" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    } else {
        self.btnConfirmAccept.enabled = YES;
        self.btnConfirmAccept.backgroundColor = kFinishedColor;
        [self.btnConfirmAccept setTitle:@"确认上传" forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (NSInteger)getCurrentImageCount {
    NSInteger count = 0;
    for (NSInteger i = 0; i < self.imgArray.count; i++) {
        YsImage *img = self.imgArray[i];
        if (![img.imageid isEqualToString:@""]) {
            count++;
        }
    }
    
    return count;
}

- (BOOL)isAllSectionItemsFinished:(Section *)section {
    __block BOOL finished = YES;
    
    NSArray *arr = [section.data objectForKey:@"items"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Item *item = [[Item alloc] initWith:obj];
        if (![item.status isEqualToString:kSectionStatusAlreadyFinished]) {
            finished = NO;
            *stop = YES;
        }
    }];
    
    return finished;
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getDBYSImageCount:self.section] * 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
    
    if ((indexPath.row + 1) % 2 == 0) {
        NSInteger scenceImageIndex = (indexPath.row + 1) / 2 - 1;
        YsImage *image = self.imgArray[scenceImageIndex];
        
        if (![image.imageid isEqualToString:@""]) {
            [cell initWithImage:image.imageid width:self.imgCollectionLayout.itemSize.width];
            if (self.isEditing) {
                [cell endShaking];
                [cell startShaking];
            } else {
                [cell endShaking];
            }
        } else {
            [cell initWithImage:[UIImage imageNamed:@"btn_add_image"]];
        }
    } else {
        [cell initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", self.section.name, @(indexPath.row / 2)]]];
    }
    
    return cell;
}

#pragma mark - gesture
- (void)handleTapImageGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self.imgCollection];
    NSIndexPath *indexPath = [self.imgCollection indexPathForItemAtPoint:point];
    
    if (!indexPath) {
        return;
    }
    
    if ((indexPath.row + 1) % 2 == 0) {
        [self showScenceImageDetail:(indexPath.row + 1) / 2 - 1 indexPath:indexPath];
    } else {
        [self showStandardImageDetail:indexPath.row / 2];
    }
}

- (void)showStandardImageDetail:(NSInteger)index {
    NSInteger imageCount = [self getDBYSImageCount:self.section];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
    for (NSInteger i = 0; i < imageCount; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", self.section.name, @(i)]]];
    }

    [ViewControllerContainer showOfflineImages:images index:index];
}

- (void)showScenceImageDetail:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    YsImage *image = self.imgArray[index];

    if (![image.imageid isEqualToString:@""]) {
        if (self.isEditing) {
            [self deleteImage:index indexPath:indexPath];
            return;
        }
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < self.imgArray.count; i++) {
            YsImage *img = self.imgArray[i];
            if (![img.imageid isEqualToString:@""]) {
                [images addObject:img.imageid];
            }
        }
        
        NSInteger idx = [images indexOfObject:image.imageid];
        [ViewControllerContainer showOnlineImages:images index:idx];
    } else {
        [self showPhotoSelector:[self.imgCollection cellForItemAtIndexPath:indexPath] index:index];
    }
}

#pragma mark - user action 
- (void)onClickEdit {
    self.isEditing = !self.isEditing;
    
    if (self.isEditing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    
    [self.imgCollection reloadData];
}

- (void)deleteImage:(NSInteger)index indexPath:(NSIndexPath *)indexPath {
    YsImage *ysimg = self.imgArray[index];
    ysimg.imageid = @"";
    [self.imgCollection reloadData];
    
    DeleteYsImageFromProcess *request = [[DeleteYsImageFromProcess alloc] init];
    request._id = self.processid;
    request.section = self.section.name;
    request.key = [@(index) stringValue];
    
    [API designerDeleteYsImage:request success:^{
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    } failure:^{
    } networkError:^{
        
    }];
}

- (void)showPhotoSelector:(UIView *)view index:(NSInteger)index {
    @weakify(self);
    [PhotoUtil showDecorationNodeImageSelector:[ViewControllerContainer getCurrentTapController] inView:view max:[self getDBYSImageCount:self.section] - self.imgArray.count withBlock:^(NSArray *imageIds) {
        @strongify(self);
        UploadYsImageToProcess *request = [[UploadYsImageToProcess alloc] init];
        request._id = self.processid;
        request.section = self.section.name;
        request.key = [@(index) stringValue];
        request.imageid = imageIds[0];
        [API designerUploadYsImage:request success:^{
            if (self.refreshBlock) {
                self.refreshBlock();
            }

            YsImage *ysimg = self.imgArray[index];
            ysimg.imageid = imageIds[0];
            [self.imgCollection reloadData];
        } failure:^{
            
        } networkError:^{
            
        }];
        
    }];
}

@end
