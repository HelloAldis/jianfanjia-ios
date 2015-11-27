//
//  OverlayView.m
//  jianfanjia
//
//  Created by JYZ on 15/11/20.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "OverlayView.h"

@interface OverlayView ()

@property (nonatomic, strong) NSArray *horizontalGridLines;
@property (nonatomic, strong) NSArray *verticalGridLines;

@property (nonatomic, strong) NSArray *outerLineViews;   //top, right, bottom, left

- (void)setup;
- (void)layoutLines;

@end


@implementation OverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        [self setup];
    }
    
    return self;
}

- (void)setup{
    UIView *(^newLineView)(void) = ^UIView *(void) {
        UIView *newLine = [[UIView alloc] initWithFrame:CGRectZero];
        newLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:newLine];
        return newLine;
    };
    
    _outerLineViews     = @[newLineView(), newLineView(), newLineView(), newLineView()];
    _horizontalGridLines = @[newLineView(), newLineView()];
    _verticalGridLines = @[newLineView(), newLineView()];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if (_outerLineViews)
        [self layoutLines];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if (_outerLineViews)
        [self layoutLines];
}

- (void)layoutLines{
    CGSize boundsSize = self.bounds.size;
    
    //border lines
    for (NSInteger i = 0; i < 4; i++) {
        UIView *lineView = self.outerLineViews[i];
        
        CGRect frame = CGRectZero;
        switch (i) {
            case 0: frame = (CGRect){0,-1.0f,boundsSize.width+2.0f, 1.0f}; break; //top
            case 1: frame = (CGRect){boundsSize.width,0.0f,1.0f,boundsSize.height}; break; //right
            case 2: frame = (CGRect){-1.0f,boundsSize.height,boundsSize.width+2.0f,1.0f}; break; //bottom
            case 3: frame = (CGRect){-1.0f,0,1.0f,boundsSize.height+1.0f}; break; //left
        }
        
        lineView.frame = frame;
    }
    
    //grid lines - horizontal
    CGFloat thickness = 1.0f / [[UIScreen mainScreen] scale];
    NSInteger numberOfLines = self.horizontalGridLines.count;
    CGFloat padding = (CGRectGetHeight(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
    for (NSInteger i = 0; i < numberOfLines; i++) {
        UIView *lineView = self.horizontalGridLines[i];
        CGRect frame = CGRectZero;
        frame.size.height = thickness;
        frame.size.width = CGRectGetWidth(self.bounds);
        frame.origin.y = (padding * (i+1)) + (thickness * i);
        lineView.frame = frame;
    }
    
    //grid lines - vertical
    numberOfLines = self.verticalGridLines.count;
    padding = (CGRectGetWidth(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
    for (NSInteger i = 0; i < numberOfLines; i++) {
        UIView *lineView = self.verticalGridLines[i];
        CGRect frame = CGRectZero;
        frame.size.width = thickness;
        frame.size.height = CGRectGetHeight(self.bounds);
        frame.origin.x = (padding * (i+1)) + (thickness * i);
        lineView.frame = frame;
    }
}

- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated{
    _gridHidden = hidden;
    
    if (animated == NO) {
        for (UIView *lineView in self.horizontalGridLines) {
            lineView.alpha = hidden ? 0.0f : 1.0f;
        }
        
        for (UIView *lineView in self.verticalGridLines) {
            lineView.alpha = hidden ? 0.0f : 1.0f;
        }
        
        return;
    }
    
    [UIView animateWithDuration:hidden?0.35f:0.2f animations:^{
        for (UIView *lineView in self.horizontalGridLines)
            lineView.alpha = hidden ? 0.0f : 1.0f;
        
        for (UIView *lineView in self.verticalGridLines)
            lineView.alpha = hidden ? 0.0f : 1.0f;
    }];
}

- (void)setGridHidden:(BOOL)gridHidden{
    [self setGridHidden:gridHidden animated:NO];
}


@end
