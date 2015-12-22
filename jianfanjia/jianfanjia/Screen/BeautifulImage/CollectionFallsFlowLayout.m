//
//  PrettyPictureFallsLayout.m
//  jianfanjia
//
//  Created by likaros on 15/12/19.
//  Copyright © 2015年 JYZ. All rights reserved.
//

#import "CollectionFallsFlowLayout.h"

@interface CollectionFallsFlowLayout ()

/// Array to store height for each column
@property (nonatomic, strong) NSMutableArray *columnHeights;
/// Array to store attributes for all items includes headers, cells, and footers
@property (nonatomic, strong) NSMutableArray *allItemAttributes;
/// Array to store union rectangles
@property (nonatomic, strong) NSMutableArray *unionRects;

@end

@implementation CollectionFallsFlowLayout

static const NSInteger COUNT_IN_ONE_ROW = 2;
static const NSInteger CELL_SPACE = 10;
static const NSInteger SECTION_EDGE = 10;

/// How many items to be union into a single rectangle
static NSInteger unionSize = 20;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfiguration];
    }
    
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initConfiguration];
    }
    
    return self;
}

- (void)initConfiguration {
    self.columnSpace = CELL_SPACE;
    self.rowSpace = CELL_SPACE;
    self.columnCount = COUNT_IN_ONE_ROW;
    self.insets = UIEdgeInsetsMake(SECTION_EDGE, SECTION_EDGE, SECTION_EDGE, SECTION_EDGE);
    self.columnHeights = [NSMutableArray array];
    self.allItemAttributes = [NSMutableArray array];
    self.unionRects = [NSMutableArray array];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.unionRects removeAllObjects];
    [self.columnHeights removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0) {
        return;
    }
    
    NSAssert([self.delegate conformsToProtocol:@protocol(CollectionFallsFlowLayoutProtocol)], @"UICollectionView's delegate should conform to PrettyPictureFallsLayoutProtocol protocol");
    
    NSInteger idx;
    for (idx = 0; idx < self.columnCount; idx++) {
        self.columnHeights[idx] = @(self.insets.top);
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    // Item will be put into shortest column.
    for (idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        // 获取cell底部Y值最小的列
        NSInteger shortestColIndex = [self shortestColumnIndex];
        CGFloat itemWidth = (self.collectionView.frame.size.width - self.insets.left - self.insets.right - (self.columnCount - 1) * self.columnSpace) / self.columnCount;
        itemWidth = floor(itemWidth);
        CGFloat height = [self.delegate fallFlowLayout:self heightForWidth:itemWidth atIndexPath:indexPath];
        if (isnan(height)) {
            height = itemWidth;
        }
        
        height = floor(height);
        CGFloat x = self.insets.left + (itemWidth + self.columnSpace) * shortestColIndex;
        CGFloat y = [self.columnHeights[shortestColIndex] floatValue];

        // 创建属性
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attrs.frame = CGRectMake(x, y, itemWidth, height);
        self.columnHeights[shortestColIndex] = @(CGRectGetMaxY(attrs.frame) + self.rowSpace);
        [self.allItemAttributes addObject:attrs];
    }
    
    // Build union rects
    idx = 0;
    NSInteger itemCounts = [self.allItemAttributes count];
    while (idx < itemCounts) {
        CGRect unionRect = ((UICollectionViewLayoutAttributes *)self.allItemAttributes[idx]).frame;
        NSInteger rectEndIndex = MIN(idx + unionSize, itemCounts);
        
        for (NSInteger i = idx + 1; i < rectEndIndex; i++) {
            unionRect = CGRectUnion(unionRect, ((UICollectionViewLayoutAttributes *)self.allItemAttributes[i]).frame);
        }
        
        idx = rectEndIndex;
        
        [self.unionRects addObject:[NSValue valueWithCGRect:unionRect]];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger i;
    NSInteger begin = 0, end = self.unionRects.count;
    NSMutableArray *attrs = [NSMutableArray array];
    
    for (i = 0; i < self.unionRects.count; i++) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            begin = i * unionSize;
            break;
        }
    }
    for (i = self.unionRects.count - 1; i >= 0; i--) {
        if (CGRectIntersectsRect(rect, [self.unionRects[i] CGRectValue])) {
            end = MIN((i + 1) * unionSize, self.allItemAttributes.count);
            break;
        }
    }
    for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    
    return [NSArray arrayWithArray:attrs];
}

- (CGSize)collectionViewContentSize {
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat maxY = [self.columnHeights[[self longestColumnIndex]] floatValue];
    return CGSizeMake(width, maxY + self.insets.bottom);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

#pragma mark - util
/**
 *  Find the shortest column.
 *
 *  @return index for the shortest column
 */
- (NSUInteger)shortestColumnIndex {
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

/**
 *  Find the longest column.
 *
 *  @return index for the longest column
 */
- (NSUInteger)longestColumnIndex {
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

@end
