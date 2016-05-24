//
//  ReorderTableView.m
//  jianfanjia-designer
//
//  Created by Karos on 16/5/24.
//  Copyright © 2016年 JYZ. All rights reserved.
//

#import "ReorderTableView.h"

static NSString *ReorderTableViewCellReuseIdentifier = @"ReorderTableViewCellReuseIdentifier";

@interface ReorderTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *reorderGestureRecognizer;
@property (nonatomic, strong) UIImageView *reorderDragView;
@property (nonatomic, strong) NSIndexPath *reorderInitialIndexPath;
@property (nonatomic, strong) NSIndexPath *reorderCurrentIndexPath;
@property (nonatomic, strong) CADisplayLink *scrollDisplayLink;
@property (nonatomic, assign) CGFloat scrollRate;
@property (nonatomic, assign) CGFloat reorderDragViewShadowOpacity;
@property (nonatomic, assign) CGRect overrideDragRect;
@property (nonatomic, assign) BOOL isOverrideDragRect;
@property (nonatomic, weak) id realDataSource;
@property (nonatomic, weak) id realDelegate;

@end

@implementation ReorderTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _reorderGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeLongPressGestureRecognizer:)];
    [self addGestureRecognizer:_reorderGestureRecognizer];
    
    _reorderDragView = [[UIImageView alloc] init];
    _reorderDragView.contentMode = UIViewContentModeTop;
    _reorderDragView.layer.shadowColor = [UIColor blackColor].CGColor;
    _reorderDragView.layer.shadowRadius = 2;
    _reorderDragView.layer.shadowOpacity = 0.5;
    _reorderDragView.layer.shadowOffset = CGSizeMake(0, 0);
    _reorderDragView.layer.masksToBounds = NO;

    [super setDataSource:self];
    [super setDelegate:self];
    [self registerTemporaryEmptyCellClass:[UITableViewCell class]];
}

