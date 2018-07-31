//
//  HomeBannerThemeLayout.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeBannerThemeLayout.h"

@implementation HomeBannerThemeLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    // 获取collectionView的宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    // 获取当前的内容偏移量
    CGPoint targetP = proposedContentOffset;
    // 获取显示cell的布局属性数组，横向滚动，所以只用考虑横向的x和width，纵向不用考虑
    NSArray *attrs = [super layoutAttributesForElementsInRect:CGRectMake(targetP.x, 0, collectionW, MAXFLOAT)];
    // 距离中心点最近的cell的间距（中间那个cell距离最近，值可正可负）
    CGFloat minSpacing = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        // 距离中心点的偏移量
        CGFloat centerOffsetX = attr.center.x - targetP.x - collectionW * 0.5;
        // fabs()：CGFloat绝对值
        if (fabs(centerOffsetX) < fabs(minSpacing)) {
            minSpacing = centerOffsetX;
        }
    }
    targetP.x += minSpacing;
    
    return targetP;
    
}


@end
