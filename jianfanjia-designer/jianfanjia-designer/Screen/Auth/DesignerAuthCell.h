//
//  ItemImageCollectionCell.h
//  jianfanjia
//
//  Created by likaros on 15/11/26.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDesignerAuthCellHeight 208

static NSString *AuthCellTypeBasicInfo = @"AuthCellTypeBasicInfo";
static NSString *AuthCellTypeUid = @"AuthCellTypeUid";
static NSString *AuthCellTypeTeam = @"AuthCellTypeTeam";
static NSString *AuthCellTypeEmail = @"AuthCellTypeEmail";
static NSString *AuthCellTypeProduct = @"AuthCellTypeProduct";

@interface DesignerAuthCell : UICollectionViewCell

- (void)initWithDesigner:(Designer *)designer cellType:(NSString *)type authType:(NSString *)authType;

@end


