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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.upView = [[UIView alloc] init];
         [self addSubview:self.upView];
        
        self.downView =[[UIView alloc] init];
        self.downView.backgroundColor = BACKGROUDCOLOR;
        [self addSubview:self.downView];
        
        XJHUtilDefineWeakSelfRef
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
        
        
        UILabel *qsLab = [[UILabel alloc] init];
        qsLab.numberOfLines = 0;
        qsLab.font = XFONT(XPERCENT * 13);
        self.QSrankLab = qsLab;
        qsLab.textColor = [UIColor whiteColor];
        qsLab.textAlignment = NSTextAlignmentCenter;
        [self.upView addSubview:qsLab];
        
        UILabel *timesLab = [[UILabel alloc] init];
        timesLab.numberOfLines = 0;
        timesLab.font = XFONT(XPERCENT * 13);
        self.TIMESLab = timesLab;
        timesLab.textColor = [UIColor whiteColor];
        timesLab.textAlignment = NSTextAlignmentCenter;
        [self.upView addSubview:timesLab];
        
        
        UILabel *tagOneLab = [[UILabel alloc] init];
        tagOneLab.numberOfLines = 0;
        tagOneLab.font = XFONT(XPERCENT * 13);
        self.tagOneLab = tagOneLab;
        tagOneLab.textColor = [UIColor whiteColor];
        tagOneLab.textAlignment = NSTextAlignmentCenter;
        [self.upView addSubview:tagOneLab];
        tagOneLab.backgroundColor = [UIColor yellowColor];

        
        UILabel *tagTwoLab = [[UILabel alloc] init];
        tagTwoLab.numberOfLines = 0;
        tagTwoLab.font = XFONT(XPERCENT * 13);
        self.tagTwoLab = tagTwoLab;
        tagTwoLab.textColor = [UIColor whiteColor];
        tagTwoLab.textAlignment = NSTextAlignmentCenter;
        [self.upView addSubview:tagTwoLab];
        tagTwoLab.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setItemFrame:(UniversityNewFrame *)itemFrame
{
    _itemFrame = itemFrame;
    
    self.upView.frame = itemFrame.upViewFrame;
    
    self.downView.frame = itemFrame.downViewFrame;
 
    self.centerView.frame = itemFrame.centerViewFrame;
    
    self.centerView.itemFrame = itemFrame;
    
    
    self.TIMESLab.frame = itemFrame.TIMESRankFrame;
    
    self.QSrankLab.frame = itemFrame.QSRankFrame;
    
    NSString *times = [NSString stringWithFormat:@"%@\nTIMES排名",itemFrame.item.local_rank];
    NSRange timesRange = [times rangeOfString:[NSString stringWithFormat:@"%@",itemFrame.item.local_rank]];
    NSMutableAttributedString *timesAttri = [[NSMutableAttributedString alloc] initWithString:times];
    [timesAttri addAttribute:NSFontAttributeName value:XFONT(XPERCENT * 17) range: NSMakeRange (0, timesRange.length)];
    self.TIMESLab.attributedText = timesAttri;
    
    NSString *qs = [NSString stringWithFormat:@"%@\n全球QS排名",itemFrame.item.global_rank];
    NSRange qsRange = [qs rangeOfString:[NSString stringWithFormat:@"%@",itemFrame.item.global_rank]];
    NSMutableAttributedString *qsAttri = [[NSMutableAttributedString alloc] initWithString:qs];
    [qsAttri addAttribute:NSFontAttributeName value:XFONT(XPERCENT * 17) range: NSMakeRange (0, qsRange.length)];
    self.QSrankLab.attributedText = qsAttri;

 
    
    NSArray *tagsOne = [itemFrame.item.tags subarrayWithRange:NSMakeRange(0, (itemFrame.item.tags.count < 3) ? itemFrame.item.tags.count : 3)];
    self.tagOneLab.text = (itemFrame.item.tags.count == 0) ? @" - " : [tagsOne componentsJoinedByString:@"  ·  "];
    self.tagOneLab.frame = itemFrame.tagsOneFrame;
 
    if (itemFrame.item.tags.count > 3) {
        NSArray *tagsTwo = [itemFrame.item.tags subarrayWithRange:NSMakeRange(3, itemFrame.item.tags.count - 3)];
        self.tagTwoLab.text = [tagsTwo componentsJoinedByString:@"  ·  "];
    }
  
    self.tagTwoLab.frame = itemFrame.tagsTwoFrame;
    
    self.rightView.favorited = itemFrame.item.favorited;

}


- (void)onclick:(UIButton *)sender{
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
        
    }
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect rightRect = self.rightView.frame;
    rightRect = self.itemFrame.rightViewFrame;
    self.rightView.frame = rightRect;
}





@end
