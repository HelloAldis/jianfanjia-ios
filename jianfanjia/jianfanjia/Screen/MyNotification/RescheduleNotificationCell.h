//
//  PostponeNotificationCell.h
//  jianfanjia
//
//  Created by Karos on 15/12/2.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RescheduleNotificationCell : UITableViewCell

- (void)initWithSchedule:(Schedule *)schedule notification:(Notification *)notification refreshBlock:(void(^)(NSString *processid))Block;

@end
