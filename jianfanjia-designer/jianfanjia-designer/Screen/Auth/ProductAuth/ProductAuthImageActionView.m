//
//  ProductAuthImageHeaderView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ProductAuthImageActionView.h"

@interface ProductAuthImageActionView ()
@property (weak, nonatomic) IBOutlet UIImageView *closeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgView;
@property (weak, nonatomic) IBOutlet UIImageView *editImgView;
@property (weak, nonatomic) IBOutlet UIImageView *setCoverImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *closeConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setCoverConst;

@property (assign, nonatomic) BOOL isOpen;

@end

@implementation ProductAuthImageActionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    [self.closeImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClose)]];
    [self.deleteImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDelete)]];
    [self.editImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapEdit)]];
    [self.setCoverImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSetCover)]];
    self.closeImgView.transform = CGAffineTransformRotate(self.closeImgView.transform, M_PI_4);
}

- (void)showTool:(BOOL)animated {
    if (!self.isOpen) {
        [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.closeConst.constant = [self rightToTrailConst:0];
            self.deleteConst.constant = [self rightToTrailConst:1];
            self.editConst.constant = [self rightToTrailConst:2];
            self.setCoverConst.constant = [self rightToTrailConst:3];
            
            self.deleteImgView.alpha = 1.0;
            self.editImgView.alpha = 1.0;
            self.setCoverImgView.alpha = 1.0;
            
            self.closeImgView.transform = CGAffineTransformRotate(self.closeImgView.transform, M_PI_4);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isOpen = YES;
        }];
    }
}

- (void)closeTool:(BOOL)animated {
    if (self.isOpen) {
        [UIView animateWithDuration:animated ? 0.2 : 0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.closeConst.constant = [self rightToTrailConst:0];
            self.deleteConst.constant = [self rightToTrailConst:0];
            self.editConst.constant = [self rightToTrailConst:0];
            self.setCoverConst.constant = [self rightToTrailConst:0];
            
            self.deleteImgView.alpha = 0.0;
            self.editImgView.alpha = 0.0;
            self.setCoverImgView.alpha = 0.0;
            
            self.closeImgView.transform = CGAffineTransformRotate(self.closeImgView.transform, -M_PI_4);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.isOpen = NO;
        }];
    }
}

#pragma mark - tap actions
- (void)onTapClose {
    if (self.isOpen) {
        [self closeTool:YES];
    } else {
        [self showTool:YES];
    }
}

- (void)onTapDelete {
    if (self.tapBlock) {
        self.tapBlock(ProductAuthImageActionDelete);
    }
}

- (void)onTapEdit {
    if (self.tapBlock) {
        self.tapBlock(ProductAuthImageActionEdit);
    }
}

- (void)onTapSetCover {
    if (self.tapBlock) {
        self.tapBlock(ProductAuthImageActionSetCover);
    }
}

#pragma mark - other
- (CGFloat)rightToTrailConst:(NSInteger)index {
    return index * (kImgViewWidth + kImgViewSpace);
}

@end
