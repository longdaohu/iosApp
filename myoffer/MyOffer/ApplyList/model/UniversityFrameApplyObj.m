//
//  UniversityFrameApplyObj.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/5.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityFrameApplyObj.h"
#import "UniversityObj.h"

@implementation UniversityFrameApplyObj

-(void)setUniObj:(UniversityObj *)uniObj
{
    _uniObj = uniObj;
    
    CGFloat cancelx = 5;
    CGFloat cancely = 0;
    CGFloat cancelh = University_HEIGHT;
    CGFloat cancelw = 40;
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
    NSString *title = uniObj.titleName;
    CGSize titleSize = [title KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(UNIVERISITYTITLEFONT))];
    CGFloat titleh = titleSize.height;
    CGFloat titlew = XScreenWidth - titlex;
    self.TitleFrame = CGRectMake(titlex, titley - 3, titlew, titleh);
    
    
    CGFloat subx = CGRectGetMaxX(self.LogoFrame) + ITEM_MARGIN;
    CGFloat suby = CGRectGetMaxY(self.TitleFrame) + 3;
    CGFloat fontSize =  KDUtilSize(UNIVERISITYSUBTITLEFONT);
    CGFloat subw = XScreenWidth - subx - 45;
    if (USER_EN) {
        
        suby   = logoy + 2;
        fontSize =  KDUtilSize(UNIVERISITYTITLEFONT);
        subw = XScreenWidth - subx ;
     }
    
    CGFloat subh =  [self getContentBoundWithTitle:uniObj.subTitleName andFontSize:fontSize andMaxWidth:subw].height;
    self.SubTitleFrame = CGRectMake(subx, suby, subw, subh);
    
    
    CGFloat Rankx = subx;
    CGFloat Rankw = subw;
    NSString *local = uniObj.countryName;
    CGSize  localSize = [local KD_sizeWithAttributeFont: FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT))];
    CGFloat Rankh = localSize.height;
    CGFloat Ranky = CGRectGetMaxY(self.LogoFrame) - Rankh + 3;
    self.RankFrame = CGRectMake(Rankx, Ranky, Rankw, Rankh);
    
    
    CGFloat locMVx = subx;
    CGFloat locMVh = Rankh;
    CGFloat locMVw = locMVh + 5;
    CGFloat localMargin = 5;
    
    if (USER_EN) {
        
        localMargin = localMargin + (XScreenWidth - 320) * 0.06;
    }
    CGFloat locMVy = CGRectGetMinY(self.RankFrame) - locMVh - localMargin;
    self.LocalMVFrame = CGRectMake(locMVx, locMVy, locMVw, locMVh);
    
 
    CGFloat localy = CGRectGetMinY(self.RankFrame) - Rankh - localMargin;
    CGFloat localx = Rankx;
    CGFloat localw = XScreenWidth - localx;
    CGFloat localh = Rankh;
    self.LocalFrame = CGRectMake(localx, localy + 2, localw, localh);
    
    
    NSString *rankIT  =[NSString stringWithFormat:@"%@：",GDLocalizedString(@"SearchRank_Country")];
    CGSize rankSize = [rankIT KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(UNIVERISITYLOCALFONT))];
    self.starBgFrame = CGRectMake(self.SubTitleFrame.origin.x + rankSize.width , self.RankFrame.origin.y, 100, 20);
    
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
