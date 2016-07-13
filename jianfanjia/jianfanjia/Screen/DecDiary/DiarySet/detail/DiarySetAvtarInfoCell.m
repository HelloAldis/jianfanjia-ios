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
}

- (UIImage *)getBlurImage {
    return [[self.diarySetBGImgView.image getSubImage:CGRectMake(0, self.diarySetBGImgView.image.size.height - kNavWithStatusBarHeight, kScreenWidth, kNavWithStatusBarHeight)] imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:0.6 alpha:0.36] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

- (void)setCover {
    [self.diarySetBGImgView setImageWithId:self.diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"]];
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
