//
//  RACollectionViewReorderableTripletLayout.m
//  RACollectionViewTripletLayout-Demo
//
//  Created by Ryo Aoyama on 5/27/14.
//  Copyright (c) 2014 Ryo Aoyama. All rights reserved.
//

#import "CollectionViewReordeLayout.h"

@interface CollectionViewReordeLayout()

@property (nonatomic, strong) UILongPressGestureRecognizer *reorderGestureRecognizer;
@property (nonatomic, strong) UIImageView *reorderDragView;
@property (nonatomic, strong) NSIndexPath *reorderInitialIndexPath;
@property (nonatomic, strong) NSIndexPath *reorderCurrentIndexPath;
@property (nonatomic, strong) CADisplayLink *scrollDisplayLink;
@property (nonatomic, assign) CGFloat scrollRate;
@property (nonatomic, assign) CGFloat reorderDragViewShadowOpacity;
@property (nonatomic, assign) CGRect overrideDragRect;
@property (nonatomic, assign) BOOL isOverrideDragRect;
@property (nonatomic, assign) BOOL setUped;

@end

@implementation CollectionViewReordeLayout

#pragma mark - Override methods

- (void)setDelegate:(id<CollectionViewReordeLayoutDelegate>)delegate {
    self.collectionView.delegate = delegate;
}

- (id<CollectionViewReordeLayoutDelegate>)delegate {
    return (id<CollectionViewReordeLayoutDelegate>)self.collectionView.delegate;
}

- (void)setDataSource:(id<CollectionViewReordeLayoutDataSource>)dataSource {
    self.collectionView.dataSource = dataSource;
}

- (id<CollectionViewReordeLayoutDataSource>)dataSource {
    return (id<CollectionViewReordeLayoutDataSource>)self.collectionView.dataSource;
}

- (void)prepareLayout {
    [super prepareLayout];
    //gesture
    [self setUpCollectionViewGesture];
}

#pragma mark - Methods
- (void)setUpCollectionViewGesture {
    if (!_setUped) {
        _reorderGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeLongPressGestureRecognizer:)];
        _reorderDragView = [[UIImageView alloc] init];
        _reorderDragView.contentMode = UIViewContentModeTop;
        _reorderDragView.layer.shadowColor = [UIColor blackColor].CGColor;
        _reorderDragView.layer.shadowRadius = 2;
        _reorderDragView.layer.shadowOpacity = 0.5;
        _reorderDragView.layer.shadowOffset = CGSizeMake(0, 0);
        _reorderDragView.layer.masksToBounds = NO;
        
        for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
                [gestureRecognizer requireGestureRecognizerToFail:_reorderGestureRecognizer]; }}
        
        [self.collectionView addGestureRecognizer:_reorderGestureRecognizer];
        _setUped = YES;
    }
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
    const CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath) {
        return;
    }
    
    //can move
    if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        if (![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:indexPath]) {
            return;
        }
    }
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect cellRect = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:dragViewRectAtIndexPath:)]) {
        self.overrideDragRect = [(id)self.delegate collectionView:self.collectionView layout:self dragViewRectAtIndexPath:indexPath];
        self.isOverrideDragRect = YES;
    } else {
        self.isOverrideDragRect = NO;
    }
    
    UIImage *image = snapshotImageAtFrame(cell, self.isOverrideDragRect ? self.overrideDragRect : CGRectMake(0, 0, cellRect.size.width, cellRect.size.height));
    _reorderDragView.image = image;
    _reorderDragView.frame = [self calculateDragViewFrame:cellRect.origin];
    [self.collectionView addSubview:_reorderDragView];
    
    _reorderInitialIndexPath = indexPath;
    _reorderCurrentIndexPath = indexPath;
    
    [UIView animateWithDuration:0.25 animations:^{
        _reorderDragView.center = CGPointMake(location.x, location.y);
        cell.hidden = YES;
        cell.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
    
    _scrollDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableWithCell:)];
    [_scrollDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)didChangeLongPressGestureRecognizer:(UILongPressGestureRecognizer*)gestureRecognizer {
    const CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    
    // update position of the drag view
    // don't let it go past the top or the bottom too far
    if (location.y >= 0 && location.y <= self.collectionView.contentSize.height + 50) {
        _reorderDragView.center = CGPointMake(location.x, location.y);
    }
    
    CGRect rect = self.collectionView.bounds;
    // adjust rect for content inset as we will use it below for calculating scroll zones
    rect.size.height -= self.collectionView.contentInset.top;
    
    [self updateCurrentLocation:gestureRecognizer];
    
    // tell us if we should scroll and which direction
    CGFloat scrollZoneHeight = rect.size.height / 6;
    CGFloat bottomScrollBeginning = self.collectionView.contentOffset.y + self.collectionView.contentInset.top + rect.size.height - scrollZoneHeight;
    CGFloat topScrollBeginning = self.collectionView.contentOffset.y + self.collectionView.contentInset.top  + scrollZoneHeight;
    
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
    
    { // Reset
        [_scrollDisplayLink invalidate];
        _scrollDisplayLink = nil;
        _scrollRate = 0;
        _reorderCurrentIndexPath = nil;
        _reorderInitialIndexPath = nil;
    }
    
    UICollectionViewCell *toCell = [self.collectionView cellForItemAtIndexPath:curIndexPath];
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGRect rect = [self layoutAttributesForItemAtIndexPath:curIndexPath].frame;
                         _reorderDragView.frame = [self calculateDragViewFrame:rect.origin];
                     } completion:^(BOOL finished) {
                         toCell.hidden = NO;
                         toCell.alpha = 1.0;
                         [self performSelector:@selector(removeReorderDragView) withObject:nil afterDelay:0]; // Prevent flicker
                     }];
}

