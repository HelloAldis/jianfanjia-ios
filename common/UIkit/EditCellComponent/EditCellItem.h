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
    CellEditTypeCompareImage,
};

typedef NS_ENUM(NSInteger, EditCellItemEditType) {
    EditCellItemEditTypeBegin,
    EditCellItemEditTypeChange,
    EditCellItemEditTypeEnd,
};

@class EditCellItem;
@class BaseEditCell;

typedef void (^EditCellItemTapBlock)(EditCellItem *curItem);
typedef void (^EditCellItemEditBlock)(EditCellItem *curItem, EditCellItemEditType itemEditType);

@interface EditCellItem : NSObject

@property (nonatomic, assign) CellEditType cellEditType;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableAttributedString *attrTitle;
@property (nonatomic, strong) NSMutableAttributedString *attrValue;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) BOOL allowsEdit;
@property (nonatomic, assign) UIKeyboardType keyboard;
@property (nonatomic, copy) EditCellItemTapBlock itemTapBlock;
@property (nonatomic, copy) EditCellItemEditBlock itemEditBlock;

@property (nonatomic, strong) UIImage *compareImage;
@property (nonatomic, strong) NSString *uploadImage;

- (BaseEditCell *)dequeueReusableCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath allowsEdit:(BOOL)allowsEdit;
- (CGFloat)cellheight;
+ (void)registerCells:(UITableView *)tableView;

+ (EditCellItem *)createSelection:(NSString *)title value:(NSString *)value allowsEdit:(BOOL)allowsEdit placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock;
+ (EditCellItem *)createSelection:(NSString *)title value:(NSString *)value allowsEdit:(BOOL)allowsEdit placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock;

+ (EditCellItem *)createAttrSelection:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue allowsEdit:(BOOL)allowsEdit placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock;
+ (EditCellItem *)createAttrSelection:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue allowsEdit:(BOOL)allowsEdit placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock;

+ (EditCellItem *)createField:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock;
+ (EditCellItem *)createAttrField:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock;
+ (EditCellItem *)createField:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock length:(NSInteger)length keyboard:(UIKeyboardType)keyboard;
+ (EditCellItem *)createAttrField:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock length:(NSInteger)length keyboard:(UIKeyboardType)keyboard;

+ (EditCellItem *)createText:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock;
+ (EditCellItem *)createCompareImage:(NSString *)title compareImage:(UIImage *)compareImage uploadImage:(NSString *)uploadImage;

@end
