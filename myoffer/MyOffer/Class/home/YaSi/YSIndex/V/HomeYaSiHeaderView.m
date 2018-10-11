//
//  HomeYaSiHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYaSiHeaderView.h"
#import "YaSiHomeModel.h"
#import "YasiBannerLayout.h"
#import "YSScheduleModel.h"
#import "PriceCellView.h"
#import "YasiCatigoryItemModel.h"
#import "YasiCatigoryModel.h"
#import "HomeSingleImageCell.h"
#import "YsCatigoryItemCell.h"
#import "SDCycleScrollView.h"

@interface HomeYaSiHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)UIButton *YS_Test_Btn; //雅思测评
@property(nonatomic,strong)UIButton *signedBtn;//签到
@property(nonatomic,strong)UILabel *signTitleLab;//签到提示
@property(nonatomic,strong)UIImageView *clockBtn;//之前是一个闹钟的LOGO
@property(nonatomic,strong)UIButton *live_bg; //直播课按钮

@property(nonatomic,strong)UIView *banner_box;//轮播图盒子
@property(nonatomic,strong)UICollectionViewFlowLayout *flow_banner;
@property(nonatomic,assign)CGFloat dragStartX;
@property(nonatomic,assign)CGFloat dragEndX;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)UICollectionView *bannerView;//轮播图
@property(nonatomic,strong)NSTimer *banner_timer;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIView *catigory_box;//分类盒子
@property(nonatomic,strong)UICollectionView *catigoryView;//分类详情
@property(nonatomic,strong)UIView *shadow_box; //阴影盒子
@property(nonatomic,strong)UIView *cover_shadow; //分割线
@property(nonatomic,strong)UIView *catigory_box_line; //分割线
@property(nonatomic,strong)CAShapeLayer *shaper;
@property(nonatomic,strong)PriceCellView *priceCell;
@property(nonatomic,strong)NSArray *catigory_buttones; //分类按钮数组，预添加，减少临时
@property(nonatomic,strong)UIImageView *bgImageView; //背景图片
@property(nonatomic,strong) SDCycleScrollView *titleBanner;//文字轮播

@end

