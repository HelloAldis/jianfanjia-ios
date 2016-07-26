//
//  SectionView.m
//  jianfanjia
//
//  Created by JYZ on 15/9/17.
//  Copyright (c) 2015年 JYZ. All rights reserved.
//

#import "DecPackage365View.h"
#import "ViewControllerContainer.h"
#import "WebViewController.h"

const CGFloat kDecPackage365ViewErrorHeight = 30;
const CGFloat kDecPackage365ViewHeight = 146 - kDecPackage365ViewErrorHeight;

@interface DecPackage365View()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblErrorHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UILabel *lblTtile;
@property (weak, nonatomic) IBOutlet UILabel *lblBasicFeeVal;
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalizedFeeVal;
@property (weak, nonatomic) IBOutlet UIImageView *iconDiamondPersonalized;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBudgetVal;
@property (weak, nonatomic) IBOutlet UIImageView *iconDiamondTotalBudget;

@property (strong, nonatomic) Requirement *requirement;

@property (assign, nonatomic) CGFloat basicFee;
@property (assign, nonatomic) CGFloat totalBudget;
@property (assign, nonatomic) CGFloat personalizedFee;

@end

@implementation DecPackage365View

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
        self.frame = frame;
        [self initUI];
    }
    
    return self;
}

- (void)initUI {
    self.clipsToBounds = YES;
    
    RAC(self.iconDiamondPersonalized, hidden) = [RACObserve(self.lblPersonalizedFeeVal, hidden) map:^id(id value) {
        return @(![value boolValue]);
    }];
    
    RAC(self.iconDiamondTotalBudget, hidden) = [RACObserve(self.lblTotalBudgetVal, hidden) map:^id(id value) {
        return @(![value boolValue]);
    }];
}

- (void)updateData:(Requirement *)requirement {
    self.requirement = requirement;
    
    self.basicFee = [RequirementBusiness getPkgWPriceByArea:requirement.house_area.floatValue];
    self.totalBudget = requirement.total_price.floatValue;
    self.personalizedFee = self.totalBudget - self.basicFee;
    
    if (self.totalBudget < self.basicFee) {
        self.lblError.hidden = self.totalBudget == 0;
        self.lblErrorHeightConstraint.constant = self.totalBudget == 0 ? 0 : kDecPackage365ViewErrorHeight;
        self.lblPersonalizedFeeVal.hidden = YES;
        self.lblTotalBudgetVal.hidden = self.totalBudget == 0;
    } else {
        self.lblError.hidden = YES;
        self.lblErrorHeightConstraint.constant = 0;
        self.lblPersonalizedFeeVal.hidden = NO;
        self.lblTotalBudgetVal.hidden = NO;
    }
    
    self.lblBasicFeeVal.text = [NSString stringWithFormat:@"%.2f万元", self.basicFee];
    self.lblPersonalizedFeeVal.text = [NSString stringWithFormat:@"%.2f万元", self.personalizedFee];
    self.lblTotalBudgetVal.text = [NSString stringWithFormat:@"%.2f万元", self.totalBudget];
    [self attributedText:self.lblBasicFeeVal range:NSMakeRange(0, self.lblBasicFeeVal.text.length - 2)];
    [self attributedText:self.lblPersonalizedFeeVal range:NSMakeRange(0, self.lblPersonalizedFeeVal.text.length - 2)];
    [self attributedText:self.lblTotalBudgetVal range:NSMakeRange(0, self.lblTotalBudgetVal.text.length - 2)];
}

- (BOOL)hasError {
    return self.totalBudget < self.basicFee && self.totalBudget != 0;
}

#pragma mark - user action
- (IBAction)onClickAbout:(id)sender {
    [WebViewController show:[ViewControllerContainer getCurrentTopController] withUrl:kPkg365Url shareTopic:nil];
}

#pragma mark - attributed text
- (void)attributedText:(UILabel *)label range:(NSRange)range {
    NSString *text = label.text;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightBold],
                                   NSForegroundColorAttributeName:[UIColor blackColor],
                                   }
                           range:range];
    label.attributedText = attributedStr;
}

@end
