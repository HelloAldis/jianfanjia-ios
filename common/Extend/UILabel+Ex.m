//
//  UILabel+Ex.m
//  jianfanjia
//
//  Created by Karos on 16/3/10.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "UILabel+Ex.h"

@implementation UILabel (Ex)

- (void)setRowSpace:(NSInteger)space {
    NSString *labelText = self.text;
    if (!labelText) return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//调整行间距
    [paragraphStyle setAlignment:self.textAlignment];//设置对齐方式
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
}

- (void)setHtml:(NSString *)htmlString {
    if (!htmlString) return;
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    ;
    self.attributedText = attrStr;
}

@end
