//
//  UniverstyHeaderView.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//


#import "UniversityNewFrame.h"
#import "UniversityRightView.h"
#import "UniverstyHeaderView.h"
#import "UniversityheaderCenterView.h"
@interface UniverstyHeaderView ()
//上部分View
@property(nonatomic,strong)UIView  *upView;
//中间部分
@property(nonatomic,strong)UniversityheaderCenterView *centerView;
//下部分View
@property(nonatomic,strong)UIView   *downView;
//世界排名
@property(nonatomic,strong)UILabel *QSrankLab;
//本国排名
@property(nonatomic,strong)UILabel *TIMESLab;
////标签
//@property(nonatomic,strong)UILabel *tagOneLab;
////标签
//@property(nonatomic,strong)UILabel *tagTwoLab;
//收藏、分享
@property(nonatomic,strong)UniversityRightView *rightView;

@end

@implementation UniverstyHeaderView
+ (instancetype)headerTableViewWithUniFrame:(UniversityNewFrame *)universityFrame{

    UniverstyHeaderView  * header  = [[UniverstyHeaderView alloc] init];
    header.clipsToBounds           = YES;
    header.uniFrame   = universityFrame;
    
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.upView = [[UIView alloc] init];
        [self addSubview:self.upView];
        
        self.downView =[[UIView alloc] init];
        self.downView.backgroundColor = XCOLOR_BG;
        [self addSubview:self.downView];
        
        WeakSelf
        UniversityheaderCenterView *centerView =  [UniversityheaderCenterView headerCenterViewWithBlock:^(UIButton *sender) {
            [weakSelf onclick:sender];
        }];
        self.centerView = centerView;
        [self addSubview:centerView];
        
        //右侧收藏、分享
        self.rightView = [UniversityRightView ViewWithBlock:^(UIButton *sender) {
            [weakSelf onclick:sender];
        }];
        [self addSubview:self.rightView];

        
        //世界排名
        UILabel *qsLab = [UILabel labelWithFontsize:XFONT_SIZE(16) TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        qsLab.numberOfLines = 0;
        self.QSrankLab = qsLab;
        [self textShadowWithLabel:qsLab];
        
        //本国排名
        UILabel *timesLab = [UILabel labelWithFontsize:XFONT_SIZE(16) TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        timesLab.numberOfLines = 0;
        self.TIMESLab = timesLab;
        [self textShadowWithLabel:timesLab];



    }
    return self;
}

//给 label 添加 阴影颜色
- (void)textShadowWithLabel:(UILabel *)sender{
    
    sender.layer.shadowColor = [UIColor blackColor].CGColor;
    sender.layer.shadowOffset = CGSizeMake(0,0);
    sender.layer.shadowOpacity = 0.9;
    sender.layer.shadowRadius = 2.0;
    [self.upView addSubview:sender];

}


- (void)setUniFrame:(UniversityNewFrame *)uniFrame{

    _uniFrame = uniFrame;
    
    self.centerView.frame =   uniFrame.centerView_Frame;
    self.centerView.UniversityFrame =   uniFrame;

    //已添加过没必要重复添加
    if (uniFrame.uni.has_been_added) return;
    uniFrame.uni.has_been_added = YES;
    
    self.downView.frame =   uniFrame.downViewFrame;
    self.upView.frame =  uniFrame.upViewFrame;
    self.TIMESLab.frame =   uniFrame.TIMES_Frame;
    self.QSrankLab.frame =   uniFrame.QS_Frame;
    //更新 世界、本地排名 及大学标签
    [self configurationWithUniversityFrame:uniFrame];
    [self.rightView shadowWithFavorited:uniFrame.uni.favorited];
  
}

- (void)onclick:(UIButton *)sender{
    
    if (self.actionBlock) self.actionBlock(sender);
 
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.rightView.frame =  self.uniFrame.rightView_Frame;
 
}

//收藏
- (void)headerViewRightViewWithShadowFavorited:(BOOL)favorited{

    [self.rightView  shadowWithFavorited:favorited];
    
}

//更新 世界、本地排名 及大学标签
- (void)configurationWithUniversityFrame:(UniversityNewFrame *)itemFrame{
 
    NSString *localName = [itemFrame.uni.country isEqualToString:@"美国"] ? @"TIMES排名":@"本国排名";
    NSString *times = [NSString stringWithFormat:@"%@\n%@",itemFrame.uni.ranking_ti_str,localName];
    NSRange timesRange = [times rangeOfString:itemFrame.uni.ranking_ti_str];
    NSMutableAttributedString *timesAttri = [[NSMutableAttributedString alloc] initWithString:times];
    [timesAttri addAttribute:NSFontAttributeName value:XFONT(XFONT_SIZE(22)) range: NSMakeRange (0, timesRange.length)];
    self.TIMESLab.attributedText = timesAttri;
    
    NSString *qs = [NSString stringWithFormat:@"%@\n世界排名",itemFrame.uni.ranking_qs_str];
    NSRange qs_Range = [qs rangeOfString:[NSString stringWithFormat:@"%@",itemFrame.uni.ranking_qs_str]];
    NSMutableAttributedString *qsAttri = [[NSMutableAttributedString alloc] initWithString:qs];
    [qsAttri addAttribute:NSFontAttributeName value:XFONT(XFONT_SIZE(22)) range: NSMakeRange (0, qs_Range.length)];
    self.QSrankLab.attributedText = qsAttri;
    
    for (NSInteger index = 0; index <  itemFrame.uni.tags_Arr.count; index++) {
        
        UILabel *sender = [UILabel labelWithFontsize:XFONT_SIZE(16) TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        [self.upView addSubview:sender];
        sender.text = itemFrame.uni.tags_Arr[index];
        [self textShadowWithLabel:sender];
        NSString *tag_frame_str = itemFrame.tag_Frames[index];
        sender.frame = CGRectFromString(tag_frame_str);
    }
    
    
}

- (void)dealloc{
    
    KDClassLog(@" 学校详情  + UniverstyHeaderView + dealloc");
    
}


@end


