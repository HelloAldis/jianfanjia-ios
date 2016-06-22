//
//  HomePageDesignerCell.m
//  jianfanjia
//
//  Created by JYZ on 15/10/28.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DecDiary1StatusCell.h"
#import "ViewControllerContainer.h"

@interface DecDiary1StatusCell ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *lblPhase;
@property (weak, nonatomic) IBOutlet UILabel *lblPublishTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgsHeightConst;
@property (weak, nonatomic) IBOutlet YYLabel *msgView;
@property (weak, nonatomic) IBOutlet UIView *imgsView;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UIImageView *zanImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblZan;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (strong, nonatomic) NSMutableArray *picViews;
@property (nonatomic, copy) YYTextAction tapMoreAction;

@property (strong, nonatomic) NSMutableArray *diarys;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation DecDiary1StatusCell

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
    
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeader)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCell)]];
    [self.zanView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickZan)]];
    [self.commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickComment)]];
    
    [self initImageView];
}

- (void)initSuperView {
    self.base_msgHeightConst = self.msgHeightConst;
    self.base_imgsHeightConst = self.imgsHeightConst;
    self.base_msgView = self.msgView;
    self.base_imgsView = self.imgsView;
    self.base_toolbarView = self.toolbarView;
    self.base_zanView = self.zanView;
    self.base_zanImgView = self.zanImgView;
    self.base_lblZan = self.lblZan;
    self.base_commentView = self.commentView;
    self.base_commentImgView = self.commentImgView;
    self.base_lblComment = self.lblComment;
    self.base_picViews = self.picViews;
}

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView truncate:(BOOL)needTruncate {
    self.tableView = tableView;
    self.diarys = diarys;
    self.diary = diary;
    self.diary.layout.needTruncate = needTruncate;
    self.diary.layout.tapMoreAction = self.tapMoreAction;
    [self.diary.layout layout];
    
    [self initHeader];
    [self layoutImageView];
    [self layoutMsg];
    [self initToolbar];
}

#pragma mark - ui
- (void)initHeader {
    self.lblPhase.text = [NSString stringWithFormat:@"%@%@", self.diary.section_label, @"阶段"];
    self.lblPublishTime.text = [NSDate yyyy_Nian_MM_Yue_dd_Ri_HH_mm:self.diary.create_at];
    self.btnDel.hidden = ![DiaryBusiness isOwnDiary:self.diary];
}

#pragma mark - user action
- (void)onTapDel {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除日记？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //Do nothing
    }];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DeleteDiary *request = [[DeleteDiary alloc] init];
        request.diaryid = self.diary._id;
        
        [API deleteDiary:request success:^{
            NSInteger index = [self.diarys indexOfObject:self.diary];
            [self.diarys removeObjectAtIndex:index];
            [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failure:^{
            
        } networkError:^{
            
        }];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [[ViewControllerContainer getCurrentTopController] presentViewController:alert animated:YES completion:nil];
}

- (void)onTapHeader {
    
}

- (void)onTapCell {
    [ViewControllerContainer showDiaryDetail:self.diary showComment:NO toUser:nil];
}

- (void)onClickComment {
    [ViewControllerContainer showDiaryDetail:self.diary showComment:YES toUser:nil];
}

@end
