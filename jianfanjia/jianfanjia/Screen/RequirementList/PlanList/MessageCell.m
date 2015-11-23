//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *authIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameVal;
@property (weak, nonatomic) IBOutlet UILabel *lblRoleTypeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageVal;

@property (strong, nonatomic) Comment *comment;

@end

@implementation MessageCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:30];
}

- (void)initWithComment:(Comment *)comment {
    self.comment = comment;
}

@end
