//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "InfoAuthAwardImageCell.h"
#import "ViewControllerContainer.h"

#define kMaxInfoAuthAwardImageCellDescLength 140

CGFloat kInfoAuthAwardImageCellHeight;
static CGFloat imageHeight;

@interface InfoAuthAwardImageCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConst;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UITextView *tvDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@property (strong, nonatomic) ProductAuthImageActionView *actionView;
@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) AwardDetail *award;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation InfoAuthAwardImageCell

+ (void)initialize {
    if ([self class] == [InfoAuthAwardImageCell class]) {
        CGFloat aspect =  373.0 / (kScreenWidth  - 44);
        imageHeight = round(280.0 / aspect);
        
        CGSize constrainedSize = CGSizeMake(kScreenWidth - 74  , 9999);
        CGSize size = [NSString sizeWithConstrainedSize:constrainedSize font:[UIFont systemFontOfSize:14.0] maxLength:kMaxInfoAuthAwardImageCellDescLength];
        kInfoAuthAwardImageCellHeight = imageHeight + size.height + 90;
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    if (self.imgViewHeightConst.constant != imageHeight) {
        self.imgViewHeightConst.constant = imageHeight;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tvDesc.delegate = self;
    [self.imgView setCornerRadius:5];
    [self.imgView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.bottomView setCornerRadius:5];
    [self.bottomView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImgView)]];
    
    @weakify(self);
    [self.tvDesc.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.award.award_description = x;
    }];
    
    [self.tvDesc.rac_textSignal subscribeNext:^(NSString *value) {
        @strongify(self);
        [self updateValue];
    }];
}

- (void)initWithDesigner:(Designer *)designer award:(AwardDetail *)award isEdit:(BOOL)isEdit actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    self.designer = designer;
    self.award = award;
    self.isEdit = isEdit;
    [self.imgView setImageWithId:award.award_imageid withWidth:kScreenWidth];
    self.tvDesc.text = award.award_description;
    self.tvDesc.placeholder = isEdit ? @"请输入" : @"";
    [self updateValue];

    [self initActionView:actionBlock];
    self.actionView.hidden = !isEdit;
    self.tvDesc.userInteractionEnabled = isEdit;
}

- (void)initActionView:(ProductAuthImageActionViewTapBlock)actionBlock {
    if (!self.actionView) {
        self.actionView = [[ProductAuthImageActionView alloc] initWithFrame:CGRectMake(kScreenWidth - kProductAuthImageActionViewWidth - 30, imageHeight - kProductAuthImageActionViewHeight + 5, kProductAuthImageActionViewWidth, kProductAuthImageActionViewHeight)];
        self.actionView.setCoverImgView.hidden = YES;
        [self.contentView addSubview:self.actionView];
    }
    
    self.actionView.tapBlock = actionBlock;
}

- (void)onTapImgView {
    NSArray *imageArray = [self.designer.award_details map:^(NSDictionary *dict) {
        return [dict objectForKey:@"award_imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imageArray fromImageView:self.imgView index:[imageArray indexOfObject:self.award.award_imageid]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL flag = YES;
    NSString *curStr = textView.text;
    NSInteger len = curStr.length +  (text.length - range.length);
    NSInteger lenDelta = len - kMaxInfoAuthAwardImageCellDescLength;
    NSInteger replaceToIndex = text.length - lenDelta;
    
    if (lenDelta > 0 && replaceToIndex < text.length) {
        NSString *replaceStr = [text substringToIndex:replaceToIndex];
        
        NSString *updatedStr = [curStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:replaceStr];
        textView.text = updatedStr;
        flag = NO;
        [self updateValue];
    }
    
    return flag;
}

- (void)updateValue {
    NSString *value = self.tvDesc.text;

    self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxInfoAuthAwardImageCellDescLength - value.length), @(kMaxInfoAuthAwardImageCellDescLength)];
}

@end
