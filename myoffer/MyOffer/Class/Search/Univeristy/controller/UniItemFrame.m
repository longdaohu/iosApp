//
//  UniItemFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniItemFrame.h"

@implementation UniItemFrame
+(instancetype)frameWithUniversity:(UniversityNew *)uni
{
 
    UniItemFrame *itemFrame = [[UniItemFrame alloc] init];
    itemFrame.item = uni;
    
    return itemFrame;
}


-(void)setItem:(UniversityNew *)item{

    _item = item;
    

    CGFloat CONTENTWIDTH = XSCREEN_WIDTH;
    
    CGFloat logoX = XMARGIN;
    CGFloat logoY = XMARGIN ;
    CGFloat logoH = Uni_Cell_Height - 2 * logoY;
    CGFloat logoW = logoH;
    self.logoFrame = CGRectMake(logoX, logoY, logoW, logoH);
    
    CGFloat nameX = CGRectGetMaxX(self.logoFrame) + XMARGIN;
    CGFloat nameY = logoY;
    CGFloat nameW = CONTENTWIDTH - nameX;
    CGFloat nameH = Uni_title_FontSize;
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat officialX = nameX;
    CGFloat officialY = CGRectGetMaxY(self.nameFrame) + 2;
    CGFloat officialW = nameW;
    
    CGSize  officialSize = [item.official_name KD_sizeWithAttributeFont:XFONT(Uni_subtitle_FontSize)  maxWidth:officialW];
    CGFloat officialH = officialSize.height;
    self.official_nameFrame = CGRectMake(officialX, officialY, officialW, officialH);
    
    CGFloat qsX = nameX;
    CGFloat qsH = Uni_rank_FontSize;
    CGFloat qsY = CGRectGetMaxY(self.logoFrame) - qsH;
    CGFloat qsW = 0.5 * (CONTENTWIDTH - qsX);
    self.QSRankFrame = CGRectMake(qsX, qsY, qsW, qsH);
    
    CGFloat localX = CGRectGetMaxX(self.QSRankFrame);
    CGFloat localH = qsH;
    CGFloat localY = qsY;
    CGFloat localW = 0.5 * (CONTENTWIDTH - qsX);
    self.TIMESRankFrame = CGRectMake(localX, localY, localW, localH);
    
    
    CGFloat anthorX =  nameX;
    CGFloat anthorH =  Uni_address_FontSize + 5;
    CGFloat anthorW =  anthorH;
    CGFloat padding  = CGRectGetMinY(self.TIMESRankFrame) - CGRectGetMaxY(self.official_nameFrame) - anthorH;
    CGFloat anthorY =  CGRectGetMaxY(self.official_nameFrame) + padding * 0.5;
    self.anchorFrame = CGRectMake(anthorX, anthorY, anthorW, anthorH);
    
    
    CGFloat addressX =  CGRectGetMaxX(self.anchorFrame) + 5;
    CGFloat addressH =  Uni_address_FontSize;
    CGFloat addressW =  CONTENTWIDTH - addressX;
    CGFloat addressY =  anthorY  + 3;
    self.address_detailFrame = CGRectMake(addressX, addressY, addressW, addressH);
    
    
    CGFloat RCh = 50;
    CGFloat RCw = RCh;
    CGFloat RCx = XSCREEN_WIDTH - RCh;
    CGFloat RCy = 0;
    self.hotFrame = CGRectMake(RCx,RCy, RCw ,RCh);
    
    
}




@end
