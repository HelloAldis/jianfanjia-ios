#import "InfiniteScrollView.h"

@interface InfiniteScrollView ()

@property (nonatomic, strong) NSMutableArray *visibleViews;
@property (nonatomic, strong) NSMutableArray *allViews;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger rightMostVisibleViewIndex;
@property (nonatomic, assign) NSInteger leftMostVisibleViewIndex;

@end


@implementation InfiniteScrollView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.contentSize = CGSizeMake(5000, self.frame.size.height);
        
        _visibleViews = [[NSMutableArray alloc] init];
        
        _containerView = [[UIView alloc] init];
        self.containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        [self addSubview:self.containerView];

        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];
    }
    
    return self;
}

- (void)reloadData {
    NSAssert([self.infiniteDelegate respondsToSelector:@selector(numberOfGroupInInfiniteScrollView:)], @"您还没有实现 numberOfGroupInInfiniteScrollView:");
    NSAssert([self.infiniteDelegate respondsToSelector:@selector(infiniteScrollView:viewAtIndex:)], @"您还没有实现 infiniteScrollView:viewAtIndex:");
    
    _allViews = [NSMutableArray array];
    NSInteger numberOfGroup = [self.infiniteDelegate numberOfGroupInInfiniteScrollView:self];
    
    CGFloat x = 0.0f;
    NSInteger index = 0;
    while (x < self.frame.size.width * 2) {
        for (index = 0; index < numberOfGroup; index++) {
            UIView *view = [self.infiniteDelegate infiniteScrollView:self viewAtIndex:index];
            x += CGRectGetWidth(view.frame);
            [_allViews addObject:view];
        }
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)getDistanceToLeftEdgeForSubview:(UIView *)view {
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.containerView];
    return CGRectGetMinX(view.frame) - CGRectGetMinX(visibleBounds);
}

#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0)) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // move content by the same amount so it appears to stay still
        for (UIView *label in self.visibleViews) {
            CGPoint center = [self.containerView convertPoint:label.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            label.center = [self convertPoint:center toView:self.containerView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_allViews.count > 0) {
        [self recenterIfNecessary];
        
        // tile content in visible bounds
        CGRect visibleBounds = [self convertRect:[self bounds] toView:self.containerView];
        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        
        [self tileViewsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
    }
}

#pragma mark - View Tiling

- (CGFloat)placeNewViewOnRight:(CGFloat)rightEdge {
    _rightMostVisibleViewIndex++;
    if (_rightMostVisibleViewIndex == [_allViews count]) {
        _rightMostVisibleViewIndex = 0;
    }
    
    UIView *view = _allViews[_rightMostVisibleViewIndex];
    [_containerView addSubview:view];
    [_visibleViews addObject:view]; // add rightmost label at the end of the array
    
    CGRect frame = [view frame];
    frame.origin.x = rightEdge;
    frame.origin.y = ([_containerView bounds].size.height - frame.size.height) / 2.0f;
    [view setFrame:frame];
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewViewOnLeft:(CGFloat)leftEdge {
    _leftMostVisibleViewIndex--;
    if (_leftMostVisibleViewIndex < 0) {
        _leftMostVisibleViewIndex = [_allViews count] - 1;
    }
    
    UIView *view = _allViews[_leftMostVisibleViewIndex];
    [_containerView addSubview:view];
    [_visibleViews insertObject:view atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [view frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = ([_containerView bounds].size.height - frame.size.height) / 2.0f;
    [view setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tileViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleViews count] == 0) {
        _rightMostVisibleViewIndex = -1;
        _leftMostVisibleViewIndex = 0;
        [self placeNewViewOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    UIView *lastView = [_visibleViews lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastView frame]);
    
    while (rightEdge < maximumVisibleX) {
        rightEdge = [self placeNewViewOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    UIView *firstView = _visibleViews[0];
    CGFloat leftEdge = CGRectGetMinX([firstView frame]);
    while (leftEdge > minimumVisibleX) {
        leftEdge = [self placeNewViewOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastView = [_visibleViews lastObject];
    while ([lastView frame].origin.x > maximumVisibleX) {
        [lastView removeFromSuperview];
        [_visibleViews removeLastObject];
        lastView = [_visibleViews lastObject];
        
        _rightMostVisibleViewIndex--;
        if (_rightMostVisibleViewIndex < 0) {
            _rightMostVisibleViewIndex = [_allViews count] - 1;
        }
    }
    
    // remove labels that have fallen off left edge
    firstView = _visibleViews[0];
    while (CGRectGetMaxX([firstView frame]) < minimumVisibleX) {
        [firstView removeFromSuperview];
        [_visibleViews removeObjectAtIndex:0];
        firstView = _visibleViews[0];
        
        _leftMostVisibleViewIndex++;
        if (_leftMostVisibleViewIndex == [_allViews count]) {
            _leftMostVisibleViewIndex = 0;
        }
    }
}

- (void)dealloc {
    DDLogDebug(@"Infinite scroll view dealloc");
}

@end