//
//  CardImageCell.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/26.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#ifndef CardImageCell_h
#define CardImageCell_h

typedef NS_ENUM(NSInteger, CardImageAction) {
    CardImageActionDelete,
    CardImageActionAdd,
};

typedef NS_ENUM(NSInteger, CardImageType) {
    CardImageTypeFront,
    CardImageTypeBack,
};

typedef void (^CardImageCellActionBlock)(CardImageAction action, CardImageType type);

#endif /* CardImageCell_h */
