//
//  ProcessViewController.m
//  jianfanjia
//
//  Created by JYZ on 15/9/16.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DBYSViewController.h"
#import "ItemImageCollectionCell.h"
#import "ImageDetailViewController.h"
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
@property (strong, nonatomic) NSMutableArray *imgArray;

@end

@implementation DBYSViewController

#pragma mark - init method
- (id)initWithSection:(Section *)section process:(NSString *)processid {
    if (self = [super init]) {
        _section = section;
        _processid = processid;
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
    self.imgCollectionLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.imgCollection addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageGesture:)]];
    self.imgArray = [NSMutableArray arrayWithCapacity:self.section.ys.images.count];
    
    @weakify(self);
    [self.section.ys.images enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.imgArray addObject:[[YsImage alloc] initWith:obj]];
    }];
    
    [self.imgArray sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(YsImage*  _Nonnull obj1, YsImage*  _Nonnull obj2) {
        if ([obj1.key compare:obj2.key] == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if ([obj1.key compare:obj2.key] == NSOrderedDescending) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    [[self.btnConfirmAccept rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        SectionDone *request = [[SectionDone alloc] init];
        request._id = self.processid;
        request.section = self.section.name;
        
        [API sectionDone:request success:^{
            [self clickBack];
        } failure:^{
            
        }];
    }];
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.section.name isEqualToString:SHUI_DIAN]) {
        return SHUI_DIAN_YS * 2;
    } else if ([self.section.name isEqualToString:NI_MU]) {
        return NI_MU_YS * 2;
    } else if ([self.section.name isEqualToString:YOU_QI]) {
        return YOU_QI_YS * 2;
    } else if ([self.section.name isEqualToString:AN_ZHUANG]) {
        return AN_ZHUANG_YS * 2;
    } else if ([self.section.name isEqualToString:JUN_GONG]) {
        return JUN_GONG_YS * 2;
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionCellIdentifier forIndexPath:indexPath];
    
    if ((indexPath.row + 1) % 2 == 0) {
        YsImage *image = self.imgArray[(indexPath.row + 1) / 2 - 1];
        [cell initWithImage:image.imageid width:self.imgCollectionLayout.itemSize.width];
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
        [self showImageDetail:(indexPath.row + 1) / 2 - 1];
    } else {
        
    }
}

- (void)showImageDetail:(NSInteger)index {
    NSArray *images = [self.imgArray map:^id(YsImage *obj) {
        return obj.imageid;
    }];
    
    ImageDetailViewController *imgDetail = [[ImageDetailViewController alloc] initWithOnline:images index:index];
    imgDetail.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[ViewControllerContainer getCurrentTapController] presentViewController:imgDetail animated:YES completion:nil];
}

@end
