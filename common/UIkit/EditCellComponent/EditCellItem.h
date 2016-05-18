//
//  EditCellItem.h
//  jianfanjia-designer
//
//  Created by Karos on 16/5/18.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CellEditType) {
    CellEditTypeSelection,
    CellEditTypeFld,
    CellEditTypeText,
    CellEditTypeGroupImage,
};

@class EditCellItem;
@class BaseEditCell;

typedef void (^EditCellItemTapBlock)(EditCellItem *curItem);

@interface EditCellItem : NSObject

@property (nonatomic, assign) CellEditType cellEditType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSAttributedString *attrTitle;
@property (nonatomic, strong) NSAttributedString *attrValue;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, copy) EditCellItemTapBlock itemTapBlock;

- (BaseEditCell *)dequeueReusableCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
+ (void)registerCells:(UITableView *)tableView;

+ (EditCellItem *)createSelection:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock;
+ (EditCellItem *)createSelection:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock;

+ (EditCellItem *)createAttrSelection:(NSAttributedString *)attrTitle attrValue:(NSAttributedString *)attrValue placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock;
+ (EditCellItem *)createAttrSelection:(NSAttributedString *)attrTitle attrValue:(NSAttributedString *)attrValue placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock;

+ (EditCellItem *)createField:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder;
+ (EditCellItem *)createText:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder;
+ (EditCellItem *)createGroupImage:(NSString *)title value:(NSString *)value;

@end
