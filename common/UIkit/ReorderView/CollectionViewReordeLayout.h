
#import "CollectionViewReordeLayout.h"

@protocol CollectionViewReordeLayoutDataSource <UICollectionViewDataSource>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol CollectionViewReordeLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional
- (CGRect)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout dragViewRectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CollectionViewReordeLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<CollectionViewReordeLayoutDelegate> delegate;
@property (nonatomic, weak) id<CollectionViewReordeLayoutDataSource> dataSource;

@end