@implementation HomeYaSiHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    
    self.backgroundColor = XCOLOR_WHITE;
    //背景图
    UIImageView *bgView = [UIImageView new];
    bgView.image = XImage(@"ys_header_bg");
    [self addSubview:bgView];
    self.bgImageView = bgView;
    
    //雅思测评
    UIButton *ysBtn = [UIButton new];
    [ysBtn setBackgroundImage:XImage(@"ys_header_test") forState:UIControlStateNormal];
    ysBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    ysBtn.titleLabel.numberOfLines = 0;
    [self addSubview:ysBtn];
    self.YS_Test_Btn = ysBtn;
    [ysBtn addTarget:self action:@selector(caseLogo:) forControlEvents:UIControlEventTouchUpInside];
    
    //签到
    UIButton *signedBtn = [UIButton new];
    signedBtn.titleLabel.font = XFONT(12);
    signedBtn.layer.cornerRadius = 2;
    signedBtn.layer.borderWidth = 1;
    signedBtn.layer.borderColor = XCOLOR_WHITE.CGColor;
    signedBtn.backgroundColor = XCOLOR_WHITE;
    [self addSubview:signedBtn];
    [signedBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signedBtn setTitle:@"已签到" forState:UIControlStateDisabled];
    [signedBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    [signedBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
    [signedBtn addTarget:self action:@selector(caseSigned:) forControlEvents:UIControlEventTouchUpInside];
    self.signedBtn = signedBtn;

    //签到提示信息
    UILabel *signTitleLab = [UILabel new];
    signTitleLab.font = XFONT(12);
    signTitleLab.textColor = XCOLOR_WHITE;
    [self addSubview:signTitleLab];
    self.signTitleLab = signTitleLab;

    //文字直播背景
    UIButton *live_bg = [UIButton new];
    [self addSubview:live_bg];
    [live_bg setBackgroundImage:XImage(@"ys_heike_live_bg") forState:UIControlStateNormal];
    self.live_bg = live_bg;

    //文字直播
    SDCycleScrollView *titleBanner = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
    [self  addSubview:titleBanner];
    titleBanner.onlyDisplayText = YES;
    titleBanner.scrollDirection = UICollectionViewScrollDirectionVertical;
    titleBanner.titleLabelTextAlignment =  NSTextAlignmentLeft;
    titleBanner.titleLabelBackgroundColor = XCOLOR_CLEAR;
    [titleBanner disableScrollGesture];
    self.titleBanner = titleBanner;
    WeakSelf
    titleBanner.clickItemOperationBlock = ^(NSInteger index) {
        [weakSelf caseToLiving];
    };

    //嘿客LOGO
    UIImageView *clockBtn = [UIImageView new];
    clockBtn.image = XImage(@"ys_heike_logo");
    [self addSubview:clockBtn];
    self.clockBtn = clockBtn;
    
    //轮播图盒子
    UIView *banner_box = [UIView new];
    [self addSubview:banner_box];
    self.banner_box = banner_box;
 
     //轮播图
    YasiBannerLayout *flow = [[YasiBannerLayout alloc] init];
    self.flow_banner = flow;
    UICollectionView *bannerView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    bannerView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [banner_box addSubview:bannerView];
    self.bannerView = bannerView;
    bannerView.backgroundColor = XCOLOR_CLEAR;
    bannerView.delegate = self;
    bannerView.dataSource = self;
    [bannerView registerClass:[HomeSingleImageCell class] forCellWithReuseIdentifier:@"bannerCell"];
    if (@available(iOS 11.0, *)) {
        bannerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
     //轮播图 pageControl
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.currentPageIndicatorTintColor = XCOLOR_LIGHTBLUE;
    [banner_box addSubview:pageControl];
    self.pageControl = pageControl;
    
    //分类产品盒子
    UIView *catigory_box = [UIView new];
    [self addSubview:catigory_box];
    self.catigory_box = catigory_box;

    //分类视图
    UICollectionViewFlowLayout *flow_cg = [[UICollectionViewFlowLayout alloc] init];
    flow_cg.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    flow_cg.minimumLineSpacing = 15;
    flow_cg.minimumInteritemSpacing = 15;
    flow_cg.itemSize = CGSizeMake(135, 90);
    UICollectionView *catigoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow_cg];
    [catigoryView registerNib:[UINib nibWithNibName:NSStringFromClass([YsCatigoryItemCell class] ) bundle:nil] forCellWithReuseIdentifier:@"YsCatigoryItemCell"];
    catigoryView.backgroundColor = XCOLOR(246, 246, 246, 1);
    catigoryView.contentInset = UIEdgeInsetsMake(15, 20, 0, 20);
    catigoryView.dataSource = self;
    catigoryView.delegate = self;
    [catigory_box addSubview:catigoryView];
    catigory_box.clipsToBounds = YES;
    self.catigoryView = catigoryView;
    
    //分类阴影
    UIView *shadow_box = [UIView new];
    [catigory_box addSubview:shadow_box];
    self.shadow_box = shadow_box;
    
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.fillColor = XCOLOR_WHITE.CGColor;
    shaper.lineWidth = 3;
    shaper.lineJoin = @"round";
    shaper.lineCap = @"round";
    shaper.shadowOffset = CGSizeMake(0, 0);
    shaper.shadowColor = XCOLOR_BLACK.CGColor;
    shaper.shadowOpacity = 0.15;
    [shadow_box.layer addSublayer:shaper];
    self.shaper = shaper;
    
    UIView *cover_shadow = [UIView new];
    cover_shadow.backgroundColor = XCOLOR_WHITE;
    [shadow_box addSubview:cover_shadow];
    self.cover_shadow = cover_shadow;
    
    //价格信息View
    PriceCellView *priceCell = Bundle(@"PriceCellView");
    [catigory_box addSubview:priceCell];
    self.priceCell = priceCell;
    priceCell.actionBlock = ^(BOOL isPay){
        isPay ?  [weakSelf caseBuy] :  [weakSelf caseToClass];
    };
    
    //分类分隔线
    UIView *catigory_box_line  = [UIView new];
    catigory_box_line.backgroundColor = XCOLOR(232, 232, 232, 1);
    [catigory_box addSubview:catigory_box_line];
    self.catigory_box_line = catigory_box_line;
    
    //分类标题
    NSMutableArray *btn_tmp = [NSMutableArray array];
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *sender = [UIButton new];
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [sender setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [sender setTitleColor:XCOLOR_BLACK forState:UIControlStateDisabled];
        [sender addTarget:self action:@selector(catigoryChange:) forControlEvents:UIControlEventTouchUpInside];
        sender.tag = index;
        [btn_tmp addObject:sender];
        [catigory_box addSubview:sender];
    }
    self.catigory_buttones = btn_tmp;
    
}

- (void)setYsModel:(YaSiHomeModel *)ysModel{
    
    _ysModel = ysModel;
    
    
    self.YS_Test_Btn.frame = ysModel.ysBtn_frame;
    self.signedBtn.frame = ysModel.signedBtn_frame;
    self.signTitleLab.frame = ysModel.signTitle_frame;
    self.clockBtn.frame = ysModel.clockBtn_frame;
    self.live_bg.frame = ysModel.livingBtn_frame;
    self.catigory_box.frame = ysModel.catigory_box_frame;
    self.pageControl.frame = ysModel.banner_pageControl_frame;
    self.catigoryView.frame = ysModel.catigory_collectView_frame;
    self.priceCell.frame = ysModel.price_cell_frame;
    self.catigory_box_line.frame = ysModel.cati_clct_bottom_line_frame;
    self.titleBanner.frame = ysModel.living_box_frame;
    self.bannerView.frame = ysModel.bannerView_frame;
    self.flow_banner.itemSize = ysModel.header_banner_size;
    self.banner_box.frame = ysModel.banner_box_frame;
 

    //设置用户U币
    [self userScore:ysModel.coin];
    
     //文字直播
     self.titleBanner.autoScroll = YES;
     self.titleBanner.titlesGroup = ysModel.living_titles;
 
    
    NSInteger celles_count = [self.catigoryView numberOfItemsInSection:0];
    //防止数据多次加载
    if (celles_count > 0) {
        if (self.priceCell.item) {
            self.priceCell.item = self.ysModel.catigory_Package_current;
        }
        return;
    }
    
    //商品数据
    for (NSInteger index = 0; index < ysModel.catigory_title_frames.count; index++) {
        
        if (index >= self.catigory_buttones.count) {
            break;
        }
        UIButton *sender = self.catigory_buttones[index];
        [sender setTitle:ysModel.catigory_titles[index] forState:UIControlStateNormal];
        NSValue *itemValue = ysModel.catigory_title_frames[index];
        sender.frame = itemValue.CGRectValue;
        if (index == ysModel.catigory_title_selected_index) {
            sender.enabled = NO;
        }
    }
 
    self.shadow_box.frame = ysModel.shadow_box_frame;
    self.cover_shadow.frame = self.shadow_box.bounds;
    self.cover_shadow.mj_y = -self.cover_shadow.mj_h;
    //设置商品子项
    if (self.ysModel.catigory_current) {
        [self catigoryChange:self.catigory_buttones[0]];
    }
    
    
    if (!CGRectIsEmpty(self.shadow_box.frame)) {
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = ysModel.shadow_box_frame.size.width;
        CGFloat h = ysModel.shadow_box_frame.size.height;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        UIBezierPath *path_a = [UIBezierPath bezierPath];
        CGFloat a_x = w * 0.5;
        [path_a moveToPoint:CGPointMake(a_x - 15, h)];
        [path_a addLineToPoint:CGPointMake(a_x, h - 15)];
        [path_a addLineToPoint:CGPointMake(a_x + 15, h)];
        [path appendPath:[path_a bezierPathByReversingPath]];
        self.shaper.path = path.CGPath;
    }
    
    //轮播图片
    if (ysModel.banner_images.count > 0) {
        [self.bannerView reloadData];
        self.pageControl.numberOfPages = ysModel.banner_images.count;
        if (ysModel.banner_images.count <= 1) {
            self.pageControl.hidden = YES;
        }
        [self addBannerTimer];
    }
    
}


#pragma mark : UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.bannerView) {
        return self.ysModel.banner_images.count;
    }
    
    return self.ysModel.catigory_current.servicePackage.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.bannerView) {
        
        HomeSingleImageCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"bannerCell" forIndexPath:indexPath];
        NSString *path = self.ysModel.banner_images[indexPath.row];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
        
        return cell;
    }
    
    YsCatigoryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YsCatigoryItemCell" forIndexPath:indexPath];
    YasiCatigoryItemModel *item = self.ysModel.catigory_current.servicePackage[indexPath.row];
    cell.cell_selected =  (self.ysModel.catigoryPackage_item_selected_index == indexPath.row);
    cell.item = item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.catigoryView) {
        
        if (self.ysModel.catigoryPackage_item_selected_index == indexPath.row) return;
        
        self.ysModel.catigoryPackage_item_selected_index = indexPath.row;
        [collectionView reloadData];
        self.priceCell.item = self.ysModel.catigory_Package_current;
        [self caseCatigoryValueChange];
    }else{
        
        NSString *path = self.ysModel.banner_targets[indexPath.row];
        [self caseBanner:path];
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
    
    [self.banner_timer  invalidate];
    self.banner_timer  = nil;
    if (!self.banner_timer && self.ysModel.banner_images.count > 0) {
        self.banner_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(caseBannerTimer) userInfo:nil repeats:YES];
    }
}

