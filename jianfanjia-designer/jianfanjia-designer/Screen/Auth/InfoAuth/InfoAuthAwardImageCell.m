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

@interface InfoAuthAwardImageCell ()

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
}

- (void)initWithDesigner:(Designer *)designer award:(AwardDetail *)award isEdit:(BOOL)isEdit actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    self.designer = designer;
    self.award = award;
    self.isEdit = isEdit;
    [self.imgView setImageWithId:award.award_imageid withWidth:kScreenWidth];
    self.tvDesc.text = award.award_description;
    
    [self initActionView:actionBlock];
    [self limitTextViewLength];
    self.actionView.hidden = !isEdit;
    self.tvDesc.userInteractionEnabled = isEdit;
}

- (void)limitTextViewLength {
    @weakify(self);
    [[self.tvDesc.rac_textSignal
      length:^NSInteger{
          return kMaxInfoAuthAwardImageCellDescLength;
      }]
     subscribeNext:^(NSString *value) {
         @strongify(self);
         if ([value trim].length == 0) {
             self.tvDesc.text = [value trim];
         } else {
             self.tvDesc.text = value;
         }

         self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxInfoAuthAwardImageCellDescLength - self.tvDesc.text.length), @(kMaxInfoAuthAwardImageCellDescLength)];
     }];
}

- (void)initActionView:(ProductAuthImageActionViewTapBlock)actionBlock {
    if (!self.actionView) {
        self.actionView = [[ProductAuthImageActionView alloc] initWithFrame:CGRectMake(kScreenWidth - kProductAuthImageActionViewWidth - 30, self.imgViewHeightConst.constant - kProductAuthImageActionViewHeight + 5, kProductAuthImageActionViewWidth, kProductAuthImageActionViewHeight)];
        self.actionView.setCoverImgView.hidden = YES;
        [self.contentView addSubview:self.actionView];
    }
    
    self.actionView.tapBlock = actionBlock;
}

- (void)onTapImgView {
    NSArray *imageArray = [self.designer.award_details map:^(NSDictionary *dict) {
        return [dict objectForKey:@"award_imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imageArray index:[imageArray indexOfObject:self.award.award_imageid]];
}

@end
