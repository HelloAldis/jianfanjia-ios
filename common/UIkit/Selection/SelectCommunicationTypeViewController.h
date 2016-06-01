//
//  SelectRoomTypeViewController.h
//  jianfanjia
//
//  Created by Karos on 15/11/14.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSelectionViewController.h"

typedef NS_ENUM(NSInteger, SelectCommunicationType) {
    SelectCommunicationTypeByUser,
    SelectCommunicationTypeByDesigner,
};

@interface SelectCommunicationTypeViewController : BaseSelectionViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) SelectCommunicationType selectCommunicationType;

@end
