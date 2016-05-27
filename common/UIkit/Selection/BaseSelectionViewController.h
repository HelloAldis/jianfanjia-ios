//
//  BaseSelectionViewController.h
//  jianfanjia
//
//  Created by likaros on 15/12/6.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "BaseViewController.h"
#import "MultipleLineTextTableViewCell.h"

typedef NS_ENUM(NSInteger, SelectionType) {
    SelectionTypeSingle,
    SelectionTypeMultiple,
};

typedef void(^ValueBlock)(id value);

@interface BaseSelectionViewController : BaseViewController

@property (assign, nonatomic) SelectionType selectionType;
@property (copy, nonatomic) ValueBlock ValueBlock;
@property (strong, nonatomic) NSString *curValue;
@property (strong, nonatomic) NSArray *curValues;

- (id)initWithValueBlock:(ValueBlock)ValueBlock curValue:(NSString *)curValue;
- (id)initWithValueBlock:(ValueBlock)ValueBlock curValues:(NSArray *)curValues;

@end