#pragma mark - Public
- (void)registerTemporaryEmptyCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:ReorderTableViewCellReuseIdentifier];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_reorderCurrentIndexPath && [_reorderCurrentIndexPath compare:indexPath] == NSOrderedSame) {
        UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:ReorderTableViewCellReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    } else {
        if ([_realDataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
            return [_realDataSource tableView:self cellForRowAtIndexPath:indexPath];
        }
        
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_realDataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [_realDataSource tableView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_realDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [_realDataSource numberOfSectionsInTableView:self];
    }
    
    return 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_reorderCurrentIndexPath && [_reorderCurrentIndexPath compare:indexPath] == NSOrderedSame) {
        return [self calculateDragViewFrame:CGPointMake(0, 0)].size.height + 30;
    } else {
        if ([_realDataSource respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            return [_realDelegate tableView:self heightForRowAtIndexPath:indexPath];
        }
        
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_realDataSource respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_realDelegate tableView:self heightForHeaderInSection:section];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([_realDataSource respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_realDelegate tableView:self heightForFooterInSection:section];
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([_realDataSource respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [_realDelegate tableView:self viewForHeaderInSection:section];
    }
    
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([_realDataSource respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [_realDelegate tableView:self viewForFooterInSection:section];
    }
    
    return nil;
}

#pragma mark - Data Source / Delegate Forwarding

- (void)dealloc { // Data Source forwarding
    self.delegate = nil;
    self.dataSource = nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_realDataSource respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_realDataSource];
    } else if ([_realDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_realDelegate];
    } else {
        [super forwardInvocation:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)s {
    return [super methodSignatureForSelector:s] ?: [(id)_realDataSource methodSignatureForSelector:s] ?: [(id)_realDelegate methodSignatureForSelector:s];
}

- (BOOL)respondsToSelector:(SEL)s {
    return [super respondsToSelector:s] || [_realDataSource respondsToSelector:s] || [_realDelegate respondsToSelector:s];
}

- (void)setDataSource:(id)dataSource { // Data Source forwarding
    [super setDataSource:dataSource ? self : nil];
    _realDataSource = dataSource != self ? dataSource : nil;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    [super setDelegate:delegate ? self : nil];
    _realDelegate = delegate != self ? delegate : nil;
}

#pragma mark - gesture
- (void)recognizeLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self didBeginLongPressGestureRecognizer:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self didChangeLongPressGestureRecognizer:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
            [self didEndLongPressGestureRecognizer:gestureRecognizer];
        default:
            break;
    }
}

- (void)didBeginLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    const CGPoint location = [gestureRecognizer locationInView:self];
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
    if (!indexPath) {
        return;
    }
    
    if (![self canDragCellAtIndexPath:indexPath]) {
        return;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    if ([_realDelegate respondsToSelector:@selector(orderTableView:dragViewRectAtIndexPath:)]) {
        self.overrideDragRect = [(id)_realDelegate orderTableView:self dragViewRectAtIndexPath:indexPath];
        self.isOverrideDragRect = YES;
    } else {
        self.isOverrideDragRect = NO;
    }

    UIImage *image = snapshotImageAtFrame(cell, self.isOverrideDragRect ? self.overrideDragRect : CGRectMake(0, 0, cellRect.size.width, cellRect.size.height));
    _reorderDragView.image = image;
    _reorderDragView.frame = [self calculateDragViewFrame:cellRect.origin];
    [self addSubview:_reorderDragView];

    _reorderInitialIndexPath = indexPath;
    _reorderCurrentIndexPath = indexPath;

    [UIView animateWithDuration:0.25 animations:^{
        _reorderDragView.center = CGPointMake(self.center.x, location.y);
    } completion:^(BOOL finished) {
    }];
    
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    _scrollDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableWithCell:)];
    [_scrollDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)didChangeLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    const CGPoint location = [gestureRecognizer locationInView:self];
    
    // update position of the drag view
    // don't let it go past the top or the bottom too far
    if (location.y >= 0 && location.y <= self.contentSize.height + 50) {
        _reorderDragView.center = CGPointMake(self.center.x, location.y);
    }
    
    CGRect rect = self.bounds;
    // adjust rect for content inset as we will use it below for calculating scroll zones
    rect.size.height -= self.contentInset.top;
    
    [self updateCurrentLocation:gestureRecognizer];
    
    // tell us if we should scroll and which direction
    CGFloat scrollZoneHeight = rect.size.height / 6;
    CGFloat bottomScrollBeginning = self.contentOffset.y + self.contentInset.top + rect.size.height - scrollZoneHeight;
    CGFloat topScrollBeginning = self.contentOffset.y + self.contentInset.top  + scrollZoneHeight;
    
    // we're in the bottom zone
    if (location.y >= bottomScrollBeginning) {
        _scrollRate = (location.y - bottomScrollBeginning) / scrollZoneHeight;
    }
    // we're in the top zone
    else if (location.y <= topScrollBeginning) {
        _scrollRate = (location.y - topScrollBeginning) / scrollZoneHeight;
    } else {
        _scrollRate = 0;
    }
}

- (void)didEndLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    NSIndexPath *curIndexPath = _reorderCurrentIndexPath;
    
    if (!curIndexPath) {
        return;
    }
    
    if (![self canDragCellAtIndexPath:curIndexPath]) {
        return;
    }
    
    { // Reset
        [_scrollDisplayLink invalidate];
        _scrollDisplayLink = nil;
        _scrollRate = 0;
        _reorderCurrentIndexPath = nil;
        _reorderInitialIndexPath = nil;
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect rect = [self rectForRowAtIndexPath:curIndexPath];
                         _reorderDragView.frame = [self calculateDragViewFrame:rect.origin];
                     } completion:^(BOOL finished) {
                         [self reloadRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                         [self performSelector:@selector(removeReorderDragView) withObject:nil afterDelay:0]; // Prevent flicker
                     }];
}

- (void)removeReorderDragView {
    [_reorderDragView removeFromSuperview];
}

