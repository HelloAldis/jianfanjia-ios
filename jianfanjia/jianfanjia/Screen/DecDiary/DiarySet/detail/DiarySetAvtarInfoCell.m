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
    [self.avatarImgView setCornerRadius:self.avatarImgView.frame.size.width / 2];
    [self.avatarImgView setBorder:1 andColor:[UIColor whiteColor].CGColor];
    [self.editDiarySetInfoImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEdit)]];
}

- (void)initWithDiarySet:(DiarySet *)diarySet tableView:(UITableView *)tableView {
    self.diarySet = diarySet;
    self.tableView = tableView;
    [self.avatarImgView setUserImageWithId:[GVUserDefaults standardUserDefaults].imageid];
    [self.diarySetBGImgView setImageWithId:diarySet.cover_imageid withWidth:kScreenWidth];

    self.lblDiarySetTitle.text = diarySet.title;
    self.lblBasicInfo.text = [DiaryBusiness diarySetInfo:diarySet];
    self.editDiarySetInfoImgView.hidden = ![DiaryBusiness isOwnDiarySet:diarySet];
}

- (void)onTapEdit {
    [ViewControllerContainer showDiarySetUpload:self.diarySet done:^{
        [self.tableView reloadData];
    }];
}

@end
