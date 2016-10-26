//
//  UniversityFrameApplyObj.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrameApplyObj.h"
#import "UniversityObj.h"
#import "UniversityItemNew.h"

@implementation UniversityFrameApplyObj

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
    CGFloat titley =logoy;
    CGFloat titleh = XPERCENT * 15;
    CGFloat titlew = XScreenWidth - titlex;
    self.nameFrame = CGRectMake(titlex, titley - 3, titlew, titleh);
    
    
    CGFloat subx = CGRectGetMaxX(self.LogoFrame) + ITEM_MARGIN;
    CGFloat suby = CGRectGetMaxY(self.nameFrame) + 3;
    CGFloat subw = XScreenWidth - subx - 45;
    CGFloat subh =  XPERCENT * 11 + 2;
    self.official_nameFrame = CGRectMake(subx, suby, subw, subh);

    
    CGFloat anthorX =  subx;
    CGFloat anthorH =  XPERCENT * 11 + 5;
    CGFloat anthorW =  anthorH;
    CGFloat anthorY =  CGRectGetMaxY(self.LogoFrame) - anthorH;
    self.anchorFrame = CGRectMake(anthorX, anthorY, anthorW, anthorH);
    
    CGFloat addressX =  CGRectGetMaxX(self.anchorFrame) + 5;
    CGFloat addressH =  XPERCENT * 11;
    CGFloat addressW =  subw;
    CGFloat addressY =  anthorY  + 3;
    self.address_detailFrame = CGRectMake(addressX, addressY, addressW, addressH);
    
    CGFloat Rankx = subx;
    CGFloat Rankw = subw;
    CGFloat Rankh = addressH;
    CGFloat Ranky = CGRectGetMaxY(self.official_nameFrame) + (addressY - CGRectGetMaxY(self.official_nameFrame) - Rankh) * 0.5;
    self.RankFrame = CGRectMake(Rankx, Ranky, Rankw, Rankh);
    
    
    NSString *rankIT  =[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
    CGSize rankSize = [rankIT KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT))];
    self.starBgFrame = CGRectMake(self.official_nameFrame.origin.x + rankSize.width , self.RankFrame.origin.y, 100, 15);
    NSMutableArray *temps =[NSMutableArray array];
    for (NSInteger i =0; i < 5; i++) {
        
        NSString *x = [NSString stringWithFormat:@"%ld", (long)(20 * i)];
        
        [temps addObject: x];
    }
    self.starFrames = [temps copy];
    
    
    CGFloat ADx = XScreenWidth - 40;
    CGFloat ADy = 0;
    CGFloat ADw = 30;
    CGFloat ADh = University_HEIGHT;
    self.AddButtonFrame = CGRectMake(ADx,ADy,ADw,ADh);

}


-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}


@end
