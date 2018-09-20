//
//  RoomBannerView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomBannerView.h"
#import "YasiBannerLayout.h"
#import "HomeSingleImageCell.h"

@interface RoomBannerView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *bannerView;//轮播图
@property(nonatomic,strong)YasiBannerLayout *flow;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,assign)CGFloat dragStartX;
@property(nonatomic,assign)CGFloat dragEndX;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSArray *imageGroup;

@end

@implementation RoomBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //轮播图
        YasiBannerLayout *flow = [[YasiBannerLayout alloc] init];
        self.flow = flow;
        UICollectionView *bannerView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        bannerView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self addSubview:bannerView];
        self.bannerView = bannerView;
        bannerView.backgroundColor = XCOLOR_CLEAR;
        bannerView.showsHorizontalScrollIndicator = false;
        bannerView.delegate = self;
        bannerView.dataSource = self;
        [bannerView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"bannerCell"];
        if (@available(iOS 11.0, *)) {
            bannerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        //轮播图 pageControl
        UIPageControl *pageControl = [UIPageControl new];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        pageControl.currentPageIndicatorTintColor = XCOLOR_LIGHTBLUE;
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)makeBannerWithImages:(NSArray *)imageGroup bannerSize:(CGSize)itemSize{
    
    //轮播图片
    [self removeBannerTimer];

    if (imageGroup.count > 0) {
        
        self.currentIndex = 0;
        self.flow.itemSize = itemSize;
        self.bannerView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, itemSize.height);
        self.imageGroup = imageGroup;
        [self.bannerView reloadData];
        self.pageControl.numberOfPages = imageGroup.count;
        if (imageGroup.count <= 1) {
            self.pageControl.hidden = YES;
        }
        [self addBannerTimer];
    }
}


#pragma mark : UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    return self.imageGroup.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
         HomeSingleImageCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCell" forIndexPath:indexPath];
        NSString *path = self.imageGroup[indexPath.row];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.actionBlock) {
        self.actionBlock(indexPath.row);
    }
 }

#pragma mark : UIScrollViewDelegate
//手指拖动开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeBannerTimer];
    self.dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self addBannerTimer];
}

//配置cell居中
-(void)fixCellToCenter
{
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/50.0f;
    if (self.dragStartX - self.dragEndX >= dragMiniDistance) {
        self.currentIndex -= 1;//向右
    }else if(self.dragEndX - self.dragStartX >= dragMiniDistance){
        self.currentIndex += 1;//向左
    }
    
    NSInteger maxIndex = [self.bannerView numberOfItemsInSection:0] - 1;
    self.currentIndex = _currentIndex <= 0 ? 0 : self.currentIndex;
    //    self.currentIndex = _currentIndex >= maxIndex ? maxIndex : self.currentIndex;
    if (self.currentIndex > maxIndex) {
        self.currentIndex = 0;
    }
    
    [self.bannerView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    self.pageControl.currentPage = self.currentIndex;
}


#pragma mark : 事件处理

- (void)addBannerTimer{
    
    [self.timer  invalidate];
    self.timer  = nil;
    if (!self.timer && self.imageGroup.count > 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(caseBannerTimer) userInfo:nil repeats:YES];
    }
}

- (void)removeBannerTimer{
    
    [self.timer  invalidate];
    self.timer  = nil;
}

- (void)caseBannerTimer{
    
    self.dragStartX = self.bannerView.mj_offsetX;
    self.dragEndX = (self.bannerView.mj_offsetX + 50);
    [self fixCellToCenter];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat page_x  = 20;
    CGFloat page_h  = 10;
    CGFloat page_y  = self.bannerView.mj_h + 5;
    CGFloat page_w  = self.imageGroup.count * 16;
    self.pageControl.frame = CGRectMake(page_x, page_y, page_w, page_h);
}


@end
