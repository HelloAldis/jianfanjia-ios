//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiaryDescCell.h"
#import "CustomYYTextView.h"

#define kTopPadding 10
#define kLeftPadding 10
#define kBottomPadding 10
#define kRightPadding 10
#define kMinHeight 100 + kTopPadding + kBottomPadding

@interface AddDiaryDescCell () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet CustomYYTextView *textView;

@property (strong, nonatomic) Diary *diary;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation AddDiaryDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.textView.scrollEnabled = NO;
    self.textView.delegate = self;
    self.textView.placeholderText = @"记录和分享您的装修之路";
    self.textView.placeholderFont = [UIFont systemFontOfSize:14.0];
    self.textView.linePositionModifier = [self linePositionModifier];
    self.textView.textContainerInset = UIEdgeInsetsMake(kTopPadding, kLeftPadding, kBottomPadding, kRightPadding);
    self.textView.textColor = [UIColor colorWithR:0x7C g:0x84 b:0x89];
    self.textView.font = [UIFont systemFontOfSize:14.0];
    self.textView.intrinsicSize = CGSizeMake(kScreenWidth, kMinHeight);
//    self.textView.allowsPasteImage = YES;
    self.textView.allowsCopyAttributedString = YES;
    self.textView.allowsPasteAttributedString = YES;
    self.textView.allowsUndoAndRedo = YES;
}

- (void)initWithDiary:(Diary *)diary tableView:(UITableView *)tableView {
    self.diary = diary;
    self.tableView = tableView;
}

#pragma mark - text view delegate
- (void)textViewDidChange:(YYTextView *)textView {
    self.textView.intrinsicSize = CGSizeMake(textView.textLayout.textBoundingSize.width, MAX(kMinHeight, textView.textLayout.textBoundingSize.height));
    [self.textView invalidateIntrinsicContentSize];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (YYTextLinePositionSimpleModifier *)linePositionModifier {
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    return modifier;
}

@end
