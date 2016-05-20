//
//  ItemImageCollectionCell.m
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "DesignerAuthCell.h"
#import "ViewControllerContainer.h"

static NSDictionary *titleDic = nil;
static NSDictionary *imageDic = nil;

@interface DesignerAuthCell ()

@property (weak, nonatomic) IBOutlet UIView *authBgView;
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthType;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthStatus;

@property (strong, nonatomic) NSString *cellType;

@end

@implementation DesignerAuthCell

+ (void)initialize {
    if ([self class] == [DesignerAuthCell class]) {
        titleDic = @{AuthCellTypeBasicInfo : @"基本资料认证",
                     AuthCellTypeUid : @"身份认证",
                     AuthCellTypeTeam : @"施工团队认证",
                     AuthCellTypeEmail : @"邮箱认证",
                     AuthCellTypeProduct : @"作品认证",
                     };
        imageDic = @{AuthCellTypeBasicInfo : [UIImage imageNamed:@"icon_basic_info_auth"],
                     AuthCellTypeUid : [UIImage imageNamed:@"icon_uid_auth"],
                     AuthCellTypeTeam : [UIImage imageNamed:@"icon_team_auth"],
                     AuthCellTypeEmail : [UIImage imageNamed:@"icon_email_auth"],
                     AuthCellTypeProduct : [UIImage imageNamed:@"icon_product_auth"],
                     };
    }
}

- (void)awakeFromNib {
    [self.authBgView setCornerRadius:self.authBgView.frame.size.width / 2];
    [self.lblAuthStatus setCornerRadius:self.lblAuthStatus.frame.size.height / 2];
    [self setBorder:0.3 andColor:kViewBgColor.CGColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)initWithCellType:(NSString *)type authType:(NSString *)authType {
    self.cellType = type;
    self.lblAuthType.text = titleDic[type];
    self.authImageView.image = imageDic[type];
    
    if ([type isEqualToString:AuthCellTypeProduct]) {
        self.lblAuthStatus.text = @"前往查看";
        self.lblAuthStatus.bgColor = [ProductBusiness productAuthTypeColorByProductCount];
        self.authBgView.bgColor = [ProductBusiness productAuthTypeColorByProductCount];
    } else {
        self.lblAuthStatus.text = [NameDict nameForAuthType:authType];
        self.lblAuthStatus.bgColor = [DesignerBusiness authTypeColor:authType];
        self.authBgView.bgColor = [DesignerBusiness authTypeColor:authType];
    }
}

- (void)onTap {
    if ([self.cellType isEqualToString:AuthCellTypeBasicInfo]) {
        [ViewControllerContainer showInfoAuth];
    } else if ([self.cellType isEqualToString:AuthCellTypeUid]) {
        [ViewControllerContainer showIDAuth];
    } else if ([self.cellType isEqualToString:AuthCellTypeProduct]) {
        [ViewControllerContainer showProductAuth];
    } else if ([self.cellType isEqualToString:AuthCellTypeTeam]) {
        [ViewControllerContainer showTeamAuth];
    } else if ([self.cellType isEqualToString:AuthCellTypeEmail]) {
        
    }
}

@end
