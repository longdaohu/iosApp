//
//  OneGroupView.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "UniGroupOneView.h"
#import "HomeSectionHeaderView.h"
#import "UniversityOneGroupCollectionCell.h"
#import "HomeSectionHeaderView.h"
#import "UUChart.h"
#import "UniversityNewFrame.h"

@interface UniGroupOneView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UUChartDataSource>
@property(nonatomic,strong)UICollectionViewFlowLayout *flowlayout;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HomeSectionHeaderView *fenguanView;
@property(nonatomic,strong)UIView *lineOne;
@property(nonatomic,strong)HomeSectionHeaderView *keyView;
@property(nonatomic,strong)UIView *keySubjectView;
@property(nonatomic,strong)UIView *lineTwo;
@property(nonatomic,strong)HomeSectionHeaderView *rankView;
@property(nonatomic,strong)UIView *selectionView;
@property(nonatomic,strong)UIView *historyLine;
@property(nonatomic,strong)UIButton *qsBtn;
@property(nonatomic,strong)UIButton *timesBtn;
@property(nonatomic,strong)UILabel *chartAlertLab;
@property(nonatomic,strong)UUChart *chartView;
@property(nonatomic,strong)NSArray *years;
@property(nonatomic,strong)NSArray *ranks;
@end

@implementation UniGroupOneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
        
    }
    return self;
}

