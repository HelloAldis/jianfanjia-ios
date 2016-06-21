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
    [self.imgAvatar setImageWithId:[CommentBusiness imageId:comment] withWidth:self.imgAvatar.bounds.size.width];
    self.lblUserNameVal.text = [CommentBusiness userName:comment];
    self.lblRoleTypeVal.text = [NameDict nameForUserType:comment.usertype];
    self.lblRoleTypeVal.textColor = [CommentBusiness roleColor:comment];
    self.lblTimeVal.text = [comment.date humDateString];
    self.lblMessageVal.text = comment.content;
    
    if ([[GVUserDefaults standardUserDefaults].userid isEqualToString:comment.by]) {
        self.lblRoleTypeVal.text = @"我";
    }
}

@end
