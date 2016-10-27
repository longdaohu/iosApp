//
//  UniversityFrameNew.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrameNew.h"
#import "UniversityItemNew.h"

@implementation UniversityFrameNew

+(instancetype)universityFrameWithUni:(UniversityItemNew *)uni{

    UniversityFrameNew *uniFrame = [[UniversityFrameNew alloc] init];

    uniFrame.uni = uni;
    
    return uniFrame;
}


-(void)setUni:(UniversityItemNew *)uni{

    _uni = uni;
    
    CGFloat cancelx = ITEM_MARGIN;
    CGFloat cancely = 0;
    CGFloat cancelh = University_HEIGHT;
    CGFloat cancelw = 34;
    self.CancelButtonFrame = CGRectMake(cancelx, cancely, cancelw, cancelh);
    
    CGFloat sectionBgx = 0;
    CGFloat sectionBgy = 0;
    CGFloat sectionBgh = University_HEIGHT;
    CGFloat sectionBgw = XScreenWidth;
    self.SectionBackgroudFrame = CGRectMake(sectionBgx,sectionBgy, sectionBgw, sectionBgh);
    
    
    CGFloat logox = ITEM_MARGIN;
    CGFloat logoy = ITEM_MARGIN;
    CGFloat logoh = University_HEIGHT - 2 * ITEM_MARGIN;
    CGFloat logow = logoh;
    self.LogoFrame = CGRectMake(logox, logoy, logow, logoh);
    
    
    CGFloat titlex = CGRectGetMaxX(self.LogoFrame) + ITEM_MARGIN;
    CGFloat titley = logoy + 5;
    CGFloat titleh = Uni_address_FontSize;
    CGFloat titlew = XScreenWidth - titlex;
    self.nameFrame = CGRectMake(titlex, titley - 3, titlew, titleh);
    
    
    CGFloat official_nameX = CGRectGetMaxX(self.LogoFrame) + ITEM_MARGIN;
    CGFloat official_nameY = CGRectGetMaxY(self.nameFrame) + 3;
    CGFloat official_nameW = XScreenWidth - official_nameX - 45;
    CGFloat official_nameH =  Uni_subtitle_FontSize + 2;
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
    
    
    CGFloat addX = XScreenWidth - 40;
    CGFloat addY = 0;
    CGFloat addW = 30;
    CGFloat addH = University_HEIGHT;
    self.AddButtonFrame = CGRectMake(addX,addY,addW,addH);
    
    
    CGFloat hotH = 50;
    CGFloat hotW = hotH;
    CGFloat hotX = XScreenWidth - hotH;
    CGFloat hotY = 0;
    self.hotFrame = CGRectMake(hotX,hotY, hotW,hotH);

}


-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


@end
