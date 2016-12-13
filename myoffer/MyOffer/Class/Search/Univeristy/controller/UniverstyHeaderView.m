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
        
        self.rightView = [UniversityRightView ViewWithBlock:^(UIButton *sender) {
            
            [weakSelf onclick:sender];
            
        }];
        [self addSubview:self.rightView];

        
        
        UILabel *qsLab = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        qsLab.numberOfLines = 0;
        self.QSrankLab = qsLab;
        [self.upView addSubview:qsLab];
        
        
        UILabel *timesLab = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        timesLab.numberOfLines = 0;
        self.TIMESLab = timesLab;
        [self.upView addSubview:timesLab];
        
        
        UILabel *tagOneLab = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        tagOneLab.numberOfLines = 0;
        self.tagOneLab = tagOneLab;
        [self.upView addSubview:tagOneLab];

        
        UILabel *tagTwoLab = [UILabel labelWithFontsize:XPERCENT * 13 TextColor:[UIColor whiteColor] TextAlignment:NSTextAlignmentCenter];
        tagTwoLab.numberOfLines = 0;
        self.tagTwoLab = tagTwoLab;
        [self.upView addSubview:tagTwoLab];

    }
    return self;
}

- (void)setItemFrame:(UniversityNewFrame *)itemFrame
{
    _itemFrame = itemFrame;
    
    
    self.upView.frame =  itemFrame.upViewFrame;
    
    self.downView.frame =   itemFrame.downViewFrame;
    
    self.centerView.frame =   itemFrame.centerViewFrame;
    
    self.centerView.itemFrame =   itemFrame;
    
    self.TIMESLab.frame =   itemFrame.TIMESRankFrame;
    
    self.QSrankLab.frame =   itemFrame.QSRankFrame;
    
    
    NSString *local_rankStr  = [NSString stringWithFormat:@"%@", itemFrame.item.ranking_ti];
    NSString *local_rank_name  =  local_rankStr;
    if ([itemFrame.item.country  containsString:@"澳"]) {
       local_rank_name  =  [NSString stringWithFormat:@"%@星",local_rankStr];
    }
    NSString *local_rank = itemFrame.item.ranking_ti.integerValue == DEFAULT_NUMBER ? @"暂无排名" :local_rank_name;
    NSString *localName = [itemFrame.item.country isEqualToString:@"美国"] ? @"TIMES排名":@"本国排名";
    NSString *times = [NSString stringWithFormat:@"%@\n%@",local_rank,localName];
    NSRange timesRange = [times rangeOfString:local_rank];
    NSMutableAttributedString *timesAttri = [[NSMutableAttributedString alloc] initWithString:times];
    [timesAttri addAttribute:NSFontAttributeName value:XFONT(XPERCENT * 17) range: NSMakeRange (0, timesRange.length)];
    self.TIMESLab.attributedText = timesAttri;
     
    NSString *global_rank = itemFrame.item.ranking_qs.integerValue == DEFAULT_NUMBER ? @"暂无排名" : [NSString stringWithFormat:@"%@",itemFrame.item.ranking_qs];
    NSString *qs = [NSString stringWithFormat:@"%@\n世界排名",global_rank];
    NSRange qsRange = [qs rangeOfString:[NSString stringWithFormat:@"%@",global_rank]];
    NSMutableAttributedString *qsAttri = [[NSMutableAttributedString alloc] initWithString:qs];
    [qsAttri addAttribute:NSFontAttributeName value:XFONT(XPERCENT * 17) range: NSMakeRange (0, qsRange.length)];
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
        
        
        CGSize oneSize = [oneStr KD_sizeWithAttributeFont:XFONT(XPERCENT * 13)];
        
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
        
        CGSize oneSize = [twoStr KD_sizeWithAttributeFont:XFONT(XPERCENT * 13)];
        
        if (oneSize.width > (itemFrame.tagsOneFrame.size.width  - 30)) {
            
            twoStr = [lastTwoStr mutableCopy];
            
            break;
        }
        
    }
    self.tagTwoLab.text = twoStr;
    self.tagTwoLab.frame = itemFrame.tagsTwoFrame;
    [self.rightView shadowWithFavorited:itemFrame.item.favorited];
    
  
}

- (void)onclick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
        
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.rightView.frame =  self.itemFrame.rightViewFrame;
 
}

//收藏
- (void)headerViewRightViewWithShadowFavorited:(BOOL)favorited{

    [self.rightView  shadowWithFavorited:favorited];
    
}



@end


