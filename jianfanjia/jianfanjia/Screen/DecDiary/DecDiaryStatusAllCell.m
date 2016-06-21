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
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (strong, nonatomic) NSMutableArray *picViews;

@property (strong, nonatomic) Diary *diary;
@property (strong, nonatomic) NSMutableArray *diarys;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation DecDiaryStatusAllCell

- (void)awakeFromNib {
    [self.avatarImageView setCornerRadius:30];
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
    
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickAvatar)]];
    [self.zanView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickZan)]];
    [self.commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickComment)]];
    
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(0, 0, 100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.exclusiveTouch = YES;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)]];
        
        [picViews addObject:imageView];
        [self.imgsView addSubview:imageView];
    }
    
    self.picViews = picViews;
}

- (void)initWithDiary:(Diary *)diary diarys:(NSMutableArray *)diarys tableView:(UITableView *)tableView {
    self.tableView = tableView;
    self.diarys = diarys;
    self.diary = diary;
    self.diary.layout.needTruncate = NO;
    [self.diary.layout layout];
    
    [self initHeader];
    [self initImageView];
    [self initMsg];
}

#pragma mark - ui
- (void)initHeader {
    [self.avatarImageView setUserImageWithId:self.diary.author.imageid];
    self.lblTitle.text = self.diary.diarySet.title;
    self.lblPhase.text = [NSString stringWithFormat:@"%@%@", self.diary.section_label, @"阶段"];
    self.lblPublishTime.text = [self.diary.create_at humDateString];
    self.lblInfo.text = [DiaryBusiness diarySetInfo:self.diary.diarySet];
    self.btnDel.hidden = ![DiaryBusiness isOwnDiary:self.diary];
}

- (void)initMsg {
    self.msgHeightConst.constant = self.diary.layout.needTruncate ? self.diary.layout.truncateContentHeight : self.diary.layout.contentHeight;
    self.msgView.textLayout = self.diary.layout.needTruncate ? self.diary.layout.truncateContentLayout : self.diary.layout.contentLayout;
}

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
            if (self.deleteDoneBlock) {
                self.deleteDoneBlock();
            }
        } failure:^{
            
        } networkError:^{
            
        }];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [[ViewControllerContainer getCurrentTopController] presentViewController:alert animated:YES completion:nil];
}

- (void)onTapImage:(UITapGestureRecognizer *)g {
    NSInteger index = [self.picViews indexOfObject:g.view];
    NSArray *imgs = [self.diary.images map:^id(id obj) {
        return obj[@"imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imgs index:index];
}

- (void)onClickAvatar {
    [ViewControllerContainer showDiarySetDetail:self.diary.diarySet fromNewDiarySet:NO];
}

- (void)onClickZan {
    
}

- (void)onClickComment {
    if (self.clickCommentBlock) {
        self.clickCommentBlock();
    }
}

#pragma mark - layout
- (void)initImageView {
    self.imgsHeightConst.constant = self.diary.layout.picHeight;
    NSArray *pics = self.diary.images;
    
    CGFloat imageTop = kPicTopMarging;
    CGSize picSize = self.diary.layout.picSize;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = self.picViews[i];
        if (i >= picsCount) {
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kPicPadding;
                    origin.y = imageTop;
                } break;
                case 4: {
                    origin.x = kPicPadding + (i % 2) * (picSize.width + kPicPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kPicPaddingPic);
                } break;
                default: {
                    origin.x = kPicPadding + (i % 3) * (picSize.width + kPicPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kPicPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            LeafImage *pic = [[LeafImage alloc] initWith:pics[i]];
            
            @weakify(imageView);
            [imageView setImageWithId:pic.imageid withWidth:kScreenWidth completed:^(UIImage *image, NSURL *url, JYZWebImageFromType from, JYZWebImageStage stage, NSError *error) {
                @strongify(imageView);
                if (!imageView) return;
                if (image && stage == YYWebImageStageFinished) {
                    int width = [pic.width intValue];
                    int height = [pic.height intValue];
                    CGFloat scale = (height / width) / (imageView.frame.size.height / imageView.frame.size.width);
                    if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                    } else { // 高图只保留顶部
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                    }
                    
                    if (from != YYWebImageFromMemoryCacheFast) {
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.15;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                        transition.type = kCATransitionFade;
                        [imageView.layer addAnimation:transition forKey:@"contents"];
                    }
                }
                
            }];
        }
    }
}

@end
