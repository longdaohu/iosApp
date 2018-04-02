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
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HomeSectionHeaderView *sceneryView;
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
    
    //校园风光
    HomeSectionHeaderView *sceneryView = [HomeSectionHeaderView sectionHeaderViewWithTitle:@"校园风光"];
    sceneryView.backgroundColor = XCOLOR_WHITE;
    self.sceneryView = sceneryView;
    [self addSubview:sceneryView];
    
    //图片CollectionView
    [self makeCollectView];
    
    //分隔线
    UIView *lineOne = [[UIView alloc] init];
    self.lineOne = lineOne;
    lineOne.backgroundColor = XCOLOR_line;
    [self addSubview:lineOne];
    
    //王牌领域
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
    
    //历史排名
    HomeSectionHeaderView *rankView = [HomeSectionHeaderView sectionHeaderViewWithTitle:@"历史排名"];
    rankView.backgroundColor = XCOLOR_WHITE;
    self.rankView = rankView;
    [self addSubview:rankView];
    
    //选择项 世界、本国排名
    UIView *selectionView = [[UIView alloc] init];
    [self addSubview:selectionView];
    self.selectionView = selectionView;
    
   //分隔线
    UIView *historyLine = [[UIView alloc] init];
    historyLine.backgroundColor = XCOLOR_line;
    [selectionView addSubview:historyLine];
    self.historyLine = historyLine;


    UIButton *qsBtn = [[UIButton alloc] init];
    [qsBtn setTitle:@"世界排名" forState:UIControlStateNormal];
    qsBtn.enabled = NO;
    [qsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [qsBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
    [selectionView addSubview:qsBtn];
    qsBtn.titleLabel.font = XFONT(16);
    self.qsBtn = qsBtn;
    [self.qsBtn addTarget:self action:@selector(qsClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *timesBtn = [[UIButton alloc] init];
    [timesBtn setTitle:@"本国排名" forState:UIControlStateNormal];
    [timesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [timesBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
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
    CGFloat width = 100 * XPERCENT;
    CGFloat heigh = 100 * XPERCENT;
    flowlayout.itemSize = CGSizeMake(width,heigh);
    flowlayout.sectionInset = UIEdgeInsetsMake(0, XMARGIN, 0, XMARGIN);//sectionInset的设置与item的宽高不一致会出现警报信息
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, heigh) collectionViewLayout:flowlayout];
    collectionView.backgroundColor  = [UIColor whiteColor];
    
    
    self.collectionView   = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource  = self;
    collectionView.delegate  = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UniversityOneGroupCollectionCell class] forCellWithReuseIdentifier:oneIdentify];
    
    [self  addSubview:self.collectionView];
    
}


-(void)setContentFrame:(UniversityNewFrame *)contentFrame{

    _contentFrame = contentFrame;
    
    self.sceneryView.frame = contentFrame.fenguan_Frame;
    
    self.collectionView.frame = contentFrame.collectionView_Frame;
    [self.collectionView reloadData];
 
    self.lineOne.frame = contentFrame.fg_line_Frame;
    self.keyView.frame = contentFrame.key_Frame;
    self.keySubjectView.frame = contentFrame.subject_Bg_Frame;
    self.lineTwo.frame = contentFrame.key_line_Frame;
    self.rankView.frame = contentFrame.rank_Frame;
    self.selectionView.frame = contentFrame.selection_Frame;
    self.historyLine.frame = contentFrame.history_Line_Frame;
    self.qsBtn.frame = contentFrame.qs_Frame;
    self.timesBtn.frame = contentFrame.times_Frame;
    [self subjectsWithUniversity:contentFrame];
    self.chartAlertLab.frame = contentFrame.chart_Bg_Frame;
    
    [self chartWithItems:self.contentFrame.uni.global_rank_history];
    
}

//添加大学专业
- (void)subjectsWithUniversity:(UniversityNewFrame *)contentFrame{

    UIFont *sender_Font = XFONT(XFONT_SIZE(14));
    
    for (NSString *title in contentFrame.uni.key_subjectArea) {
        
        UIButton *sender  =  [[UIButton alloc] init];
        [sender setTitle:title forState:UIControlStateNormal];
        [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
        sender.titleLabel.font = sender_Font;
        sender.layer.cornerRadius = 15;
        sender.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
        sender.layer.borderWidth = 1;
        [self.keySubjectView addSubview:sender];
    
    }
    
    for (NSInteger index = 0; index < contentFrame.subjectItemFrames.count; index++) {
        
        UIButton *sender = (UIButton *)self.keySubjectView.subviews[index];
        NSValue *xvalue =  contentFrame.subjectItemFrames[index];
        sender.frame  =  xvalue.CGRectValue;
    }
}


-(void)chartWithItems:(NSArray *)history_rank{

    self.chartAlertLab.hidden = history_rank.count > 0;
    self.chartView.hidden = history_rank.count == 0;
    if (history_rank.count == 0) return;
    
    self.ranks = [history_rank valueForKey:@"rank"];
    self.years = [history_rank valueForKey:@"year"];
    
    [self updateChartUI];
}

- (void)qsClick:(UIButton *)sender{

    self.qsBtn.enabled = NO;
    self.timesBtn.enabled = YES;
    [self chartWithItems:self.contentFrame.uni.global_rank_history];
}

- (void)timesClick:(UIButton *)sender{
    
    self.qsBtn.enabled = YES;
    self.timesBtn.enabled = NO;
    
    [self chartWithItems:self.contentFrame.uni.local_rank_history];
    
}

- (void)updateChartUI{
    
    if (self.chartView) {
        [self.chartView removeFromSuperview];
        self.chartView = nil;
    }
    self.chartView = [[UUChart alloc]initWithFrame:self.contentFrame.chart_Bg_Frame
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


#pragma mark : UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    UniversitydetailNew *uni = _contentFrame.uni;
    
    return  uni.m_images.count;
}

static NSString *oneIdentify = @"oneGroup";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityOneGroupCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneIdentify forIndexPath:indexPath];
    UniversitydetailNew *uni = _contentFrame.uni;
    cell.path = uni.m_images[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(self.actionBlock) self.actionBlock(nil,indexPath.row);
    
}


- (void)dealloc{
    
    KDClassLog(@" 学校详情  UniGroupOneView dealloc OK");
    
}


@end
