//
//  ReuseScrollView.m
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReuseScrollView.h"

@interface ReuseScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, assign) BOOL wasFirstDisplay;

@end

@implementation ReuseScrollView

- (instancetype)initWithFrame:(CGRect)frame items:(NSInteger)totalItems {
    self = [super initWithFrame:frame];
    _totalItems = totalItems;
    [self initUI];

    return self;
}

- (void)initUI {
    self.delegate = self;
    self.scrollsToTop = NO;
    self.pagingEnabled = YES;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.contentSize = CGSizeMake((self.frame.size.width -  self.padding) * _totalItems, self.frame.size.height);
    
    _cells = @[].mutableCopy;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.wasFirstDisplay) {
        self.wasFirstDisplay = YES;
        [self scrollViewDidScroll:self];
    }
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    NSInteger page = self.contentOffset.x / self.frame.size.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.totalItems) {
            ReuseCell *cell = [self cellForPage:i];
            if (!cell) {
                ReuseCell *cell = [self dequeueReusableCell];
                cell.page = i;
                
                CGRect frame = cell.frame;
                frame.origin.x = (self.frame.size.width + self.padding) * i + self.padding / 2;
                cell.frame = frame;
                
                [cell reloadData];
                [self addSubview:cell];
            } else {
                [cell reloadData];
            }
        }
    }
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (ReuseCell *cell in _cells) {
        if (cell.superview) {
            if (cell.frame.origin.x > self.contentOffset.x + self.frame.size.width * 2||
                (cell.frame.origin.x + cell.frame.size.width) < self.contentOffset.x - self.frame.size.width) {
                [cell removeFromSuperview];
                cell.page = -1;
            }
        }
    }
}

/// dequeue a reusable cell
- (ReuseCell *)dequeueReusableCell {
    ReuseCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    if (![_reuseDelegate respondsToSelector:@selector(reuseCellFactory)]) return nil;
    
    cell = [_reuseDelegate reuseCellFactory];
    cell.frame = CGRectMake(0, 0, self.frame.size.width - self.padding, self.frame.size.height);
    cell.bgColor = [UIColor redColor];
    cell.page = -1;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (ReuseCell *)cellForPage:(NSInteger)page {
    for (ReuseCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

#pragma mark - properties
- (void)setReuseDelegate:(id<ReuseScrollViewProtocol>)reuseDelegate {
    _reuseDelegate = reuseDelegate;
}

- (void)setPadding:(NSInteger)padding {
    _padding = padding;
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x - padding / 2, frame.origin.y, frame.size.width + padding, frame.size.height);
    self.contentSize = CGSizeMake((self.frame.size.width - padding)* _totalItems, self.frame.size.height);
}

@end
