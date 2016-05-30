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
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblManager;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblAuth;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) Team *team;
@property (nonatomic, copy) TeamAuthCellSelectBlock selectBlock;
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
    [self.checkImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCheck)]];
    
    self.lblAuth.hidden = YES;
    self.authImageView.hidden = YES;
    
    @weakify(self);
    [RACObserve(self, selected) subscribeNext:^(NSNumber *newValue) {
        @strongify(self);
        if (newValue.boolValue) {
            self.checkImageView.image = [UIImage imageNamed:@"checked"];
        } else {
            self.checkImageView.image = [UIImage imageNamed:@"unchecked"];;
        }
    }];
}

- (void)initWithTeam:(Team *)team canSelect:(BOOL)canSelect selectBlock:(TeamAuthCellSelectBlock)selectBlock edit:(BOOL)edit deleteBlock:(TeamAuthCellDeleteBlock)deleteBlock {
    self.team = team;
    self.selectBlock = selectBlock;
    self.deleteBlock = deleteBlock;
    
    self.lblManager.text = team.manager;
    self.lblAddress.text = [NSString stringWithFormat:@"%@%@%@", team.province, team.city, team.district];
    self.coverView.hidden = !edit;
    self.lblAddress.hidden = edit;
    self.checkImageView.hidden = !canSelect;
}

- (void)onTapCheck {
    if (self.selectBlock) {
        self.selectBlock(self.selected);
    }
}

- (void)onTap {
    [ViewControllerContainer showTeamAuthUpdate:self.team];
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
