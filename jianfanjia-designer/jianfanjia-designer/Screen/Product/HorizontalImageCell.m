//
//  MatchDesignerCell.m
//  jianfanjia
//
//  Created by Karos on 15/11/17.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "HorizontalImageCell.h"
#import "ViewControllerContainer.h"

#define imgSpace 2

@interface HorizontalImageCell ()
@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;

@property (strong, nonatomic) NSArray *images;

@end

@implementation HorizontalImageCell

- (void)awakeFromNib {
    
}

- (void)initWithImages:(NSArray *)images {
    self.images = images;

    [self.imgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    @weakify(self);
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(8 + idx * ([self getGoodWidth] + [self getGoodSpace]), 0, [self getGoodWidth] , kHorizontalImageCellHeight);
        [imgView setImageWithId:obj withWidth:[self getGoodWidth] ];
        [self.imgScrollView addSubview:imgView];
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)]];
    }];
    
    self.imgScrollView.contentSize = CGSizeMake(([self getGoodWidth]  + [self getGoodSpace] + 8) * images.count, kHorizontalImageCellHeight);
}

- (void)onTapImage:(UIGestureRecognizer *)g {
    NSInteger index = [self.imgScrollView.subviews indexOfObject:g.view];
    [ViewControllerContainer showOnlineImages:self.images fromImageView:self.imgScrollView.subviews[index] index:index];
}

- (CGFloat)getGoodWidth {
    return self.images.count == 1 ? kScreenWidth : kHorizontalImageCellWidth;
}

- (CGFloat)getGoodSpace {
    return self.images.count == 1 ? 0 : imgSpace;
}

@end
