//
//  UniverstyHeaderView.m
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "UniverstyHeaderView.h"
#import "UniversityheaderCenterView.h"
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
        UniversityheaderCenterView *centerView =  [UniversityheaderCenterView View];
        centerView.actionBlock = ^(UIButton *sender){
        
            [weakSelf onclick:sender];

        };
        self.centerView = centerView;
        [self addSubview:centerView];
 
        
        self.rightView = [[NSBundle mainBundle] loadNibNamed:@"UniversityRightView" owner:self options:nil].lastObject;
        self.rightView.actionBlock = ^(UIButton *sender){
            
            [weakSelf onclick:sender];
        };
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
    NSString *local_rank_name  =  [itemFrame.item.country  containsString:@"英"] ? local_rankStr : [NSString stringWithFormat:@"%@星",local_rankStr];
    NSString *local_rank = itemFrame.item.ranking_ti.integerValue == DefaultNumber ? @"暂无排名" :local_rank_name;
    NSString *times = [NSString stringWithFormat:@"%@\n本国排名",local_rank];
    NSRange timesRange = [times rangeOfString:local_rank];
    NSMutableAttributedString *timesAttri = [[NSMutableAttributedString alloc] initWithString:times];
    [timesAttri addAttribute:NSFontAttributeName value:XFONT(XPERCENT * 17) range: NSMakeRange (0, timesRange.length)];
    self.TIMESLab.attributedText = timesAttri;
    
    
    NSString *global_rank = itemFrame.item.ranking_qs.integerValue == DefaultNumber ? @"暂无排名" : [NSString stringWithFormat:@"%@",itemFrame.item.ranking_qs];
    NSString *qs = [NSString stringWithFormat:@"%@\n世界排名",global_rank];
    NSRange qsRange = [qs rangeOfString:[NSString stringWithFormat:@"%@",global_rank]];
    NSMutableAttributedString *qsAttri = [[NSMutableAttributedString alloc] initWithString:qs];
    [qsAttri addAttribute:NSFontAttributeName value:XFONT(XPERCENT * 17) range: NSMakeRange (0, qsRange.length)];
    self.QSrankLab.attributedText = qsAttri;
    
    
    NSArray *tagsOne = [itemFrame.item.tags subarrayWithRange:NSMakeRange(0, (itemFrame.item.tags.count < 3) ? itemFrame.item.tags.count : 3)];
    self.tagOneLab.text =  [tagsOne componentsJoinedByString:@"  .  "];
    self.tagOneLab.frame = itemFrame.tagsOneFrame;
    
    
    if (itemFrame.item.tags.count > 3) {
        NSArray *tagsTwo = [itemFrame.item.tags subarrayWithRange:NSMakeRange(3, itemFrame.item.tags.count - 3)];
        self.tagTwoLab.text = [tagsTwo componentsJoinedByString:@"  .  "];
    }
    
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





@end
