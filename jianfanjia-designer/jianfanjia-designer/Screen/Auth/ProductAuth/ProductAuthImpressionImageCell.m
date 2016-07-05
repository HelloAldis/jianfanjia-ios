//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthImpressionImageCell.h"
#import "ViewControllerContainer.h"

#define kMaxProductImpressoinImageDescLength 140

CGFloat kProductAuthImpressionImageCellHeight;
static CGFloat imageHeight;

@interface ProductAuthImpressionImageCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConst;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *selectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblSelection;
@property (weak, nonatomic) IBOutlet UITextView *tvDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblLeftLength;

@property (strong, nonatomic) ProductAuthImageActionView *actionView;
@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) ProductImage *image;

@end

@implementation ProductAuthImpressionImageCell

+ (void)initialize {
    if ([self class] == [ProductAuthImpressionImageCell class]) {
        CGFloat aspect =  373.0 / (kScreenWidth  - 44);
        imageHeight = round(280.0 / aspect);
        
        CGSize constrainedSize = CGSizeMake(kScreenWidth - 74  , 9999);
        CGSize size = [NSString sizeWithConstrainedSize:constrainedSize font:[UIFont systemFontOfSize:14.0] maxLength:kMaxProductImpressoinImageDescLength];
        kProductAuthImpressionImageCellHeight = imageHeight + size.height + 140;
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
    [self.selectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSelection)]];
    
    @weakify(self);
    [self.tvDesc.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.image.productImage_description = x;
    }];
    
    [RACObserve(self.lblSelection, text) subscribeNext:^(id x) {
        @strongify(self);
        self.image.section = x;
    }];
    
    [self.tvDesc.rac_textSignal subscribeNext:^(NSString *value) {
        @strongify(self);
        [self updateValue];
    }];
}

- (void)initWithProduct:(Product *)product image:(ProductImage *)image actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    self.product = product;
    self.image = image;
    [self.imgView setImageWithId:image.imageid withWidth:kScreenWidth];
    self.tvDesc.text = image.productImage_description;
    self.tvDesc.placeholder = @"请输入";
    [self updateValue];
    self.lblSelection.text = image.section;
    self.coverImgView.hidden = ![product.cover_imageid isEqualToString:image.imageid];
    
    [self initActionView:actionBlock];
}

- (void)initActionView:(ProductAuthImageActionViewTapBlock)actionBlock {
    if (!self.actionView) {
        self.actionView = [[ProductAuthImageActionView alloc] initWithFrame:CGRectMake(kScreenWidth - kProductAuthImageActionViewWidth - 30, imageHeight - kProductAuthImageActionViewHeight + 5, kProductAuthImageActionViewWidth, kProductAuthImageActionViewHeight)];
        [self.contentView addSubview:self.actionView];
    }
    
    self.actionView.tapBlock = actionBlock;
}

- (void)onTapImgView {
    NSArray *imageArray = [self.product.images map:^(NSDictionary *dict) {
        return [dict objectForKey:@"imageid"];
    }];
    
    [ViewControllerContainer showOnlineImages:imageArray fromImageView:self.imageView index:[imageArray indexOfObject:self.image.imageid]];
}

- (void)onTapSelection {
    [[ViewControllerContainer getCurrentTapController].view endEditing:YES];
    [SelectionMenuView show:[ViewControllerContainer getCurrentTapController] datasource:[NameDict getAllHomeType] defaultValue:self.lblSelection.text block:^(id value) {
        self.lblSelection.text = value;
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL flag = YES;
    NSString *curStr = textView.text;
    NSInteger len = curStr.length +  (text.length - range.length);
    NSInteger lenDelta = len - kMaxProductImpressoinImageDescLength;
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
    
    self.lblLeftLength.text = [NSString stringWithFormat:@"%@/%@", @(kMaxProductImpressoinImageDescLength - value.length), @(kMaxProductImpressoinImageDescLength)];
}

@end