- (void)removeReorderDragView {
    [_reorderDragView removeFromSuperview];
}

- (void)updateCurrentLocation:(UILongPressGestureRecognizer *)gesture {
    const CGPoint location  = [gesture locationInView:self.collectionView];
    NSIndexPath *toIndexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if (!toIndexPath) {
        return;
    }
    
    //can move
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)]) {
        if (![self.dataSource collectionView:self.collectionView itemAtIndexPath:_reorderCurrentIndexPath canMoveToIndexPath:toIndexPath]) {
            return;
        }
    }
    
    if (toIndexPath.section != _reorderCurrentIndexPath.section) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:)]) {
        toIndexPath = [self.delegate collectionView:self.collectionView targetIndexPathForMoveFromItemAtIndexPath:_reorderCurrentIndexPath toProposedIndexPath:toIndexPath];
    }
    
    if ([toIndexPath compare:_reorderCurrentIndexPath] == NSOrderedSame) return;
    
    NSInteger originalHeight = _reorderDragView.frame.size.height;
    NSInteger toHeight = [self layoutAttributesForItemAtIndexPath:toIndexPath].size.height;
    UICollectionViewCell *toCell = [self.collectionView cellForItemAtIndexPath:toIndexPath];
    const CGPoint toCellLocation = [gesture locationInView:toCell];
    
    if (toCellLocation.y <= toHeight - originalHeight) return;
    
    [self reorderCurrentRowToIndexPath:toIndexPath];
}

- (void)reorderCurrentRowToIndexPath:(NSIndexPath*)toIndexPath {
    NSIndexPath *atIndexPath = _reorderCurrentIndexPath;
    
    //will move
    if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
        [self.dataSource collectionView:self.collectionView itemAtIndexPath:atIndexPath willMoveToIndexPath:toIndexPath];
    }

    [self.collectionView performBatchUpdates:^{
        _reorderCurrentIndexPath = toIndexPath;
        [self.collectionView moveItemAtIndexPath:atIndexPath toIndexPath:toIndexPath];
        //did move
        if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
            [self.dataSource collectionView:self.collectionView itemAtIndexPath:atIndexPath didMoveToIndexPath:toIndexPath];
        }
    } completion:^(BOOL finished) {
    }];
}

- (void)scrollTableWithCell:(NSTimer *)timer {
    UILongPressGestureRecognizer *gesture = self.reorderGestureRecognizer;
    const CGPoint location = [gesture locationInView:self.collectionView];
    
    CGPoint currentOffset = self.collectionView.contentOffset;
    CGPoint newOffset = CGPointMake(currentOffset.x, currentOffset.y + _scrollRate * 10);
    
    if (newOffset.y < -self.collectionView.contentInset.top) {
        newOffset.y = -self.collectionView.contentInset.top;
    } else if (self.collectionView.contentSize.height + self.collectionView.contentInset.bottom < self.collectionView.frame.size.height) {
        newOffset = currentOffset;
    } else if (newOffset.y > (self.collectionView.contentSize.height + self.collectionView.contentInset.bottom) - self.collectionView.frame.size.height) {
        newOffset.y = (self.collectionView.contentSize.height + self.collectionView.contentInset.bottom) - self.collectionView.frame.size.height;
    }
    
    [self.collectionView setContentOffset:newOffset];
    
    if (location.y <= self.collectionView.contentSize.width + 50 && location.y <= self.collectionView.contentSize.height + 50) {
        _reorderDragView.center = CGPointMake(location.x, location.y);
    }
    
    [self updateCurrentLocation:gesture];
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
