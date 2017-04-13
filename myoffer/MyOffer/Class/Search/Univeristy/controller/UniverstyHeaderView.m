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
//标签
@property(nonatomic,strong)UILabel *tagOneLab;
//标签
@property(nonatomic,strong)UILabel *tagTwoLab;
//收藏、分享
@property(nonatomic,strong)UniversityRightView *rightView;

@end

@implementation UniverstyHeaderView
+ (instancetype)headerTableViewWithUniFrame:(UniversityNewFrame *)universityFrame{

    UniverstyHeaderView  * header  = [[UniverstyHeaderView alloc] init];
    header.clipsToBounds           = YES;
    header.itemFrame               = universityFrame;
    
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
        
        
        XWeakSelf
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

        //大学标签
        UILabel *tagOneLab = [UILabel labelWithFontsize:XFONT_SIZE(16) TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        tagOneLab.numberOfLines = 0;
        self.tagOneLab = tagOneLab;
        [self textShadowWithLabel:tagOneLab];

        //大学标签
        UILabel *tagTwoLab = [UILabel labelWithFontsize:XFONT_SIZE(16) TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        tagTwoLab.numberOfLines = 0;
        self.tagTwoLab = tagTwoLab;
        [self textShadowWithLabel:tagTwoLab];


    }
    return self;
}

//给 label 添加 阴影颜色
- (void)textShadowWithLabel:(UILabel *)sender{
    
    sender.layer.shadowColor = [UIColor blackColor].CGColor;
    sender.layer.shadowOffset = CGSizeMake(0,0);
    sender.layer.shadowOpacity = 0.9;
    sender.layer.shadowRadius = 2.0;
    //        qsLab.clipsToBounds = NO;
    [self.upView addSubview:sender];

}



- (void)setItemFrame:(UniversityNewFrame *)itemFrame
{
    _itemFrame = itemFrame;
    
    
    self.upView.frame =  itemFrame.upViewFrame;
    
    self.downView.frame =   itemFrame.downViewFrame;
    
    self.centerView.frame =   itemFrame.centerView_Frame;
    
    self.centerView.UniversityFrame =   itemFrame;
    
    self.TIMESLab.frame =   itemFrame.TIMES_Frame;
    
    self.QSrankLab.frame =   itemFrame.QS_Frame;
    
    //更新 世界、本地排名 及大学标签
    [self configurationWithUniversityFrame:itemFrame];

    [self.rightView shadowWithFavorited:itemFrame.item.favorited];
    
  
}

- (void)onclick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
        
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.rightView.frame =  self.itemFrame.rightView_Frame;
 
}

//收藏
- (void)headerViewRightViewWithShadowFavorited:(BOOL)favorited{

    [self.rightView  shadowWithFavorited:favorited];
    
}

//更新 世界、本地排名 及大学标签
- (void)configurationWithUniversityFrame:(UniversityNewFrame *)itemFrame{

    
    NSString *localName = [itemFrame.item.country isEqualToString:@"美国"] ? @"TIMES排名":@"本国排名";
    NSString *times = [NSString stringWithFormat:@"%@\n%@",itemFrame.item.ranking_ti_str,localName];
    NSRange timesRange = [times rangeOfString:itemFrame.item.ranking_ti_str];
    NSMutableAttributedString *timesAttri = [[NSMutableAttributedString alloc] initWithString:times];
    [timesAttri addAttribute:NSFontAttributeName value:XFONT(XFONT_SIZE(22)) range: NSMakeRange (0, timesRange.length)];
    self.TIMESLab.attributedText = timesAttri;
    
    NSString *qs = [NSString stringWithFormat:@"%@\n世界排名",itemFrame.item.ranking_qs_str];
    NSRange qs_Range = [qs rangeOfString:[NSString stringWithFormat:@"%@",itemFrame.item.ranking_qs_str]];
    NSMutableAttributedString *qsAttri = [[NSMutableAttributedString alloc] initWithString:qs];
    [qsAttri addAttribute:NSFontAttributeName value:XFONT(XFONT_SIZE(22)) range: NSMakeRange (0, qs_Range.length)];
    self.QSrankLab.attributedText = qsAttri;
    
    
    
    NSMutableString *oneStr =  [NSMutableString string];
    NSString *lastOneStr = @"";
    NSInteger lastIndex = 0;
    for (NSInteger index = 0 ; index < itemFrame.item.tags.count; index++) {
        
        lastIndex = index;
        
        if (index ==0) {
            
            [oneStr appendString:itemFrame.item.tags[index]];
            
            lastOneStr = [oneStr copy];
            
        }else{
            
            lastOneStr = [oneStr copy];
            
            [oneStr appendString:@" . "];
            [oneStr appendString:itemFrame.item.tags[index]];
        }
        
        
        CGSize oneSize = [oneStr KD_sizeWithAttributeFont:XFONT(XFONT_SIZE(16))];
        
        if (oneSize.width > (itemFrame.tagsOneFrame.size.width  - 30)) {
            
            lastIndex = index;
            oneStr = [lastOneStr mutableCopy];
            
            break;
        }
        
    }
    self.tagOneLab.text = oneStr;
    self.tagOneLab.frame = itemFrame.tagsOneFrame;
    
    
    NSMutableString *twoStr =  [NSMutableString string];
    NSString *lastTwoStr = @"";
    for (NSInteger indexx = (lastIndex + 1); indexx < itemFrame.item.tags.count; indexx++) {
        
        if (indexx ==  (lastIndex + 1)) {
            
            [twoStr appendString:itemFrame.item.tags[indexx]];
            
            lastTwoStr = [twoStr copy];
            
        }else{
            
            lastTwoStr = [twoStr copy];
            
            [twoStr appendString:@" . "];
            [twoStr appendString:itemFrame.item.tags[indexx]];
        }
        
        CGSize oneSize = [twoStr KD_sizeWithAttributeFont:XFONT(XFONT_SIZE(16))];
        
        if (oneSize.width > (itemFrame.tagsOneFrame.size.width  - 30)) {
            
            twoStr = [lastTwoStr mutableCopy];
            
            break;
        }
        
    }
    self.tagTwoLab.text = twoStr;
    self.tagTwoLab.frame = itemFrame.tagsTwoFrame;
}

- (void)dealloc{
    
    KDClassLog(@" 学校详情  UniverstyHeaderView dealloc OK");
    
}


@end


