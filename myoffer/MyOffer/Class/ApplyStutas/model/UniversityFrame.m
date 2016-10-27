//
//  UniversityFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrame.h"
#import "UniversityItemNew.h"
@implementation UniversityFrame


-(void)setUniversity:(UniversityItemNew *)university{

    _university = university;
 
    CGFloat logox = 40;
    CGFloat logoy = ITEM_MARGIN;
    CGFloat logoh = University_HEIGHT - 2 * ITEM_MARGIN;
    CGFloat logow = logoh;
    self.LogoFrame = CGRectMake(logox, logoy, logow, logoh);
    
    
    CGFloat nameX = CGRectGetMaxX(self.LogoFrame) + ITEM_MARGIN;
    CGFloat nameY =logoy;
    CGFloat nameH =  Uni_title_FontSize;
    CGFloat nameW = XScreenWidth - nameX;
    self.nameFrame = CGRectMake(nameX, nameY - 3, nameW, nameH);
    
    
    CGFloat official_nameX = CGRectGetMaxX(self.LogoFrame) + ITEM_MARGIN;
    CGFloat official_nameY = CGRectGetMaxY(self.nameFrame) + 3;
    CGFloat official_nameW = XScreenWidth - official_nameX;
    CGFloat official_nameH =  Uni_subtitle_FontSize;
    self.official_nameFrame = CGRectMake(official_nameX, official_nameY, official_nameW, official_nameH);
    
    
 
    
    CGFloat anthorX =  official_nameX;
    CGFloat anthorH =  Uni_rank_FontSize + 5;
    CGFloat anthorW =  anthorH;
    CGFloat anthorY =  CGRectGetMaxY(self.LogoFrame) - anthorH;
    self.anchorFrame = CGRectMake(anthorX, anthorY, anthorW, anthorH);
    
    CGFloat addressX =  CGRectGetMaxX(self.anchorFrame) + 5;
    CGFloat addressH =  Uni_address_FontSize;
    CGFloat addressW =  official_nameW;
    CGFloat addressY =  anthorY  + 3;
    self.address_detailFrame = CGRectMake(addressX, addressY, addressW, addressH);
    
    
    
    CGFloat rankX = official_nameX;
    CGFloat rankW = official_nameW;
    CGFloat rankH = Uni_rank_FontSize;
    CGFloat rankY = CGRectGetMaxY(self.official_nameFrame) + (addressY - CGRectGetMaxY(self.official_nameFrame) - rankH) * 0.5;
    self.RankFrame = CGRectMake(rankX, rankY, rankW, rankH);
    
    
    NSString *rankIT  =[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
    CGSize rankSize = [rankIT KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT))];
    self.starBgFrame = CGRectMake(self.official_nameFrame.origin.x + rankSize.width , self.RankFrame.origin.y, 100, 15);
    NSMutableArray *temps =[NSMutableArray array];
    for (NSInteger i =0; i < 5; i++) {
        
        NSString *x = [NSString stringWithFormat:@"%ld", (long)(20 * i)];
        
        [temps addObject: x];
    }
    self.starFrames = [temps copy];
    
}





-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


@end


