//
//  HomeYaSiHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYaSiHeaderView.h"
#import "YaSiHomeModel.h"

@interface HomeYaSiHeaderView ()<UICollectionViewDataSource>

@property(nonatomic,strong)UIButton *yasiBtn;
@property(nonatomic,strong)UIButton *signedBtn;
@property(nonatomic,strong)UILabel *signTitleLab;
@property(nonatomic,strong)UIButton *punchBtn;
@property(nonatomic,strong)UIButton *punchTitleLab;
@property(nonatomic,strong)UIImageView *clockBtn;
@property(nonatomic,strong)UIButton *bgBtn;
@property(nonatomic,strong)UILabel *onlineLab;

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UICollectionView *bannerView;
@property(nonatomic,strong)UIView *line_banner;

@property(nonatomic,strong)UICollectionViewFlowLayout *flow;

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
    
    self.backgroundColor = XCOLOR_RED;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor yellowColor];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIButton *ysBtn = [UIButton new];
    ysBtn.backgroundColor = XCOLOR_RANDOM;
    [self addSubview:ysBtn];
    self.yasiBtn = ysBtn;
    [ysBtn addTarget:self action:@selector(caseLogo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signedBtn = [UIButton new];
    [signedBtn setTitle:@"已签到" forState:UIControlStateNormal];
    signedBtn.titleLabel.font = XFONT(12);
    signedBtn.layer.cornerRadius = 2;
    signedBtn.layer.borderWidth = 1;
    signedBtn.layer.borderColor = XCOLOR_SUBTITLE.CGColor;
    [self addSubview:signedBtn];
    self.signedBtn = signedBtn;
    [signedBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
    
    UILabel *signTitleLab = [UILabel new];
    signTitleLab.font = XFONT(12);
    signTitleLab.textColor = XCOLOR_WHITE;
    self.signTitleLab = signTitleLab;
    [self addSubview:signTitleLab];
    signTitleLab.text = @"累计签到100天";
    
    UIButton *bgBtn = [UIButton new];
    [self addSubview:bgBtn];
    self.bgBtn = bgBtn;
    bgBtn.backgroundColor = XCOLOR(0, 0, 0, 0.5);
    
 
    UIImageView *clockBtn = [UIImageView new];
    [self addSubview:clockBtn];
    self.clockBtn = clockBtn;
    clockBtn.backgroundColor = XCOLOR_RANDOM;
    
    UILabel *onlineLab = [UILabel new];
    onlineLab.font = XFONT(12);
    onlineLab.textColor = XCOLOR_WHITE;
    self.onlineLab = onlineLab;
    [self addSubview:onlineLab];
    onlineLab.text = @"直播课 张三老师  雅思听力五步法整体做策略....";
 
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    self.flow = flow;
    UICollectionView *bannerView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
    bannerView.backgroundColor = XCOLOR(0, 0, 0, 0.3);
   [self addSubview:bannerView];
    self.bannerView = bannerView;
    bannerView.dataSource = self;
    bannerView.pagingEnabled = YES;
    bannerView.clipsToBounds = NO;
    
    UIView *line_banner = [UIView new];
    line_banner.backgroundColor = XCOLOR_line;
    [self addSubview:line_banner];
    self.line_banner = line_banner;
 
}

- (void)setYsModel:(YaSiHomeModel *)ysModel{
    
    _ysModel = ysModel;
    
    self.bottomView.frame = ysModel.bottomView_frame;
    
    self.yasiBtn.frame = ysModel.ysBtn_frame;
    self.signedBtn.frame = ysModel.signedBtn_frame;
    self.signTitleLab.frame = ysModel.signTitle_frame;
    self.clockBtn.frame = ysModel.clockBtn_frame;
    self.bgBtn.frame = ysModel.bgBtn_frame;
    self.onlineLab.frame = ysModel.onlineLab_frame;
    self.line_banner.frame = ysModel.line_banner_frame;
    
    self.bannerView.frame = ysModel.bannerView_frame;
    self.flow.itemSize = ysModel.header_banner_size;
    
}


#pragma mark : UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 30;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *taggg =[NSString stringWithFormat:@"%ld",indexPath.row];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:taggg];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:taggg forIndexPath:indexPath];
    cell.contentView.backgroundColor =  XCOLOR_RANDOM ;
    
    return cell;
}

#pragma mark : 事件处理

- (void)caseLogo:(UIButton *)sender{
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end