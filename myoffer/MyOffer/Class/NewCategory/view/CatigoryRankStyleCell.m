//
//  CatigoryRankStyleCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "CatigoryRankStyleCell.h"
#import "CatigoryRank.h"

@interface CatigoryRankStyleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *rankStyleLab;

@end

@implementation CatigoryRankStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-(void)setRank:(CatigoryRank *)rank
{
    _rank = rank;
    
    self.iconView.image = [UIImage imageNamed:rank.iconName];
    
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 6;
    paragraph.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:rank.titleName];
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, rank.titleName.length)];
    
    self.rankStyleLab.attributedText = attrStr;
    
}


@end

