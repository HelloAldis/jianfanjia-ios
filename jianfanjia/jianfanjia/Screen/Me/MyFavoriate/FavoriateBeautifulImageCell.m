//
//  FavoriateBeautifulImageCell.m
//  jianfanjia
//
//  Created by JYZ on 15/12/24.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "FavoriateBeautifulImageCell.h"
#import "ViewControllerContainer.h"

@interface FavoriateBeautifulImageCell ()

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *trashImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblDeleteMessage;

@property (weak, nonatomic) BeautifulImage *beautifulImage;
@property (weak, nonatomic) DeleteFavoriateBeautifulImageBlock block;

@end


@implementation FavoriateBeautifulImageCell

- (void)awakeFromNib {
    [self.image setCornerRadius:5];
    self.image.backgroundColor = kPlaceHolderColor;
    [self.coverView setCornerRadius:5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDelete)];
    [self.coverView addGestureRecognizer:tap];
}

- (void)initWithImage:(NSString *)imageid width:(CGFloat)width {
    [self.image setImageWithId:imageid withWidth:width];
}

- (void)initWithImage:(BeautifulImage *)beautifulImage withDeleteBlock:(DeleteFavoriateBeautifulImageBlock)block {
    self.beautifulImage = beautifulImage;
    self.block = block;
    if (self.beautifulImage.is_deleted) {
        self.coverView.hidden = NO;
        self.trashImageView.hidden = NO;
        self.lblDeleteMessage.hidden = NO;
        [self.image setImage:[UIImage imageNamed:@"image_place_holder"]];
    } else {
        self.coverView.hidden = YES;
        self.trashImageView.hidden = YES;
        self.lblDeleteMessage.hidden = YES;
        LeafImage *leafImage = [self.beautifulImage leafImageAtIndex:0];
        [self.image setImageWithId:leafImage.imageid withWidth:kScreenWidth];
    }
}

- (void)onTapDelete {
    UnfavoriteBeautifulImage *request = [[UnfavoriteBeautifulImage alloc] init];
    request._id = self.beautifulImage._id;
    
    @weakify(self);
    [API unfavoriteBeautifulImage:request success:^{
        @strongify(self);
        self.block(self);
    } failure:^{
        
    } networkError:^{
        
    }];
}


@end
