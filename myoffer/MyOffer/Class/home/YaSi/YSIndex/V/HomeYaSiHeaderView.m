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
@property(nonatomic,strong)UIView *activeView;
@property(nonatomic,strong)UIView *line_catigory; //分割线
@property(nonatomic,strong)UIView *catigory_box_line; //分割线
@property(nonatomic,strong)PriceCellView *priceCell;
@property(nonatomic,strong)NSArray *catigory_buttones; //分类按钮数组，预添加，减少临时
@property(nonatomic,strong)UIImageView *bgImageView; //背景图片
@property(nonatomic,strong) SDCycleScrollView *titleBanner;

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
    
    self.backgroundColor = XCOLOR(0, 22, 34, 1);
    
    UIImageView *bgView = [UIImageView new];
    bgView.image = XImage(@"ys_header_bg");
    [self addSubview:bgView];
    self.bgImageView = bgView;
    
    UIButton *ysBtn = [UIButton new];
    [ysBtn setBackgroundImage:XImage(@"ys_header_test") forState:UIControlStateNormal];
    ysBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    ysBtn.titleLabel.numberOfLines = 0;
    [ysBtn setTitle:@"雅思\n评测" forState:UIControlStateNormal];
    [ysBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
    [self addSubview:ysBtn];
    self.YS_Test_Btn = ysBtn;
    [ysBtn addTarget:self action:@selector(caseLogo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signedBtn = [UIButton new];
    signedBtn.titleLabel.font = XFONT(12);
    signedBtn.layer.cornerRadius = 2;
    signedBtn.layer.borderWidth = 1;
    signedBtn.layer.borderColor = XCOLOR_WHITE.CGColor;
    signedBtn.backgroundColor = XCOLOR_WHITE;
    [self addSubview:signedBtn];
    self.signedBtn = signedBtn;
    [signedBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signedBtn setTitle:@"已签到" forState:UIControlStateDisabled];
    [signedBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    [signedBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
    [signedBtn addTarget:self action:@selector(caseSigned:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *signTitleLab = [UILabel new];
    signTitleLab.font = XFONT(12);
    signTitleLab.textColor = XCOLOR_WHITE;
    self.signTitleLab = signTitleLab;
    [self addSubview:signTitleLab];
    
    UIButton *live_bg = [UIButton new];
    [self addSubview:live_bg];
    self.live_bg = live_bg;
    live_bg.titleLabel.font = XFONT(14);
    live_bg.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    live_bg.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [live_bg setBackgroundImage:XImage(@"ys_heike_live_bg") forState:UIControlStateNormal];
    [live_bg setTitle:@"今天没有新课程，复习一下学完的课程吧" forState:UIControlStateNormal];
    [live_bg setTitle:@" " forState:UIControlStateDisabled];
    [live_bg addTarget:self action:@selector(caseToLiving) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleBanner = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
    [self  addSubview:self.titleBanner];
    self.titleBanner.onlyDisplayText = YES;
    self.titleBanner.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.titleBanner.autoScroll = YES;
    self.titleBanner.titleLabelTextAlignment =  NSTextAlignmentLeft;
    self.titleBanner.titleLabelBackgroundColor = XCOLOR_CLEAR;
    [self.titleBanner disableScrollGesture];
    WeakSelf
    self.titleBanner.clickItemOperationBlock = ^(NSInteger index) {
        [weakSelf caseToLiving];
    };

    UIImageView *clockBtn = [UIImageView new];
    [self addSubview:clockBtn];
    self.clockBtn = clockBtn;
    clockBtn.image = XImage(@"ys_heike_logo");
    
    UIView *banner_box = [UIView new];
    [self addSubview:banner_box];
    self.banner_box = banner_box;
 
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
    
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.currentPageIndicatorTintColor = XCOLOR_LIGHTBLUE;
    [banner_box addSubview:pageControl];
    self.pageControl = pageControl;
    
    UIView *catigory_box = [UIView new];
    [self addSubview:catigory_box];
    self.catigory_box = catigory_box;
    
    UIView *line_catigory = [UIView new];
    line_catigory.backgroundColor = XCOLOR(239, 242, 245, 0.15);
    [catigory_box addSubview:line_catigory];
    self.line_catigory = line_catigory;
    
    UIView *activeView = [UIView new];
    activeView.backgroundColor = XCOLOR_LIGHTBLUE;
    [catigory_box addSubview:activeView];
    self.activeView = activeView;
    activeView.layer.cornerRadius = 1;
    
    UICollectionViewFlowLayout *flow_cg = [[UICollectionViewFlowLayout alloc] init];
    flow_cg.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    flow_cg.minimumLineSpacing = 10;
    flow_cg.minimumInteritemSpacing = 10;
    flow_cg.itemSize = CGSizeMake(135, 90);
    UICollectionView *catigoryView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow_cg];
    [catigoryView registerNib:[UINib nibWithNibName:NSStringFromClass([YsCatigoryItemCell class] ) bundle:nil] forCellWithReuseIdentifier:@"YsCatigoryItemCell"];
    self.catigoryView = catigoryView;
    catigoryView.backgroundColor = XCOLOR_CLEAR;
    catigoryView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    catigoryView.dataSource = self;
    catigoryView.delegate = self;
    [catigory_box addSubview:catigoryView];
    catigory_box.clipsToBounds = YES;
    
    UIView *catigory_box_line  = [UIView new];
    catigory_box_line.backgroundColor = XCOLOR(239, 242, 245, 0.15);
    [catigory_box addSubview:catigory_box_line];
    self.catigory_box_line = catigory_box_line;
    
    PriceCellView *priceCell = Bundle(@"PriceCellView");
    priceCell.backgroundColor = XCOLOR_CLEAR;
    self.priceCell = priceCell;
    [catigory_box addSubview:priceCell];
    
    priceCell.actionBlock = ^{
        [weakSelf caseBuy];
    };
    
    NSMutableArray *btn_tmp = [NSMutableArray array];
    for (NSInteger index = 0; index < 5; index++) {
        
        UIButton *sender = [UIButton new];
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [sender setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
        [sender setTitleColor:XCOLOR_WHITE forState:UIControlStateDisabled];
        [sender addTarget:self action:@selector(catigoryChange:) forControlEvents:UIControlEventTouchUpInside];
        sender.tag = index;
        [btn_tmp addObject:sender];
        [catigory_box addSubview:sender];
    }
    
    self.catigory_buttones = btn_tmp;
}


- (void)setScore_signed:(NSString *)score_signed{
    _score_signed = score_signed;

    if (score_signed.integerValue > 0) {
        
        self.signedBtn.backgroundColor = XCOLOR_CLEAR;
        self.signedBtn.enabled = NO;
        self.signTitleLab.text = [NSString stringWithFormat:@"签到获得%@个U币",score_signed];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.signTitleLab.text];
        [attr addAttribute:NSForegroundColorAttributeName value:XCOLOR_LIGHTBLUE  range: NSMakeRange (4,score_signed.length)];
        self.signTitleLab.attributedText = attr;
        
    }else{
        
        self.signedBtn.backgroundColor = XCOLOR_WHITE;
        self.signTitleLab.text = @"";
        self.signedBtn.enabled = YES;
    }
    
}

- (void)setYsModel:(YaSiHomeModel *)ysModel{
    
    _ysModel = ysModel;
    
    
    self.YS_Test_Btn.frame = ysModel.ysBtn_frame;
    self.signedBtn.frame = ysModel.signedBtn_frame;
    self.signTitleLab.frame = ysModel.signTitle_frame;
    self.clockBtn.frame = ysModel.clockBtn_frame;
    self.live_bg.frame = ysModel.livingBtn_frame;
    self.line_catigory.frame = ysModel.line_banner_frame;
    self.catigory_box.frame = ysModel.catigory_box_frame;
    self.pageControl.frame = ysModel.banner_pageControl_frame;
    self.activeView.frame = ysModel.cati_active_frame;
    self.catigoryView.frame = ysModel.catigory_collectView_frame;
    self.priceCell.frame = ysModel.price_cell_frame;
    self.catigory_box_line.frame = ysModel.cati_clct_bottom_line_frame;
    self.titleBanner.frame = ysModel.living_box_frame;
    self.bannerView.frame = ysModel.bannerView_frame;
    self.flow_banner.itemSize = ysModel.header_banner_size;
    self.banner_box.frame = ysModel.banner_box_frame;
    
    if (ysModel.coin > 0) {
        self.score_signed = [NSString stringWithFormat:@"%ld",ysModel.coin];
    }else{
        self.score_signed = nil;
    }
    if (ysModel.living_items_loaded) {
        self.titleBanner.hidden = NO;
        self.live_bg.enabled = NO;
        self.titleBanner.titlesGroup = ysModel.living_titles;
    }else{
        self.live_bg.enabled = YES;
        self.titleBanner.hidden = YES;
    }

    NSInteger celles_count = [self.catigoryView numberOfItemsInSection:0];
    if (celles_count > 0) {
        return;
    }
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
    
    if (self.ysModel.catigory_current) {
        [self catigoryChange:self.catigory_buttones[0]];
    }
    
    if (ysModel.banner_images.count > 0) {
        [self.bannerView reloadData];
         self.pageControl.numberOfPages = ysModel.banner_images.count;
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
        
        self.ysModel.catigoryPackage_item_selected_index = indexPath.row;
        [collectionView reloadData];
        self.priceCell.item = self.ysModel.catigory_Package_current;
        [self caseValueChange];
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

- (void)caseValueChange{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeValueChange);
    }
}

- (void)caseBanner:(NSString *)path{
    
    if (self.actionBlock) {
        self.ysModel.banner_target = path;
        self.actionBlock(YSHomeHeaderActionTypeBanner);
    }
}

- (void)caseBuy{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeBuy);
    }
}

- (void)caseLogo:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeTest);
    }
}

- (void)caseSigned:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeSigned);
    }
}

- (void)caseToLiving{
    
    if (self.actionBlock) {
        self.actionBlock(YSHomeHeaderActionTypeLiving);
    }
}

- (void)catigoryChange:(UIButton *)sender{
    
    for (UIButton *item in self.catigory_buttones) {
        item.enabled = true;
    }
    sender.enabled = NO;
    CGRect rect = self.activeView.frame;
    rect.origin.x = sender.mj_x;
    rect.size.width = sender.mj_w;
    [UIView animateWithDuration:0.25 animations:^{
        self.activeView.frame = rect;
    }];
    
    self.ysModel.catigory_title_selected_index = sender.tag;
    self.ysModel.catigoryPackage_item_selected_index = 0;
    [self.catigoryView reloadData];
    
    self.priceCell.item = self.ysModel.catigory_Package_current;
    [self caseValueChange];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat item_w =  self.bounds.size.width;
    CGFloat item_h = item_w  * 229 / 375;
    self.bgImageView.frame = CGRectMake(0, 0, item_w, item_h);
}

- (void)userLoginChange{
    
    
    if (!LOGIN){
        
        self.signedBtn.enabled = YES;
        self.signedBtn.backgroundColor = XCOLOR_WHITE;
        self.score_signed = nil;
    }
    
}


@end
