//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiaryDescCell.h"
#import "CustomYYTextView.h"

#define kMinHeight 100

@interface AddDiaryDescCell () <YYTextViewDelegate>

@property (weak, nonatomic) IBOutlet CustomYYTextView *textView;

@property (strong, nonatomic) Diary *diary;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation AddDiaryDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    self.textView.placeholderText = @"记录和分享您的装修之路";
    self.textView.placeholderFont = [UIFont systemFontOfSize:14.0];
    self.textView.linePositionModifier = [self linePositionModifier];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 20, 20, 10);
    self.textView.textColor = [UIColor colorWithR:0x7C g:0x84 b:0x89];
    self.textView.font = [UIFont systemFontOfSize:14.0];
    self.textView.intrinsicSize = CGSizeMake(kScreenWidth, kMinHeight);
    self.textView.allowsCopyAttributedString = YES;
    self.textView.allowsPasteAttributedString = YES;
    self.textView.allowsUndoAndRedo = YES;
}

- (void)initWithDiary:(Diary *)diary tableView:(UITableView *)tableView {
    self.diary = diary;
    self.tableView = tableView;
}

#pragma mark - text view delegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    self.textView.intrinsicSize = CGSizeMake(kScreenWidth, MAX(kMinHeight, [self layout:str].textBoundingSize.height));
    [self.textView invalidateIntrinsicContentSize];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    return YES;
}

- (YYTextLayout *)layout:(NSString *)text {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kScreenWidth, CGFLOAT_MAX);
    container.linePositionModifier = [self linePositionModifier];
    container.insets = UIEdgeInsetsMake(10, 20, 20, 10);
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:[self text:text]];
    return layout;
}

- (YYTextLinePositionSimpleModifier *)linePositionModifier {
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 24;
    return modifier;
}

- (NSMutableAttributedString *)text:(NSString *)str {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text yy_setColor:[UIColor colorWithR:0x7C g:0x84 b:0x89] range:NSMakeRange(0, text.length)];
    [text yy_setFont:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, text.length)];
    return text;
}

@end
