//
//  PDTSimpleCalendarViewFlowLayout.m
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/7/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewFlowLayout.h"

const CGFloat PDTSimpleCalendarFlowLayoutMinInterItemSpacing = 0.0f;
const CGFloat PDTSimpleCalendarFlowLayoutMinLineSpacing = 0.0f;
const CGFloat PDTSimpleCalendarFlowLayoutInsetTop = 5.0f;
const CGFloat PDTSimpleCalendarFlowLayoutInsetLeft = 0.0f;
const CGFloat PDTSimpleCalendarFlowLayoutInsetBottom = 5.0f;
const CGFloat PDTSimpleCalendarFlowLayoutInsetRight = 0.0f;
const CGFloat PDTSimpleCalendarFlowLayoutHeaderHeight = 30.0f;

@implementation PDTSimpleCalendarViewFlowLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = PDTSimpleCalendarFlowLayoutMinInterItemSpacing;
        self.minimumLineSpacing = PDTSimpleCalendarFlowLayoutMinLineSpacing;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(PDTSimpleCalendarFlowLayoutInsetTop,
                                             PDTSimpleCalendarFlowLayoutInsetLeft,
                                             PDTSimpleCalendarFlowLayoutInsetBottom,
                                             PDTSimpleCalendarFlowLayoutInsetRight);
        self.headerReferenceSize = CGSizeMake(0, PDTSimpleCalendarFlowLayoutHeaderHeight);
        
        //Note: Item Size is defined using the delegate to take into account the width of the view and calculate size dynamically
    }

    return self;
}


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;

    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }

    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];

        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];

        [answer addObject:layoutAttributes];

    }];

    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {

        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {

            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];

            NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];

            UICollectionViewLayoutAttributes *firstCellAttrs = [self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
            UICollectionViewLayoutAttributes *lastCellAttrs = [self layoutAttributesForItemAtIndexPath:lastCellIndexPath];

            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(
                           MAX(
                               contentOffset.y,
                               (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)
                               ),
                           (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
                           );

            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
            
        }
        
    }
    
    return answer;
    
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
    
}

@end