- (void)removeBannerTimer{
 
    [self.banner_timer  invalidate];
     self.banner_timer  = nil;
}

- (void)caseBannerTimer{
    
    self.dragStartX = self.bannerView.mj_offsetX;
    self.dragEndX = (self.bannerView.mj_offsetX + 50);
    [self fixCellToCenter];
}
//商品分类改变时调用
- (void)caseCatigoryValueChange{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeValueChange);
    }
}

//轮播图
- (void)caseBanner:(NSString *)path{
    
    if (self.actionBlock) {
        self.ysModel.banner_target = path;
        self.actionBlock(YSHomeHeaderActionTypeBanner);
    }
}
//购买商品
- (void)caseBuy{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeBuy);
    }
}

//雅思测评
- (void)caseLogo:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeTest);
    }
}

//签到
- (void)caseSigned:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeSigned);
    }
}

//文字滚动
- (void)caseToLiving{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeLiving);
    }
}

//去上课
- (void)caseToClass{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeClass);
    }
}

//分类标题点击
- (void)catigoryChange:(UIButton *)sender{
    
    for (UIButton *item in self.catigory_buttones) {
        item.enabled = true;
    }
    sender.enabled = NO;
 
    self.ysModel.catigory_title_selected_index = sender.tag;
    self.ysModel.catigoryPackage_item_selected_index = 0;
    [self.catigoryView reloadData];
    
    self.priceCell.item = self.ysModel.catigory_Package_current;
    [self caseCatigoryValueChange];
    
    
    CGPoint action_center = self.shadow_box.center;
    action_center.x = sender.center.x;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.shadow_box.center = action_center;
    }];
    
}