- (void)updateCurrentLocation:(UILongPressGestureRecognizer *)gesture {
    const CGPoint location  = [gesture locationInView:self];
    NSIndexPath *toIndexPath = [self indexPathForRowAtPoint:location];
    
    if (!toIndexPath) {
        return;
    }
    
    if (![self canDragCellAtIndexPath:toIndexPath]) {
        return;
    }
    
    if (toIndexPath.section != _reorderCurrentIndexPath.section) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]) {
        toIndexPath = [self.delegate tableView:self targetIndexPathForMoveFromRowAtIndexPath:_reorderInitialIndexPath toProposedIndexPath:toIndexPath];
    }
    
    if ([toIndexPath compare:_reorderCurrentIndexPath] == NSOrderedSame) return;
    
    NSInteger originalHeight = _reorderDragView.frame.size.height;
    NSInteger toHeight = [self rectForRowAtIndexPath:toIndexPath].size.height;
    UITableViewCell *toCell = [self cellForRowAtIndexPath:toIndexPath];
    const CGPoint toCellLocation = [gesture locationInView:toCell];
    
    if (toCellLocation.y <= toHeight - originalHeight) return;
    
    [self reorderCurrentRowToIndexPath:toIndexPath];
}

- (void)reorderCurrentRowToIndexPath:(NSIndexPath*)toIndexPath {
    [self beginUpdates];
    [self moveRowAtIndexPath:toIndexPath toIndexPath:_reorderCurrentIndexPath]; // Order is important to keep the empty cell behind
    if ([self.dataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)]) {
        [self.dataSource tableView:self moveRowAtIndexPath:_reorderCurrentIndexPath toIndexPath:toIndexPath];
    }
    _reorderCurrentIndexPath = toIndexPath;
    [self endUpdates];
}

- (void)scrollTableWithCell:(NSTimer *)timer {
    UILongPressGestureRecognizer *gesture = self.reorderGestureRecognizer;
    const CGPoint location = [gesture locationInView:self];
    
    CGPoint currentOffset = self.contentOffset;
    CGPoint newOffset = CGPointMake(currentOffset.x, currentOffset.y + _scrollRate * 10);
    
    if (newOffset.y < -self.contentInset.top) {
        newOffset.y = -self.contentInset.top;
    } else if (self.contentSize.height + self.contentInset.bottom < self.frame.size.height) {
        newOffset = currentOffset;
    } else if (newOffset.y > (self.contentSize.height + self.contentInset.bottom) - self.frame.size.height) {
        newOffset.y = (self.contentSize.height + self.contentInset.bottom) - self.frame.size.height;
    }
    
    [self setContentOffset:newOffset];
    
    if (location.y >= 0 && location.y <= self.contentSize.height + 50) {
        _reorderDragView.center = CGPointMake(self.center.x, location.y);
    }
    
    [self updateCurrentLocation:gesture];
}

- (BOOL)canDragCellAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canDrag = YES;
    if ([_realDelegate respondsToSelector:@selector(orderTableView:canDragAtIndexPath:)]) {
        canDrag = [(id)_realDelegate orderTableView:self canDragAtIndexPath:indexPath];
    }
    
    return canDrag;
}

- (CGRect)calculateDragViewFrame:(CGPoint)cellPoint {
    return CGRectOffset(CGRectMake(0, 0, self.reorderDragView.image.size.width, self.reorderDragView.image.size.height), cellPoint.x + (self.isOverrideDragRect ? self.overrideDragRect.origin.x : 0.0), cellPoint.y + (self.isOverrideDragRect ? self.overrideDragRect.origin.y : 0.0));
}

static UIImage* snapshotImageAtFrame(UIView *view, CGRect r) {
    UIGraphicsBeginImageContextWithOptions(r.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:CGRectMake(-r.origin.x, -r.origin.y, view.bounds.size.width, view.bounds.size.height) afterScreenUpdates:YES];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end
