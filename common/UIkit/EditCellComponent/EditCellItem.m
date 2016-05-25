//
//  EditCellItem.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/18.
//  Copyright © 2016年 JYZ. All rights reserved.
//

static NSString *SelectionEditCellIdentifier = @"SelectionEditCell";
static NSString *FieldEditCellIdentifier = @"FieldEditCell";
static NSString *TextEditCellIdentifier = @"TextEditCell";
static NSString *CompareImageEditCellIdentifier = @"CompareImageEditCell";

#import "EditCellItem.h"
#import "CellEditComponent.h"

@implementation EditCellItem

- (BaseEditCell *)dequeueReusableCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = nil;
    if (self.cellEditType == CellEditTypeSelection) {
        cellIdentifier = SelectionEditCellIdentifier;
    } else if (self.cellEditType == CellEditTypeFld) {
        cellIdentifier = FieldEditCellIdentifier;
    } else if (self.cellEditType == CellEditTypeText) {
        cellIdentifier = TextEditCellIdentifier;
    } else if (self.cellEditType == CellEditTypeCompareImage) {
        cellIdentifier = CompareImageEditCellIdentifier;
    }
    
    BaseEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithItem:self];
    return cell;
}

- (CGFloat)cellheight {
    CGFloat cellHeight = 0;
    if (self.cellEditType == CellEditTypeSelection) {
        cellHeight = kSelectionEditCellHeight;
    } else if (self.cellEditType == CellEditTypeFld) {
        cellHeight = kFieldEditCellHeight;
    } else if (self.cellEditType == CellEditTypeText) {
        cellHeight = kTextEditCellHeight;
    } else if (self.cellEditType == CellEditTypeCompareImage) {
        cellHeight = kCompareImageEditCellHeight;
    }

    return cellHeight;
}

+ (void)registerCells:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:SelectionEditCellIdentifier bundle:nil] forCellReuseIdentifier:SelectionEditCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:FieldEditCellIdentifier bundle:nil] forCellReuseIdentifier:FieldEditCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:TextEditCellIdentifier bundle:nil] forCellReuseIdentifier:TextEditCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:CompareImageEditCellIdentifier bundle:nil] forCellReuseIdentifier:CompareImageEditCellIdentifier];
}

+ (EditCellItem *)createSelection:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeSelection;
    item.title = title;
    item.value = value;
    item.placeholder = placeholder;
    item.itemTapBlock = tapBlock;
    
    return item;
}

+ (EditCellItem *)createAttrSelection:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeSelection;
    item.attrTitle = attrTitle;
    item.attrValue = attrValue;
    item.placeholder = placeholder;
    item.itemTapBlock = tapBlock;
    
    return item;
}

+ (EditCellItem *)createSelection:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock {
    EditCellItem *item = [EditCellItem createSelection:title value:value placeholder:placeholder tapBlock:tapBlock];
    item.image = image;
    
    return item;
}

+ (EditCellItem *)createAttrSelection:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock {
    EditCellItem *item = [EditCellItem createAttrSelection:attrTitle attrValue:attrValue placeholder:placeholder tapBlock:tapBlock];
    item.image = image;
    
    return item;
}

+ (EditCellItem *)createField:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeFld;
    item.title = title;
    item.value = value;
    item.placeholder = placeholder;
    item.itemEditBlock = itemEditBlock;
    
    return item;
}

+ (EditCellItem *)createAttrField:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeFld;
    item.attrTitle = attrTitle;
    item.attrValue = attrValue;
    item.placeholder = placeholder;
    item.itemEditBlock = itemEditBlock;
    
    return item;
}

+ (EditCellItem *)createField:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock length:(NSInteger)length isNumber:(BOOL)isNumber {
    EditCellItem *item = [EditCellItem createField:title value:value placeholder:placeholder itemEditBlock:itemEditBlock];
    item.length = length;
    item.isNumber = isNumber;
    
    return item;
}

+ (EditCellItem *)createAttrField:(NSMutableAttributedString *)attrTitle attrValue:(NSMutableAttributedString *)attrValue placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock length:(NSInteger)length isNumber:(BOOL)isNumber {
    EditCellItem *item = [EditCellItem createAttrField:attrTitle attrValue:attrValue placeholder:placeholder itemEditBlock:itemEditBlock];
    item.length = length;
    item.isNumber = isNumber;
    
    return item;
}

+ (EditCellItem *)createText:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder itemEditBlock:(EditCellItemEditBlock)itemEditBlock {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeText;
    item.title = title;
    item.value = value;
    item.placeholder = placeholder;
    
    return item;
}

+ (EditCellItem *)createCompareImage:(NSString *)title compareImage:(UIImage *)compareImage uploadImage:(NSString *)uploadImage {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeCompareImage;
    item.title = title;
    item.compareImage = compareImage;
    item.uploadImage = uploadImage;
    
    return item;
}

@end