//改变登录状态
- (void)userLoginChange{
    
    self.titleBanner.autoScroll = YES;
    self.titleBanner.titlesGroup = self.ysModel.living_titles;
    
    if (!LOGIN){
        
        [self userScoreSingned];
        self.priceCell.item = self.ysModel.catigory_Package_current;

        return;
    }
}

//用户资料中得到U币
- (void)userScore:(NSString *)score{
    
    if (score && score.integerValue > 0) {
        self.signTitleLab.text = [NSString stringWithFormat:@"签到获得%@个U币",score];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.signTitleLab.text];
        [attr addAttribute:NSForegroundColorAttributeName value:XCOLOR_LIGHTBLUE  range: NSMakeRange (4,score.length)];
        self.signTitleLab.attributedText = attr;
    }else{
        self.signTitleLab.text = @"";
    }
    
    [self userScoreSingned];
}

//标识用户签到情况
- (void)userScoreSingned{
    
    if (self.ysModel.user_signed) {
        self.signedBtn.backgroundColor = XCOLOR_CLEAR;
        self.signedBtn.enabled = NO;
    }else{
        self.signedBtn.backgroundColor = XCOLOR_WHITE;
        self.signedBtn.enabled = YES;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat item_w =  self.bounds.size.width;
    CGFloat item_h = item_w  * 229 / 375;
    self.bgImageView.frame = CGRectMake(0, 0, item_w, item_h);
}

@end
