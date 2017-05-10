//
//  CatigaryRankkCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/26.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "CatigaryRankkCell.h"
@interface CatigaryRankkCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

@end


@implementation CatigaryRankkCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setRank:(CatigoryRank *)rank
{
    _rank = rank;
    
    self.iconView.image = [UIImage imageNamed:rank.iconName];
    self.titleLab.text = rank.titleName;
    self.subTitleLab.text = rank.subTitle;
    
}


@end


/*
 
 NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
 paragraph.lineSpacing = 6;
 paragraph.alignment = NSTextAlignmentCenter;
 NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:rank.titleName];
 [attrStr addAttribute:NSParagraphStyleAttributeName
 value:paragraph
 range:NSMakeRange(0, rank.titleName.length)];
 self.titleLab.attributedText = attrStr;
 
 */
