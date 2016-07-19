//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecDiaryStatusAllCell.h"
#import "ViewControllerContainer.h"

@interface DecDiaryStatusAllCell ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblPhase;
@property (weak, nonatomic) IBOutlet UILabel *lblPublishTime;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgsHeightConst;
@property (weak, nonatomic) IBOutlet YYLabel *msgView;
@property (weak, nonatomic) IBOutlet UIView *imgsView;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIButton *btnZan;
@property (weak, nonatomic) IBOutlet UIImageView *zanImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblZan;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIImageView *commentImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (strong, nonatomic) NSMutableArray *picViews;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation DecDiaryStatusAllCell

- (void)awakeFromNib {
    [self initSuperView];
    self.msgView.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.msgView.displaysAsynchronously = YES;
    self.msgView.ignoreCommonProperties = YES;
    self.msgView.fadeOnAsynchronouslyDisplay = NO;
    self.msgView.fadeOnHighlight = NO;
    
    @weakify(self);
    [[self.btnDel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onTapDel];
    }];
    
    [self.btnZan setBackgroundImage:[UIImage yy_imageWithColor:kCellHighlightColor] forState:UIControlStateHighlighted];
    [[self.btnZan rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickZan];
    }];
    
    [self.btnComment setBackgroundImage:[UIImage yy_imageWithColor:kCellHighlightColor] forState:UIControlStateHighlighted];
    [[self.btnComment rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self onClickComment];
    }];
    
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAvatar)]];
    
    [self initImageView];
}

- (void)initSuperView {
    self.base_msgHeightConst = self.msgHeightConst;
    self.base_imgsHeightConst = self.imgsHeightConst;
    self.base_msgView = self.msgView;
    self.base_imgsView = self.imgsView;
    self.base_toolbarView = self.toolbarView;
    self.base_zanImgView = self.zanImgView;
    self.base_lblZan = self.lblZan;
    self.base_commentImgView = self.commentImgView;
    self.base_lblComment = self.lblComment;
    self.base_picViews = self.picViews;
}

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView {
    self.tableView = tableView;
    self.diarys = diarys;
    self.diary = diary;
    self.diary.layout.needTruncate = NO;
    [self.diary.layout layout];
    
    [self initHeader];
    [self layoutImageView];
    [self layoutMsg];
    [self initToolbar];
}

#pragma mark - ui
- (void)initHeader {
    if (self.diary.author.imageid.length > 0) {
        [self.avatarImageView setUserImageWithId:self.diary.author.imageid];
    } else {
        [self.avatarImageView setUserImageWithId:self.diary.diarySet.author.imageid];
    }

    self.lblTitle.text = self.diary.diarySet.title;
    self.lblPhase.text = [NSString stringWithFormat:@"%@%@", self.diary.section_label, @"阶段"];
    self.lblPublishTime.text = [self.diary.create_at humDateString];
    self.lblInfo.text = [DiaryBusiness diarySetInfo:self.diary.diarySet];
    self.btnDel.hidden = ![DiaryBusiness isOwnDiary:self.diary];
}

- (void)onTapDel {
    [AlertUtil show:[ViewControllerContainer getCurrentTopController] title:@"确定要删除日记？" cancelBlock:^{
        
    } doneBlock:^{
        DeleteDiary *request = [[DeleteDiary alloc] init];
        request.diaryid = self.diary._id;
        
        [API deleteDiary:request success:^{
            NSInteger index = [self.diarys indexOfObject:self.diary];
            [self.diarys removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.deleteDoneBlock) {
                self.deleteDoneBlock();
            }
        } failure:^{
            
        } networkError:^{
            
        }];
    }];
}

- (void)onClickAvatar {
    [[ViewControllerContainer getCurrentTopController].view endEditing:YES];
    [ViewControllerContainer showDiarySetDetail:self.diary.diarySet fromNewDiarySet:NO];
}

- (void)onClickComment {
    if (self.clickCommentBlock) {
        self.clickCommentBlock();
    }
}

@end
