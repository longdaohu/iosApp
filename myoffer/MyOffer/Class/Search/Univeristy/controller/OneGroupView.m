//
//  OneGroupView.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "OneGroupView.h"
#import "HomeSectionHeaderView.h"
#import "UniversityOneGroupCollectionCell.h"
#import "HomeSectionHeaderView.h"

@interface OneGroupView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
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
@property(nonatomic,strong)UIView *chartBgView;



@end

@implementation OneGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)makeUI{

    
    HomeSectionHeaderView *fenguanView = [[HomeSectionHeaderView alloc] init];
    fenguanView.TitleLab.text = @"校园风光";
    self.fenguanView = fenguanView;
    [self addSubview:fenguanView];
    
    [self makeCollectView];
    
    
    UIView *lineOne = [[UIView alloc] init];
    self.lineOne = lineOne;
    lineOne.backgroundColor =[UIColor lightGrayColor];
    [self addSubview:lineOne];
    
    HomeSectionHeaderView *keyView = [[HomeSectionHeaderView alloc] init];
    keyView.TitleLab.text = @"王牌领域";
    self.keyView = keyView;
    [self addSubview:keyView];
    
    UIView *keySubjectView = [[UIView alloc] init];
    self.keySubjectView = keySubjectView;
    [self addSubview:keySubjectView];

    UIView *lineTwo = [[UIView alloc] init];
    self.lineTwo = lineTwo;
    lineTwo.backgroundColor =[UIColor lightGrayColor];
    [self addSubview:lineTwo];
    
    HomeSectionHeaderView *rankView = [[HomeSectionHeaderView alloc] init];
    rankView.TitleLab.text = @"历史排名";
    self.rankView = rankView;
    [self addSubview:rankView];
    
    
    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor =[UIColor lightGrayColor];
    [self addSubview:selectionView];
    self.selectionView = selectionView;

    UIView *historyLine = [[UIView alloc] init];
    historyLine.backgroundColor =[UIColor blackColor];
    [selectionView addSubview:historyLine];
    self.historyLine = historyLine;


    UIButton *qsBtn = [[UIButton alloc] init];
    [qsBtn setTitle:@"QS世界排名" forState:UIControlStateNormal];
    [qsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qsBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [selectionView addSubview:qsBtn];
    qsBtn.titleLabel.font = XFONT(15);
    qsBtn.selected = YES;
    self.qsBtn = qsBtn;
    
    UIButton *timesBtn = [[UIButton alloc] init];
    [timesBtn setTitle:@"TIMES排名" forState:UIControlStateNormal];
    [timesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [timesBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [selectionView addSubview:timesBtn];
    self.timesBtn = timesBtn;
    timesBtn.titleLabel.font = XFONT(15);

    
    UIView *chartBgView = [[UIView alloc] init];
    chartBgView.backgroundColor =[UIColor orangeColor];
    [self addSubview:chartBgView];
    self.chartBgView = chartBgView;
    
    
}

-(void)makeCollectView
{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowlayout = flowlayout;
    // 设置每一个cell的宽高 (cell在CollectionView中称之为item)
    CGFloat width = 100 * XPERCENT;
    CGFloat heigh = width;
    
    flowlayout.itemSize = CGSizeMake(width,heigh);
    // 设置item行与行之间的间隙
    //    flowlayout.minimumLineSpacing = 0;
    // 设置item列与列之间的间隙
    //    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, XMARGIN, 0, XMARGIN);//sectionInset的设置与item的宽高不一致会出现警报信息
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, heigh) collectionViewLayout:flowlayout];
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
    
    self.chartBgView.frame = contentFrame.chartViewBgFrame;
    
    
    for (NSString *title in contentFrame.item.key_subjects) {
        
        UIButton *sender  =  [[UIButton alloc] init];
        [self.keySubjectView addSubview:sender];
        [sender setTitle:title forState:UIControlStateNormal];
        [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateNormal];
         sender.titleLabel.font = XFONT(XPERCENT * 14);
         sender.layer.cornerRadius = 0.5  * (14 * XPERCENT + XMARGIN  * 2);
         sender.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
         sender.layer.borderWidth = 1;
        [sender addTarget:self action:@selector(subjectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (NSInteger index = 0; index < contentFrame.subjectItemFrames.count; index++) {
        
        UIButton *sender = (UIButton *)self.keySubjectView.subviews[index];
        
         NSValue *xvalue =  contentFrame.subjectItemFrames[index];
        
        sender.frame  =  xvalue.CGRectValue;
    }
 
    
    
}



#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    UniversitydetailNew *uni = _contentFrame.item;
    
    return  uni.images.count;
}

static NSString *oneIdentify = @"oneGroup";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityOneGroupCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneIdentify forIndexPath:indexPath];
    
    UniversitydetailNew *uni = _contentFrame.item;
    
    cell.path = uni.images[indexPath.row];
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


- (void)subjectClick:(UIButton *)sender{

    NSLog(@"currentTitle %@",sender.currentTitle);
}





@end
