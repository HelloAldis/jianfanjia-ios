//
//  ReuseScrollView.m
//  jianfanjia
//
//  Created by Karos on 16/5/3.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReuseScrollView.h"

@interface ReuseCell ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation ReuseCell

- (void)reloadData:(ReuseScrollView *)scrollView item:(id)item {
    // need override
}

@end

@interface ReuseScrollView () <UIScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *cells;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL wasFirstDisplay;

@end

@implementation ReuseScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    self.cellSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    
    _cells = @[].mutableCopy;
}

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.wasFirstDisplay) {
        self.wasFirstDisplay = YES;
        [self scrollRectToVisible:CGRectMake((_cellSize.width + _padding) * self.index, 0, _cellSize.width + _padding, self.frame.size.height) animated:NO];
        [self scrollViewDidScroll:self];
    }
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];
    
    CGFloat floatPage = self.contentOffset.x / self.frame.size.width;
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _items.count ? _items.count - 1 : intPage;
    
    NSInteger page = self.contentOffset.x / self.frame.size.width + 0.5;
    
    for (NSInteger i = page - 2; i <= page + 2; i++) { // preload left and right cell
        if (i >= 0 && i < _items.count) {
            ReuseCell *cell = [self cellForPage:i];
            if (!cell) {
                ReuseCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.curPage = intPage;
                
                CGRect frame = cell.frame;
                frame.origin.x = (_cellSize.width + _padding) * i + _padding / 2;
                cell.frame = frame;
                
                [cell reloadData:self item:_items[i]];
                [self addSubview:cell];
            } else {
                if (cell.page != -1) {
                    cell.curPage = intPage;
                    [cell reloadData:self item:_items[i]];
                }
            }
        }
    }

    
    self.currentPage = intPage;
    
    if ([_reuseDelegate respondsToSelector:@selector(reuseScrollViewDidScroll:)]) {
        [_reuseDelegate reuseScrollViewDidScroll:self];
    }
    
    if ([_reuseDelegate respondsToSelector:@selector(reuseScrollViewDidChangePage:toPage:)]) {
        [_reuseDelegate reuseScrollViewDidChangePage:self toPage:intPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_reuseDelegate respondsToSelector:@selector(reuseScrollViewDidEndDragging:willDecelerate:)]) {
        [_reuseDelegate reuseScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_reuseDelegate respondsToSelector:@selector(reuseScrollViewDidEndDecelerating:)]) {
        [_reuseDelegate reuseScrollViewDidEndDecelerating:self];
    }
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (ReuseCell *cell in _cells) {
        if (cell.superview) {
            if (cell.frame.origin.x > self.contentOffset.x + self.frame.size.width * 2 ||
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
    cell.frame = CGRectMake(0, 0, _cellSize.width, _cellSize.height);
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

- (CGRect)getOriginCellFrame:(NSInteger)page {
    return CGRectMake((_cellSize.width + _padding) * page + _padding / 2, 0, _cellSize.width, _cellSize.height);
}

#pragma mark - properties
- (void)setReuseDelegate:(id<ReuseScrollViewProtocol>)reuseDelegate {
    _reuseDelegate = reuseDelegate;
}

- (void)setPadding:(NSInteger)padding {
    _padding = padding;
    self.frame = CGRectMake(self.frame.origin.x - _padding / 2, self.frame.origin.y, _cellSize.width + _padding, self.frame.size.height);
    self.contentSize = CGSizeMake((_cellSize.width + _padding) * _items.count, self.frame.size.height);
}

- (void)setItems:(NSArray *)items {
    _items = items;
    self.contentSize = CGSizeMake((_cellSize.width + _padding) * _items.count, self.frame.size.height);
}

@end
