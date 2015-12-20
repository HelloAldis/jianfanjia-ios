//
//  PrettyPictureFallsLayout.h
//  jianfanjia
//
//  Created by likaros on 15/12/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrettyPictureFallsLayout;

@protocol PrettyPictureFallsLayoutProtocol <NSObject>

@required
- (CGFloat)fallFlowLayout:(PrettyPictureFallsLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface PrettyPictureFallsLayout : UICollectionViewLayout

/*cell的列间距*/
@property (nonatomic,assign) CGFloat columnSpace;
/*cell的行间距*/
@property (nonatomic,assign) CGFloat rowSpace;
/*cell的top,right,bottom,left间距*/
@property (nonatomic,assign) UIEdgeInsets insets;
/*显示多少列*/
@property (nonatomic,assign) NSInteger columnCount;

@property (nonatomic, weak) id<PrettyPictureFallsLayoutProtocol> delegate;

@end