- (void)makeUI{
    
    HomeSectionHeaderView *fenguanView = [HomeSectionHeaderView sectionHeaderViewWithTitle:@"校园风光"];
    fenguanView.backgroundColor = XCOLOR_WHITE;
    self.fenguanView = fenguanView;
    [self addSubview:fenguanView];
    
    [self makeCollectView];
    
    
    UIView *lineOne = [[UIView alloc] init];
    self.lineOne = lineOne;
    lineOne.backgroundColor = XCOLOR_BG;
    [self addSubview:lineOne];
    
    HomeSectionHeaderView *keyView = [HomeSectionHeaderView sectionHeaderViewWithTitle:@"王牌领域"];
    keyView.backgroundColor = XCOLOR_WHITE;
    self.keyView = keyView;
    [self addSubview:keyView];
    
    //王牌标签 array
    UIView *keySubjectView = [[UIView alloc] init];
    self.keySubjectView = keySubjectView;
    [self addSubview:keySubjectView];
    
    //分隔线
    UIView *lineTwo = [[UIView alloc] init];
    self.lineTwo = lineTwo;
    lineTwo.backgroundColor = XCOLOR_line;
    [self addSubview:lineTwo];
    
    
    HomeSectionHeaderView *rankView = [HomeSectionHeaderView sectionHeaderViewWithTitle:@"历史排名"];
    rankView.backgroundColor = XCOLOR_WHITE;
    self.rankView = rankView;
    [self addSubview:rankView];
    
    
    UIView *selectionView = [[UIView alloc] init];
    [self addSubview:selectionView];
    self.selectionView = selectionView;
    

    UIView *historyLine = [[UIView alloc] init];
    historyLine.backgroundColor = XCOLOR_BG;
    [selectionView addSubview:historyLine];
    self.historyLine = historyLine;


    UIButton *qsBtn = [[UIButton alloc] init];
    
    [qsBtn setTitle:@"世界排名" forState:UIControlStateNormal];
    qsBtn.enabled = NO;
    [qsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [qsBtn setTitleColor:XCOLOR_RED forState:UIControlStateDisabled];
    [selectionView addSubview:qsBtn];
    qsBtn.titleLabel.font = XFONT(16);
    self.qsBtn = qsBtn;
    [self.qsBtn addTarget:self action:@selector(qsClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *timesBtn = [[UIButton alloc] init];
    [timesBtn setTitle:@"本国排名" forState:UIControlStateNormal];
    [timesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [timesBtn setTitleColor:XCOLOR_RED forState:UIControlStateDisabled];
    [selectionView addSubview:timesBtn];
    self.timesBtn = timesBtn;
    timesBtn.titleLabel.font = XFONT(16);
    [self.timesBtn addTarget:self action:@selector(timesClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *alertLab = [UILabel labelWithFontsize:20 TextColor:XCOLOR_LIGHTBLUE TextAlignment:NSTextAlignmentCenter];
    alertLab.text = @"暂无排名";
    self.chartAlertLab = alertLab;
    [self addSubview:alertLab];
    
}


-(void)makeCollectView
{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowlayout = flowlayout;
    // 设置每一个cell的宽高 (cell在CollectionView中称之为item)
    CGFloat width = 100 * XPERCENT;
    CGFloat heigh = 100 * XPERCENT;
    
    flowlayout.itemSize = CGSizeMake(width,heigh);
    // 设置item行与行之间的间隙
    //    flowlayout.minimumLineSpacing = 0;
    // 设置item列与列之间的间隙
    //    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, XMARGIN, 0, XMARGIN);//sectionInset的设置与item的宽高不一致会出现警报信息
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, heigh) collectionViewLayout:flowlayout];
    collectionView.backgroundColor  = [UIColor whiteColor];
    
    
    self.collectionView                           = collectionView;
    collectionView.showsVerticalScrollIndicator   = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource                     = self;
    collectionView.delegate                       = self;
    collectionView.backgroundColor                = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UniversityOneGroupCollectionCell class] forCellWithReuseIdentifier:oneIdentify];
    
    [self  addSubview:self.collectionView];
    
}


-(void)setContentFrame:(UniversityNewFrame *)contentFrame{

    _contentFrame = contentFrame;
    
    self.fenguanView.frame = contentFrame.fenguanFrame;
    
    self.collectionView.frame = contentFrame.collectionViewFrame;
    
    [self.collectionView reloadData];

    self.lineOne.frame = contentFrame.lineOneFrame;
    
    self.keyView.frame = contentFrame.keyFrame;
    
    self.keySubjectView.frame = contentFrame.subjectBgFrame;
    
    self.lineTwo.frame = contentFrame.lineTwoFrame;
    
    self.rankView.frame = contentFrame.rankFrame;
    
    self.selectionView.frame = contentFrame.selectionFrame;
    
    self.historyLine.frame = contentFrame.historyLineFrame;
    
    self.qsBtn.frame = contentFrame.qsFrame;
    
    self.timesBtn.frame = contentFrame.timesFrame;
    
    
    UIFont *sender_Font = XFONT(XFONT_SIZE(14));
    
    for (NSString *title in contentFrame.item.key_subjectArea) {
        
        UIButton *sender  =  [[UIButton alloc] init];
        
        [self.keySubjectView addSubview:sender];
        
        [sender setTitle:title forState:UIControlStateNormal];
        
        [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        
         sender.titleLabel.font = sender_Font;
        
         sender.layer.cornerRadius = 15;
        
         sender.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
        
         sender.layer.borderWidth = 1;
    }
    
    
    for (NSInteger index = 0; index < contentFrame.subjectItemFrames.count; index++) {
        
        UIButton *sender = (UIButton *)self.keySubjectView.subviews[index];
        
         NSValue *xvalue =  contentFrame.subjectItemFrames[index];
        
        sender.frame  =  xvalue.CGRectValue;
    }
    
     self.chartAlertLab.frame = contentFrame.chartViewBgFrame;
    
    [self chartWithArray:self.contentFrame.item.global_rank_history];
    
}


-(void)chartWithArray:(NSArray *)temps_history{

    
    self.chartAlertLab.hidden = temps_history.count > 0;
    self.chartView.hidden = temps_history.count == 0;
    
    if (temps_history.count == 0) {
        
        return;
    }
    
    NSMutableArray *years = [NSMutableArray array];
    
    NSMutableArray *ranks = [NSMutableArray array];
    
    [temps_history enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [years addObject: [NSString stringWithFormat:@"%@",[obj valueForKey:@"year"]]];
        [ranks addObject: [NSString stringWithFormat:@"%@",[obj valueForKey:@"rank"]]];
        
    }];
    
    self.ranks = [ranks copy];
    self.years = [years copy];
    
    [self configChartUI];
}

- (void)qsClick:(UIButton *)sender{

    self.qsBtn.enabled = NO;
    self.timesBtn.enabled = YES;
    [self chartWithArray:self.contentFrame.item.global_rank_history];
}

- (void)timesClick:(UIButton *)sender{
    
    self.qsBtn.enabled = YES;
    self.timesBtn.enabled = NO;
    
    [self chartWithArray:self.contentFrame.item.local_rank_history];
    
}

- (void)configChartUI
{
    
    if (self.chartView) {
        
        [self.chartView removeFromSuperview];
        
        self.chartView = nil;
    }
    
    self.chartView = [[UUChart alloc]initWithFrame:self.contentFrame.chartViewBgFrame
                                        dataSource:self
                                             style:UUChartStyleLine];
    [self.chartView showInView:self];
    
}


#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    return self.years;
}

//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    return  @[self.ranks];
}
#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[XCOLOR_LIGHTBLUE];
}

//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    
    NSInteger max = [self.ranks[0] integerValue];
    
    NSInteger min = [self.ranks[0] integerValue];
    
    
    for (NSInteger i = 0 ; i < self.ranks.count; i++) {
        
        NSString *item = self.ranks[i];
        
        if (max < item.integerValue) max = item.integerValue;
        
        if (min > item.integerValue) min = item.integerValue;
        
    }
    
    //数值要均匀显示才可以正确的点上
    min -= 1;
    
    if (min <= 1 )  min = 0;
    
    if (min > 100) min -= 20;
    
    if (max - min < 4) max = min + 4;
    
    if ((max - min) % 4 ) max =  max - (max - min) % 4 + 4;
    
    return CGRangeMake(min,max);
    
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    
    return YES;
}



#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    UniversitydetailNew *uni = _contentFrame.item;
    
    return  uni.m_images.count;
}

static NSString *oneIdentify = @"oneGroup";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityOneGroupCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneIdentify forIndexPath:indexPath];
    
    UniversitydetailNew *uni = _contentFrame.item;
    
    cell.path = uni.m_images[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if(self.actionBlock)
    {
        self.actionBlock(nil,indexPath.row);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}






@end
