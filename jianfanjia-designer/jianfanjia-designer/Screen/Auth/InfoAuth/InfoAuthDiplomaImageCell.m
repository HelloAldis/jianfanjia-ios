//
//  ProductAuthPlanImageCell.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/23.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "InfoAuthDiplomaImageCell.h"
#import "ViewControllerContainer.h"

@interface InfoAuthDiplomaImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgView;
@property (strong, nonatomic) ProductAuthImageActionView *actionView;

@property (strong, nonatomic) Designer *designer;
@property (strong, nonatomic) NSString *diploma;

@property (copy, nonatomic) ProductAuthImageActionViewTapBlock actionBlock;

@end

@implementation InfoAuthDiplomaImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView setCornerRadius:5];
    [self.imgView setBorder:0.5 andColor:[UIColor colorWithR:0xB2 g:0xB6 b:0xB8].CGColor];
    [self.imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImgView)]];
    [self.deleteImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapDeleteImg)]];
}

- (void)initWithDesigner:(Designer *)designer diploma:(NSString *)diploma actionBlock:(ProductAuthImageActionViewTapBlock)actionBlock {
    self.designer = designer;
    self.diploma = diploma;
    self.actionBlock = actionBlock;
    [self.imgView setImageWithId:diploma withWidth:kScreenWidth];
    self.coverImgView.hidden = YES;
}

- (void)onTapImgView {
    [ViewControllerContainer showOnlineImages:@[self.diploma] index:0];
}

- (void)onTapDeleteImg {
    if (self.actionBlock) {
        self.actionBlock(ProductAuthImageActionDelete);
    }
}

@end
