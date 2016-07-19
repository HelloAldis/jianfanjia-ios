//
//  SelectionEditCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/17.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "DiarySetAvtarInfoCell.h"
#import "ViewControllerContainer.h"

CGFloat kDiarySetAvtarInfoCellHeight;

@interface DiarySetAvtarInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIImageView *editDiarySetInfoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImgView;

@property (weak, nonatomic) IBOutlet UILabel *lblDiarySetTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBasicInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnModifyCover;

@property (strong, nonatomic) DiarySet *diarySet;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation DiarySetAvtarInfoCell

+ (void)initialize {
    if ([self class] == [DiarySetAvtarInfoCell class]) {
        CGFloat aspect =  1236.0 / kScreenWidth;
        kDiarySetAvtarInfoCellHeight = round(643 / aspect);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btnModifyCover setBorder:1.0 andColor:[UIColor whiteColor].CGColor];
    [self.btnModifyCover setCornerRadius:self.btnModifyCover.frame.size.height / 2.0];
    self.editDiarySetInfoImgView.tintColor = [UIColor whiteColor];
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self.avatarImgView setBorder:1 andColor:[UIColor whiteColor].CGColor];
    self.gradient = [CAGradientLayer layer];
    _gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithR:0x00 g:0x00 b:0x00 a:0.3] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    _gradient.startPoint = CGPointMake(0.5, 1.0);
    _gradient.endPoint = CGPointMake(0.5, 0.0);
    _gradient.locations = @[@0.15, @1.0];
    [self.diarySetBGImgView.layer addSublayer:_gradient];
    
    [self.editDiarySetInfoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEdit)]];
    [self.diarySetBGImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapModifyCover)]];
    
    @weakify(self);
    [[self.btnModifyCover rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onTapModifyCover];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect f = self.diarySetBGImgView.frame;
    self.gradient.frame = CGRectMake(0, -kNavWithStatusBarHeight, f.size.width + kScreenWidth, f.size.height + kDiarySetAvtarInfoCellHeight + kNavWithStatusBarHeight * 2);
    self.blurImgView.frame = f;
}

- (void)initWithDiarySet:(DiarySet *)diarySet tableView:(UITableView *)tableView {
    self.diarySet = diarySet;
    self.tableView = tableView;
    [self.avatarImgView setUserImageWithId:diarySet.author.imageid];
    [self setCover];

    self.lblDiarySetTitle.text = diarySet.title;
    self.lblBasicInfo.text = [DiaryBusiness diarySetInfo:diarySet];
    self.editDiarySetInfoImgView.hidden = ![DiaryBusiness isOwnDiarySet:diarySet];
    if ([DiaryBusiness isOwnDiarySet:diarySet]) {
        self.btnModifyCover.hidden = diarySet.cover_imageid.length > 0;
    } else {
        self.btnModifyCover.hidden = YES;
    }
}

- (void)updateSubViewsAlpha:(CGFloat)alpha {
    self.avatarImgView.alpha = alpha;
    self.lblBasicInfo.alpha = alpha;
    self.lblDiarySetTitle.alpha = alpha;
    self.editDiarySetInfoImgView.alpha = alpha;
    self.btnModifyCover.alpha = alpha;
    self.blurImgView.alpha = 1 - alpha;
}

- (void)getTopBlurImage:(void(^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGRect frame;
        CGFloat width = self.blurImgView.image.size.width;
        CGFloat height = self.blurImgView.image.size.height;
        CGFloat scale = (height / width) / (self.blurImgView.frame.size.height / self.blurImgView.frame.size.width);
        if (scale < 0.99 || isnan(scale)) { // 宽图
            frame = CGRectMake((width - kScreenWidth) / 2.0, kDiarySetAvtarInfoCellHeight - kNavWithStatusBarHeight, kScreenWidth, kNavWithStatusBarHeight);
        } else { // 高图
            frame = CGRectMake(0, (height - kDiarySetAvtarInfoCellHeight) / 2.0 + kDiarySetAvtarInfoCellHeight - kNavWithStatusBarHeight, kScreenWidth, kNavWithStatusBarHeight);
        }
        
        UIImage *blurImage = [self.blurImgView.image getSubImage:frame];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(blurImage);
            }
        });
    });
}

- (UIImage *)getBlurImage {
    return [self.diarySetBGImgView.image imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:0.6 alpha:0.36] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (void)setupBlurImageView {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *blurImage = [self getBlurImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blurImgView.image = blurImage;
        });
    });
}

- (void)setCover {
    [self setupBlurImageView];
    @weakify(self);
    [self.diarySetBGImgView setImageWithId:self.diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"] completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
        @strongify(self);
        if (stage == JYZWebImageStageFinished) {
            [self setupBlurImageView];
        }
    }];
}

- (void)onTapEdit {
    [ViewControllerContainer showDiarySetUpload:self.diarySet done:nil];
}

- (void)onTapModifyCover {
    if (![DiaryBusiness isOwnDiarySet:self.diarySet]) {
        return;
    }
    
    [PhotoUtil showUserAvatarSelector:[ViewControllerContainer getCurrentTopController] inView:self withBlock:^(NSArray *imageIds, NSArray *imageSizes) {
        self.diarySet.cover_imageid = imageIds[0];
        [self.tableView reloadData];
        
        AddDiarySet *request = [[AddDiarySet alloc] initWithDiarySet:self.diarySet];
        [API updateDiarySet:request success:nil failure:nil networkError:nil];
    }];
}

@end
