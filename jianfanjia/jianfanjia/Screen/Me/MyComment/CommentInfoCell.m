//
//  RequirementCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CommentInfoCell.h"
#import "ViewControllerContainer.h"

static const NSInteger imgWidth = 170;
static const NSInteger imgSpace = 2;

@interface CommentInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UIButton *brnReply;
@property (weak, nonatomic) IBOutlet UIView *linkView;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkTime;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *linkImageScrollView;
@property (weak, nonatomic) IBOutlet UIView *linkImageContainerView;

@end

@implementation CommentInfoCell

- (void)awakeFromNib {
    [self.imgAvatar setCornerRadius:self.imgAvatar.bounds.size.width / 2];
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCell)]];
}

- (void)initWithDesigner:(Designer *)designer {
    
    
    [self.linkImageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    @weakify(self);
//    [plan.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        @strongify(self);
//        UIImageView *imgView = [[UIImageView alloc] init];
//        imgView.clipsToBounds = YES;
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        imgView.frame = CGRectMake(idx * (imgWidth + imgSpace), 0, imgWidth, self.imgScrollView.bounds.size.height);
//        [imgView setImageWithId:obj withWidth:imgWidth];
//        [self.imgScrollView addSubview:imgView];
//        
//        if (imgSpace > 0) {
//            UIView *space = [[UIView alloc] init];
//            space.frame = CGRectMake(idx * imgWidth, 0, imgSpace, self.imgScrollView.bounds.size.height);
//            [self.imgScrollView addSubview:space];
//        }
//    }];
//    
//    self.imgScrollView.contentSize = CGSizeMake((imgWidth + imgSpace) * plan.images.count, self.imgScrollView.bounds.size.height);
    
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.frame = CGRectMake(0, 0, imgWidth, 170);
    imgView.image = [UIImage imageNamed:@"banner_1"];
    [self.linkImageScrollView addSubview:imgView];
    self.linkImageScrollView.contentSize = CGSizeMake(imgWidth, 170);
}

#pragma mark - gesture


@end
