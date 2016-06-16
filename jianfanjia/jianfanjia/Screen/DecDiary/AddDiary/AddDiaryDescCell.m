//
//  ProductAuthProductDescriptionCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "AddDiaryDescCell.h"

@interface AddDiaryDescCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet YYTextView *textView;

@property (strong, nonatomic) Diary *diary;

@end

@implementation AddDiaryDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.placeholderText = @"记录和分享您的装修之路";
}

- (void)initWithDiary:(Diary *)diary {
    self.diary = diary;
    
}

@end
