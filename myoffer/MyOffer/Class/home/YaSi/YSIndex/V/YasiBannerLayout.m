//
//  YasiBannerLayout.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YasiBannerLayout.h"

@implementation YasiBannerLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0;
        self.zoom_mini = 0.2;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    
}

- (void)setZoom_mini:(CGFloat)zoom_mini{
    _zoom_mini = zoom_mini;
    
    if (zoom_mini >= 1) {
        self.zoom_mini = 0.2;
    }
}

//设置放大动画
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //当前显示的视图位置
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    NSMutableArray *attArray = [[NSMutableArray alloc] init];
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        UICollectionViewLayoutAttributes *att = [attributes copy];
        if ( CGRectIntersectsRect(attributes.frame, rect)) {
            //cell中心距屏幕中心距离
            CGFloat distance = CGRectGetMidX(visibleRect)-att.center.x;
            distance = ABS(distance);
            //判断,cell是否居中
            CGFloat zoom  = 1 - (self.zoom_mini) * (distance / XSCREEN_WIDTH * 0.5);
//            NSLog(@" zoom == %lf   distance = %lf ",zoom,distance);
            if (distance < (XSCREEN_WIDTH * 0.5 + self.itemSize.width)) {
                //居中就放大 zoom比例
                att.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                
            }
        }
        [attArray addObject:att];
    }
    
    return attArray;
    
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
