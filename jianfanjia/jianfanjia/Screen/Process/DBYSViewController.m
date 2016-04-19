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
@property (strong, nonatomic) UIViewController *popTo;
@property (copy, nonatomic) void(^refreshBlock)(void);

@property (strong, nonatomic) NSMutableArray *imgArray;

@end

@implementation DBYSViewController

#pragma mark - init method
- (id)initWithSection:(Section *)section process:(NSString *)processid popTo:(UIViewController *)popTo refresh:(void(^)(void))refreshBlock {
    if (self = [super init]) {
        _section = section;
        _processid = processid;
        _popTo = popTo;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)initNav {
    [self initLeftBackInNav];
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
    self.imgArray = [NSMutableArray arrayWithCapacity:imgArrCount];
    for (NSInteger i = 0; i < imgArrCount; i++) {
        [self.imgArray addObject:[[YsImage alloc] init]];
    }
    
    @weakify(self);
    [self.section.ys.images enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        YsImage *ysimage = [[YsImage alloc] initWith:obj];
        YsImage *ysimg = self.imgArray[[ysimage.key intValue]];
        ysimg.imageid = ysimage.imageid;
    }];
    
    [[self.btnConfirmAccept rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MessageAlertViewController presentAlert:@"对比验收" msg:@"您确定要验收吗？" second:nil reject:nil agree:^{
            @strongify(self);
            SectionDone *request = [[SectionDone alloc] init];
            request._id = self.processid;
            request.section = self.section.name;
            
            [API sectionDone:request success:^{
                self.section.status = kSectionStatusAlreadyFinished;
                [self initButtons];
                
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
                
                if (self.popTo) {
                    [self.navigationController popToViewController:self.popTo animated:YES];
                }
            } failure:^{
                
            } networkError:^{
                
            }];
        }];
    }];
    
    [self initButtons];
}

- (void)initButtons {
    NSInteger totalCount = [self getDBYSImageCount:self.section];
    NSInteger count = [self getCurrentImageCount];
    
    if ([self.section.status isEqualToString:kSectionStatusAlreadyFinished]) {
        [self enableConfirmButton:NO title:@"已确认对比验收"];
    } else if (count == totalCount) {
        if ([ProcessBusiness isAllSectionItemsFinished:self.section]) {
            [self enableConfirmButton:YES title:@"确认验收"];
        } else {
            [self enableConfirmButton:NO title:@"工序未完工，您还不能确认验收"];
        }
    } else {
        [self enableConfirmButton:NO title:@"确认验收"];
    }
}

- (void)enableConfirmButton:(BOOL)enable title:(NSString *)title {
    [self.btnConfirmAccept setNormTitle:title];
    [self.btnConfirmAccept enableBgColor:enable];
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

- (NSInteger)getCurrentImageCount {
    NSInteger count = 0;
    for (NSInteger i = 0; i < self.imgArray.count; i++) {
        YsImage *img = self.imgArray[i];
        if (img.imageid) {
            count++;
        }
    }
    
    return count;
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
        
        if (image.imageid) {
            [cell initWithImage:image.imageid width:self.imgCollectionLayout.itemSize.width];
            if (self.isEditing) {
                [cell endShaking];
                [cell startShaking];
            } else {
                [cell endShaking];
            }
        } else {
            [cell initWithImage:[UIImage imageNamed:@"waitToUpload"]];
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
        [self showScenceImageDetail:(indexPath.row + 1) / 2 - 1];
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

- (void)showScenceImageDetail:(NSInteger)index {
    YsImage *image = self.imgArray[index];
    if (image.imageid) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < self.imgArray.count; i++) {
            YsImage *img = self.imgArray[i];
            if (img.imageid) {
                [images addObject:img.imageid];
            }
        }
        
        NSInteger idx = [images indexOfObject:image.imageid];
        [ViewControllerContainer showOnlineImages:images index:idx];
    }
}

@end
