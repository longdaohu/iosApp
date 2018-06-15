//
//  HomeCommoditieCell.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/8.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeCommoditieCell.h"
#import "HomeSingleImageCell.h"
#import "ServiceSKU.h"
@interface  HomeCommoditieCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *bgView;
@property(nonatomic,assign)NSInteger current_index;
@property(nonatomic,strong)NSArray *items;

@end

@interface HomeCommoditieLayout ()

@end

@implementation HomeCommoditieLayout

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
        CGFloat scale = fabs(cos(apartScale * M_PI/3));
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        CGAffineTransform scale_tr = CGAffineTransformMakeScale(scale + (1-scale) * 0.9, scale);
        CGAffineTransform tran_tr = CGAffineTransformMakeTranslation(0, item.size.height * (1-scale) * 0.5);
        item.transform =  CGAffineTransformConcat(scale_tr, tran_tr);
        
    }

    return items;
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
- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attr in arr) {
        
        [arrM addObject:[attr copy]];
        
    }
    
    return arrM;
}


@end



@implementation HomeCommoditieCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    HomeCommoditieLayout *layout = [[HomeCommoditieLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    self.bgView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
    self.bgView.dataSource = self;
    self.bgView.delegate = self;
    self.bgView.backgroundColor = XCOLOR_WHITE;
    [self.contentView addSubview:self.bgView];
 
    [self.bgView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"HomeSingleImageCell"];
     self.bgView.decelerationRate = UIScrollViewDecelerationRateFast;
}


- (void)setGroup:(myofferGroupModel *)group{
    
    _group = group;
    if (group.items.count > 0) {
        self.items = group.items.firstObject;
    }
    if (group.cell_offset_x == 0) {
        group.cell_offset_x = -self.bgView.contentInset.left;
    }
//    [self.bgView setContentOffset:CGPointMake(group.cell_offset_x, 0) animated:NO];
}

#pragma mark : UICollectionViewDataSource  UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    HomeSingleImageCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSingleImageCell" forIndexPath:indexPath];
    ServiceSKU *sku = self.items[indexPath.row];
    cell.path = [sku.coverUrl toUTF8WithString];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ServiceSKU *sku = self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(sku.sku_id);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgView) {
        NSLog(@"scrollViewDidScroll    %lf",scrollView.mj_offsetX);
        self.group.cell_offset_x = scrollView.mj_offsetX;
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize content_size = self.contentView.bounds.size;
    if (self.bgView.mj_h != self.contentView.mj_h) {
        self.bgView.frame = self.contentView.bounds;
        
        HomeCommoditieLayout *layout =  (HomeCommoditieLayout *)self.bgView.collectionViewLayout;
        CGFloat item_h = content_size.height - 10;
        CGFloat item_w =  224 * item_h/150;
        layout.itemSize = CGSizeMake(item_w, item_h);
        self.bgView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
}

@end


