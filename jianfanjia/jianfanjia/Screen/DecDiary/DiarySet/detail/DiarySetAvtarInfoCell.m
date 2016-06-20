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
@property (weak, nonatomic) IBOutlet UIImageView *diarySetBGImgView;
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
    [self.editDiarySetInfoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEdit)]];
    [self.diarySetBGImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapModifyCover)]];
    
    @weakify(self);
    [[self.btnModifyCover rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onTapModifyCover];
    }];
}

- (void)initWithDiarySet:(DiarySet *)diarySet tableView:(UITableView *)tableView {
    self.diarySet = diarySet;
    self.tableView = tableView;
    [self.avatarImgView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    [self setCover];

    self.lblDiarySetTitle.text = diarySet.title;
    self.lblBasicInfo.text = [DiaryBusiness diarySetInfo:diarySet];
    self.editDiarySetInfoImgView.hidden = ![DiaryBusiness isOwnDiarySet:diarySet];
    self.btnModifyCover.hidden = diarySet.cover_imageid;
}

- (void)setCover {
    [self.diarySetBGImgView setImageWithId:self.diarySet.cover_imageid withWidth:kScreenWidth placeholder:[UIImage imageNamed:@"img_diary_set_cover"]];
}

- (void)onTapEdit {
    [ViewControllerContainer showDiarySetUpload:self.diarySet done:^{
        [self.tableView reloadData];
    }];
}

- (void)onTapModifyCover {
    if (![DiaryBusiness isOwnDiarySet:self.diarySet]) {
        return;
    }
    
    [PhotoUtil showUserAvatarSelector:[ViewControllerContainer getCurrentTopController] inView:self withBlock:^(NSArray *imageIds, NSArray *imageSizes) {
        self.diarySet.cover_imageid = imageIds[0];
        [self setCover];
        
        AddDiarySet *request = [[AddDiarySet alloc] initWithDiarySet:self.diarySet];
        [API updateDiarySet:request success:nil failure:nil networkError:nil];
    }];
}

@end
