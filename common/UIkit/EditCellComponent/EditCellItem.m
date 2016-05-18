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
static NSString *GroupImageEditCellIdentifier = @"GroupImageEditCell";

#import "EditCellItem.h"
#import "BaseEditCell.h"

@implementation EditCellItem

- (BaseEditCell *)dequeueReusableCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = nil;
    if (self.cellEditType == CellEditTypeSelection) {
        cellIdentifier = SelectionEditCellIdentifier;
    } else if (self.cellEditType == CellEditTypeFld) {
        cellIdentifier = FieldEditCellIdentifier;
    } else if (self.cellEditType == CellEditTypeText) {
        cellIdentifier = TextEditCellIdentifier;
    } else if (self.cellEditType == CellEditTypeGroupImage) {
        cellIdentifier = GroupImageEditCellIdentifier;
    }
    
    BaseEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initWithItem:self];
    return cell;
}

+ (void)registerCells:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:SelectionEditCellIdentifier bundle:nil] forCellReuseIdentifier:SelectionEditCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:FieldEditCellIdentifier bundle:nil] forCellReuseIdentifier:FieldEditCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:TextEditCellIdentifier bundle:nil] forCellReuseIdentifier:TextEditCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:GroupImageEditCellIdentifier bundle:nil] forCellReuseIdentifier:GroupImageEditCellIdentifier];
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

+ (EditCellItem *)createAttrSelection:(NSAttributedString *)attrTitle attrValue:(NSAttributedString *)attrValue placeholder:(NSString *)placeholder tapBlock:(EditCellItemTapBlock)tapBlock {
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

+ (EditCellItem *)createAttrSelection:(NSAttributedString *)attrTitle attrValue:(NSAttributedString *)attrValue placeholder:(NSString *)placeholder image:(UIImage *)image tapBlock:(EditCellItemTapBlock)tapBlock {
    EditCellItem *item = [EditCellItem createAttrSelection:attrTitle attrValue:attrValue placeholder:placeholder tapBlock:tapBlock];
    item.image = image;
    
    return item;
}

+ (EditCellItem *)createField:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeFld;
    item.title = title;
    item.value = value;
    item.placeholder = placeholder;
    
    return item;
}

+ (EditCellItem *)createText:(NSString *)title value:(NSString *)value placeholder:(NSString *)placeholder {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeText;
    item.title = title;
    item.value = value;
    item.placeholder = placeholder;
    
    return item;
}

+ (EditCellItem *)createGroupImage:(NSString *)title value:(NSString *)value {
    EditCellItem *item = [[EditCellItem alloc] init];
    item.cellEditType = CellEditTypeGroupImage;
    item.title = title;
    item.value = value;
    
    return item;
}

@end
