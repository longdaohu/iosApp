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
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    
}
//设置放大动画
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *items = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
    //屏幕中线
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0f;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *item in items) {
        CGFloat distance = fabs(item.center.x - centerX);
        //移动的距离和屏幕宽度的的比例
        CGFloat apartScale = distance/self.collectionView.bounds.size.width;
        //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
        CGFloat scale = fabs(cos(apartScale * M_PI/4));
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        CGAffineTransform scale_tr = CGAffineTransformMakeScale(1, scale);
        //        CGAffineTransform tran_tr = CGAffineTransformMakeTranslation(0, item.size.height * (1-scale) * 0.5);
        item.transform =  scale_tr;//CGAffineTransformConcat(scale_tr, tran_tr);
        
    }
    
    return items;
}
- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attr in arr) {
        
        [arrM addObject:[attr copy]];
        
    }
    
    return arrM;
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
