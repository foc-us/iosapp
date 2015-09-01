//
//  FOCAttributeFlowLayout.m
//  Focus
//
//  Created by Jamie Lynch on 27/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCAttributeFlowLayout.h"

@implementation FOCAttributeFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if (fabsf(self.collectionView.bounds.size.height - newBounds.size.height) > FLT_EPSILON ) {
        return YES;
    }
    else {
        return [super shouldInvalidateLayoutForBoundsChange:newBounds];
    }
}

- (CGSize)collectionViewContentSize
{
    CGSize expandedSize = [super collectionViewContentSize];
    expandedSize.height = MAX(expandedSize.height, [[self collectionView] bounds].size.height);
    return expandedSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)reversedRect
{
    NSArray * attributes = [super layoutAttributesForElementsInRect:reversedRect];
    
    float greatestOrigin = 0.0;
    float greatestHeight = 0.0;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        float origin = attribute.frame.origin.y;
        float height = attribute.size.height;
        
        if (origin > greatestOrigin) {
            greatestOrigin = origin;
        }
        
        if (height > greatestHeight) {
            greatestHeight = height;
        }
    }
    
    float startHeight = [self collectionView].frame.size.height - (greatestHeight + greatestOrigin);
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGRect rect = attribute.frame;
        rect.origin.y += startHeight;
        attribute.frame = rect;
    }
    
    return attributes;
}

@end