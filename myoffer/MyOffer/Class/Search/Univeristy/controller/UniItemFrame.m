//
//  UniItemFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniItemFrame.h"

@implementation UniItemFrame
+(instancetype)frameWithUniversity:(UniversityItemNew *)uni
{
 
    UniItemFrame *itemFrame = [[UniItemFrame alloc] init];
    itemFrame.item = uni;
    
    return itemFrame;
}


-(void)setItem:(UniversityItemNew *)item{

    _item = item;
    

    CGFloat CONTENTWIDTH = XScreenWidth;
    
    CGFloat logoX = XMARGIN;
    CGFloat logoY = XMARGIN ;
    CGFloat logoH = University_HEIGHT - 2 * logoY;
    CGFloat logoW = logoH;
    self.logoFrame = CGRectMake(logoX, logoY, logoW, logoH);
    
    CGFloat nameX = CGRectGetMaxX(self.logoFrame) + XMARGIN;
    CGFloat nameY = logoY;
    CGFloat nameW = CONTENTWIDTH - nameX;
    CGFloat nameH = KDUtilSize(UNIVERISITYTITLEFONT);
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat officialX = nameX;
    CGFloat officialY = CGRectGetMaxY(self.nameFrame);
    CGFloat officialW = nameW;
    CGFloat officialWidth   = [item.official_name KD_sizeWithAttributeFont:XFONT(KDUtilSize(UNIVERISITYSUBTITLEFONT))].width;
    CGFloat officialHeigh   = officialWidth > officialW ? 2 * KDUtilSize(UNIVERISITYSUBTITLEFONT) + 5:  KDUtilSize(UNIVERISITYSUBTITLEFONT);
    CGFloat officialH = officialHeigh;
    self.official_nameFrame = CGRectMake(officialX, officialY, officialW, officialH);
    
    
    CGFloat qsX = nameX;
    CGFloat qsH = KDUtilSize(UNIVERISITYSUBTITLEFONT);
    CGFloat qsY = CGRectGetMaxY(self.logoFrame) - qsH;
    CGFloat qsW = 0.5 * (CONTENTWIDTH - qsX);
    self.QSRankFrame = CGRectMake(qsX, qsY, qsW, qsH);
    
    CGFloat localX = CGRectGetMaxX(self.QSRankFrame);
    CGFloat localH = qsH;
    CGFloat localY = qsY;
    CGFloat localW = 0.5 * (CONTENTWIDTH - qsX);
    self.TIMESRankFrame = CGRectMake(localX, localY, localW, localH);

    
    CGFloat anthorX =  nameX;
    CGFloat anthorH =  KDUtilSize(UNIVERISITYSUBTITLEFONT) + 5;
    CGFloat anthorW =  anthorH;
    CGFloat anthorY =  CGRectGetMinY(self.QSRankFrame) - anthorH - XMARGIN;
    self.anchorFrame = CGRectMake(anthorX, anthorY, anthorW, anthorH);
    
    
    CGFloat addressX =  CGRectGetMaxX(self.anchorFrame);
    CGFloat addressH =  KDUtilSize(UNIVERISITYSUBTITLEFONT);
    CGFloat addressW =  CONTENTWIDTH - addressX;
    CGFloat addressY =  anthorY + 5;
    self.address_detailFrame = CGRectMake(addressX, addressY, addressW, addressH);
    
    CGFloat RCh =50;
    CGFloat RCw = RCh;
    CGFloat RCx = XScreenWidth - RCh;
    CGFloat RCy = 0;
    self.hotFrame = CGRectMake(RCx,RCy, RCw ,RCh);
    
}


@end
