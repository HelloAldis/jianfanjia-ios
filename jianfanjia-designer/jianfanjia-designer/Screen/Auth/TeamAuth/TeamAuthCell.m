//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "TeamAuthCell.h"
#import "ViewControllerContainer.h"

@interface TeamAuthCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblManager;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblAuth;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) Team *team;
@property (nonatomic, copy) TeamAuthCellDeleteBlock deleteBlock;

@end

@implementation TeamAuthCell

- (void)awakeFromNib {
    [self.containerView setCornerRadius:3];
    [self.coverView setCornerRadius:3];
    [self.avtarImageView setCornerRadius:self.avtarImageView.frame.size.width / 2];
    [self.avtarImageView setBorder:1 andColor:kViewBgColor.CGColor];
    [self.btnDelete setCornerRadius:self.btnDelete.frame.size.height / 2];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    
    self.lblAuth.hidden = YES;
    self.authImageView.hidden = YES;
}

- (void)initWithTeam:(Team *)team edit:(BOOL)edit deleteBlock:(TeamAuthCellDeleteBlock)deleteBlock {
    self.team = team;
    self.deleteBlock = deleteBlock;
    
    self.lblManager.text = team.manager;
    self.lblAddress.text = [NSString stringWithFormat:@"%@%@%@", team.province, team.city, team.district];
    self.coverView.hidden = !edit;
    self.lblAddress.hidden = edit;
}

- (void)onTap {

}

- (IBAction)onClickDelete:(id)sender {
    DesignerDeleteTeam *request = [[DesignerDeleteTeam alloc] init];
    request._id = self.team._id;
    
    [API designerDeleteTeam:request success:^{
        if (self.deleteBlock) {
            self.deleteBlock();
        }
    } failure:^{
    } networkError:^{
        
    }];
}

@end
