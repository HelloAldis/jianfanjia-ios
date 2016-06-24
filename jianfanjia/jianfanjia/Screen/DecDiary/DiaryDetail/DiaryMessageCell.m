//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DiaryMessageCell.h"

@interface DiaryMessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblRoleTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageVal;

@end

@implementation DiaryMessageCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
}

- (void)initWithComment:(Comment *)comment {
    [self.imgAvatar setUserImageWithId:[CommentBusiness imageId:comment]];
    self.lblUserNameVal.text = [CommentBusiness userName:comment];
    self.lblRoleTypeVal.text = [NameDict nameForUserType:comment.usertype];
    self.lblRoleTypeVal.textColor = [CommentBusiness roleColor:comment];
    self.lblTimeVal.text = [comment.date humDateString];

    NSRange prefixRange = [comment.content rangeOfString:kDiaryMessagePrefix];
    NSRange subfixRange = [comment.content rangeOfString:kDiaryMessageSubfix];
    
    if (prefixRange.location != NSNotFound && subfixRange.location != NSNotFound) {
        NSRange hilightRange = NSMakeRange(prefixRange.location + prefixRange.length, subfixRange.location - prefixRange.location - prefixRange.length);
        NSString *hilightString = [comment.content substringWithRange:hilightRange];

        self.lblMessageVal.attributedText = [comment.content attrSubStr:hilightString font:self.lblMessageVal.font color:kThemeColor];
    } else {
        self.lblMessageVal.text = comment.content;
    }
}

@end
