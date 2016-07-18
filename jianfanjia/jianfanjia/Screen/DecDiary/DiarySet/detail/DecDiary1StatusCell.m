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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineConst;

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
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCell)]];
    
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

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView hideTopLine:(BOOL)hideTopLine {
    self.tableView = tableView;
    self.diarys = diarys;
    self.diary = diary;
    
    [self initHeader];
    [self layoutImageView];
    [self layoutMsg];
    [self initToolbar];
    self.topLineConst.constant = hideTopLine ? 0 : 6;
}

#pragma mark - ui
- (void)initHeader {
    self.lblPhase.text = [NSString stringWithFormat:@"%@%@", self.diary.section_label, @"阶段"];
    self.lblPublishTime.text = [NSDate yyyy_Nian_MM_Yue_dd_Ri_HH_mm:self.diary.create_at];
    self.btnDel.hidden = ![DiaryBusiness isOwnDiary:self.diary];
}

#pragma mark - user action
- (void)onTapDel {
    [AlertUtil show:[ViewControllerContainer getCurrentTopController] title:@"确定要删除日记？" cancelBlock:^{
        
    } doneBlock:^{
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
}

- (void)onTapCell {
    [ViewControllerContainer showDiaryDetail:self.diary showComment:NO toUser:nil deleteDone:^{
        [self.diarys removeObject:self.diary];
    }];
}

- (void)onClickComment {
    [ViewControllerContainer showDiaryDetail:self.diary showComment:YES toUser:nil deleteDone:^{
        [self.diarys removeObject:self.diary];
    }];
}

@end
