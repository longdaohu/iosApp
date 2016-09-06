//
//  UniversityNewFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import "UniversityNewFrame.h"
#define  CONTENTWIDTH   XScreenWidth - 2 * XMARGIN

@interface UniversityNewFrame ()
@end

@implementation UniversityNewFrame
+ (instancetype)frameWithUniversity:(UniversitydetailNew *)university{

    UniversityNewFrame *UniFrame = [[UniversityNewFrame alloc] init];
    UniFrame.item = university;
    
    return UniFrame;
}



-(void)setItem:(UniversitydetailNew *)item{
    
    _item = item;
    
    
    CGFloat logoX = XMARGIN;
    CGFloat logoY = XMARGIN  * 2;
    CGFloat logoW = XPERCENT * 80;
    CGFloat logoH = logoW;
    self.logoFrame = CGRectMake(logoX, logoY, logoW, logoH);
    
    
    CGFloat nameX = CGRectGetMaxX(self.logoFrame) + XMARGIN;
    CGFloat nameY = logoY;
    CGFloat nameW = CONTENTWIDTH - nameX;
    CGFloat nameH = XPERCENT * 16;
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    
    CGFloat officialX = nameX;
    CGFloat officialY = CGRectGetMaxY(self.nameFrame);
    CGFloat officialW = nameW;
    CGFloat officialHeigh   = [self.item.official_name KD_sizeWithAttributeFont:XFONT(XPERCENT * 11)  maxWidth:officialW].height;
    CGFloat officialH = officialHeigh;
    self.official_nameFrame = CGRectMake(officialX, officialY, officialW, officialH);
    
    
    
    CGFloat webX = nameX;
    CGFloat webW = nameW - 5;
    CGFloat webH =  XPERCENT * 12;
    CGFloat webY = CGRectGetMaxY(self.logoFrame) - webH;
    self.websiteFrame = CGRectMake(webX, webY, webW, webH);
    
    
    CGFloat addressX = nameX;
    CGFloat addressW = nameW;
    CGFloat addressH =  XPERCENT * 12;
    CGFloat addressY = CGRectGetMaxY(self.official_nameFrame) + 0.5 * (webY - CGRectGetMaxY(self.official_nameFrame) - addressH);
    self.address_detailFrame = CGRectMake(addressX,addressY,addressW,addressH);
    
    
    CGFloat dataX = 2 * XMARGIN;
    CGFloat dataY = CGRectGetMaxY(self.logoFrame) + 2 * XMARGIN;
    CGFloat dataW =  CONTENTWIDTH - 2 * dataX;
    CGFloat dataH =  XPERCENT * 140;
    self.dataViewFrame = CGRectMake(dataX, dataY, dataW, dataH);
    
    
    CGFloat lineX = XMARGIN;
    CGFloat lineY = CGRectGetMaxY(self.dataViewFrame) + 2 * XMARGIN;
    CGFloat lineW =  CONTENTWIDTH - 2 * lineX;
    CGFloat lineH =  1;
    self.lineFrame = CGRectMake(lineX, lineY, lineW, lineH);
    
    
    CGFloat introX = XMARGIN;
    CGFloat introY = CGRectGetMaxY(self.lineFrame) +   XMARGIN;
    CGFloat introW = CONTENTWIDTH - 2 * introX;
    CGFloat introductionHeight = [self.item.introduction KD_sizeWithAttributeFont:XFONT(XPERCENT * 12) maxWidth:introW].height;
    CGFloat introH = introductionHeight;
    self.introductionFrame= CGRectMake(introX, introY, introW, introH);
    
    
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat upW = XScreenWidth;
    CGFloat upH =  XPERCENT * 200;
    self.upViewFrame= CGRectMake(upX, upY, upW, upH);
    
    CGFloat tag2X = 0;
    CGFloat tag2W = XScreenWidth;
    CGFloat tag2H = XPERCENT * 13;
    CGFloat tag2Y = upH -  60 - tag2H;
    self.tagsTwoFrame= CGRectMake(tag2X, tag2Y, tag2W, tag2H);
    
    
    CGFloat tag1H = tag2H;
    CGFloat tag1X = tag2X;
    CGFloat tag1Y = tag2Y - tag1H  -  5;
    CGFloat tag1W = XScreenWidth;
    self.tagsOneFrame= CGRectMake(tag1X, tag1Y, tag1W, tag1H);
    
    
    CGFloat QSRankW = [@"全球QS排名" KD_sizeWithAttributeFont:XFONT(XPERCENT * 13)].width + 5;
    CGFloat QSRankH = XPERCENT * 13 * 3;
    CGFloat QSRankX = 0.5 * (XScreenWidth - 2 * QSRankW - 2 * XMARGIN);
    CGFloat QSRankY =  tag1Y - QSRankH - XMARGIN;
    
    
    CGFloat TIMESRankX = QSRankX + QSRankW + 2 * XMARGIN;
    CGFloat TIMESRankY = QSRankY;
    CGFloat TIMESRankH = XPERCENT * 13 * 3;
    CGFloat TIMESRankW = QSRankW;
    self.QSRankFrame= CGRectMake(QSRankX, QSRankY, QSRankW, QSRankH);
    self.TIMESRankFrame= CGRectMake(TIMESRankX, TIMESRankY, TIMESRankW, TIMESRankH);

    
    [self updateCenterViewFrame:item];
    
    
    CGFloat rightW =  80  +  XMARGIN;
    CGFloat rightH =  40;
    CGFloat rightX =  XScreenWidth - rightW - 2 * XMARGIN;
    CGFloat rightY = self.centerViewFrame.origin.y - 0.5 * rightH;
    self.rightViewFrame= CGRectMake(rightX, rightY, rightW, rightH);
    
    
    [self oneSectonWithUni:item];
    
}


- (void)updateCenterViewFrame:(UniversitydetailNew *)item{


    CGFloat moreH = XPERCENT * 40;
    
    
    CGFloat realHeight = self.showMore ?  (CGRectGetMaxY(self.introductionFrame) + moreH + 10) : (CGRectGetMinY(self.introductionFrame) +  100 + moreH );
    if(CGRectGetHeight(self.introductionFrame) <= 100){
        realHeight = CGRectGetMaxY(self.introductionFrame) + 10;
    }
    
    self.centerHeigh = realHeight;
    
    
    CGFloat moreY = self.centerHeigh -  moreH;
    CGFloat moreW = XPERCENT * 100;
    CGFloat moreX =  0.5 * (CONTENTWIDTH - moreW);
    CGRect moreNewFrame = self.moreFrame;
    moreNewFrame.size.height = (CGRectGetHeight(self.introductionFrame) <= 100) ? 0 : moreH;
    moreNewFrame.size.width  = moreW;
    moreNewFrame.origin.x    = moreX;
    moreNewFrame.origin.y    = moreY;
    self.moreFrame = moreNewFrame;

    
    CGFloat downX = 0;
    CGFloat downY = self.upViewFrame.size.height;
    CGFloat downW = self.upViewFrame.size.width;
    CGFloat downH = self.centerHeigh - 20;
    CGRect downViewNewFrame = self.downViewFrame;
    downViewNewFrame.size.height =  downH;
    downViewNewFrame.size.width  = downW;
    downViewNewFrame.origin.x    = downX;
    downViewNewFrame.origin.y    = downY;
    self.downViewFrame = downViewNewFrame;
    
    
    CGFloat gradientH = moreH + 10;
    CGFloat gradientY = moreY - 10;
    CGFloat gradientW = CONTENTWIDTH;
    CGFloat gradientX = 0;
    CGRect gradientNewRect = self.gradientBgViewFrame;
 
    gradientNewRect.size.height =  (CGRectGetHeight(self.introductionFrame) <= 100) ? 0 : gradientH;
    gradientNewRect.size.width  = gradientW;
    gradientNewRect.origin.x    = gradientX;
    gradientNewRect.origin.y    = gradientY;
    self.gradientBgViewFrame    = gradientNewRect;
    
    
    CGRect centerViewNewFrame = self.centerViewFrame;
    centerViewNewFrame.size.height =  self.centerHeigh;
    centerViewNewFrame.size.width  = XScreenWidth  - 2 * XMARGIN;
    centerViewNewFrame.origin.x    = XMARGIN;
    centerViewNewFrame.origin.y    = downY - 40;
    self.centerViewFrame =  centerViewNewFrame;
    
    
    CGRect headerNewRect = self.headerFrame;
    headerNewRect.size.height =  CGRectGetMaxY(self.downViewFrame);
    headerNewRect.size.width  = XScreenWidth;
    headerNewRect.origin.x    = 0;
    headerNewRect.origin.y    = 64;
    self.headerFrame = headerNewRect;
    
}


-(void)setShowMore:(BOOL)showMore{

    _showMore = showMore;
    
    [self updateCenterViewFrame:self.item];
    
}



-(void)oneSectonWithUni:(UniversitydetailNew *)item{
    
    _item = item;
    
    CGFloat fenguanX = 0;
    CGFloat fenguanY = XMARGIN * 2;
    CGFloat fenguanW = XScreenWidth;
    CGFloat fenguanH = 20;
    self.fenguanFrame = CGRectMake(fenguanX, fenguanY, fenguanW, fenguanH);
    
    
    CGFloat collectionX = 0;
    CGFloat collectionY = CGRectGetMaxY(self.fenguanFrame) + XMARGIN;
    CGFloat collectionW = XScreenWidth;
    CGFloat collectionH = XPERCENT * 100;
    self.collectionViewFrame = CGRectMake(collectionX, collectionY, collectionW, collectionH);
    
    
    CGFloat lineOneX = 10;
    CGFloat lineOneY = CGRectGetMaxY(self.collectionViewFrame) + XMARGIN;
    CGFloat lineOneW = XScreenWidth - 20;
    CGFloat lineOneH = 1;
    self.lineOneFrame = CGRectMake(lineOneX, lineOneY, lineOneW, lineOneH);
    
    
    CGFloat keyX = 0;
    CGFloat keyY = CGRectGetMaxY(self.lineOneFrame) + XMARGIN * 2;
    CGFloat keyW = XScreenWidth;
    CGFloat keyH = fenguanH;
    self.keyFrame = CGRectMake(keyX, keyY, keyW, keyH);
    
    
    [self makeButtonItems:item.key_subjectArea];
    
    
    CGFloat lineTwoX = lineOneX;
    CGFloat lineTwoY = CGRectGetMaxY(self.subjectBgFrame) + XMARGIN;
    CGFloat lineTwoW = lineOneW;
    CGFloat lineTwoH = lineOneH;
    self.lineTwoFrame = CGRectMake(lineTwoX, lineTwoY, lineTwoW, lineTwoH);
    
    
    CGFloat rankX = 0;
    CGFloat rankY = CGRectGetMaxY(self.lineTwoFrame) + XMARGIN * 2;
    CGFloat rankW = lineOneW;
    CGFloat rankH = fenguanH;
    self.rankFrame = CGRectMake(rankX, rankY, rankW, rankH);
    
    
    CGFloat selectX = 0;
    CGFloat selectY = CGRectGetMaxY(self.rankFrame) + XMARGIN;
    CGFloat selectW = XScreenWidth;
    CGFloat selectH = 30;
    self.selectionFrame = CGRectMake(selectX, selectY, selectW, selectH);
    
    CGFloat h_lineX = XScreenWidth * 0.5;
    CGFloat h_lineY = 0;
    CGFloat h_lineW = 1;
    CGFloat h_lineH = selectH;
    self.historyLineFrame = CGRectMake(h_lineX, h_lineY, h_lineW, h_lineH);
    
    CGFloat qsY = 0;
    CGFloat qsW = [@"QS世界排名" KD_sizeWithAttributeFont:XFONT(15)].width + 10;
    CGFloat qsH = selectH;
    CGFloat qsX = h_lineX - XMARGIN - qsW;
    
    CGFloat timesY = 0;
    CGFloat timesW = [@"TIMES排名" KD_sizeWithAttributeFont:XFONT(15)].width + 10;
    CGFloat timesH = selectH;
    CGFloat timesX = h_lineX + XMARGIN;
    if([item.country containsString:@"澳"]){
        qsX      = 0.5 * (XScreenWidth -  qsW);
        timesX   =   XScreenWidth;
        h_lineX  = XScreenWidth;
    }
    self.historyLineFrame = CGRectMake(h_lineX, h_lineY, h_lineW, h_lineH);
    self.qsFrame = CGRectMake(qsX, qsY, qsW, qsH);
    self.timesFrame = CGRectMake(timesX, timesY, timesW, timesH);
    
    
    CGFloat chartY =   CGRectGetMaxY(self.selectionFrame) + XMARGIN;
    CGFloat chartW = XScreenWidth -20;
    CGFloat chartH = 150;
    CGFloat chartX = 5;
    self.chartViewBgFrame = CGRectMake(chartX, chartY, chartW, chartH);
    
    
    self.contentHeight = CGRectGetMaxY(self.chartViewBgFrame) + 2 * XMARGIN;
    
}



-(void)makeButtonItems:(NSArray *)items
{
    NSMutableArray *temps =[NSMutableArray array];
    
    //第一个 label的起点
    CGSize startPoint = CGSizeMake(0, 0);
    //间距
    CGFloat padding = 15.0;
    
    CGFloat MAXWidth = XScreenWidth - 2 * XMARGIN;
    
    CGFloat itemH = XPERCENT * 14   + 10;
    
    for (int i = 0; i < items.count; i ++) {
        
        CGSize itemSize =[items[i] KD_sizeWithAttributeFont:XFONT(XPERCENT * 14)];
        
        CGFloat keyWordWidth = itemSize.width + 30;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        
        
        if (MAXWidth - startPoint.width < keyWordWidth) {
            
            startPoint.width = 0;
            
            startPoint.height += (itemH + XMARGIN);
            
        }
        
        CGFloat itemX = startPoint.width;
        CGFloat itemW = keyWordWidth;
        CGFloat itemY = startPoint.height;
        CGRect itemRect = CGRectMake(itemX, itemY, itemW, itemH);
        
        [temps addObject:[NSNumber valueWithCGRect:itemRect]];
        
        //起点 增加
        startPoint.width += keyWordWidth + padding;
        
    }
    
    self.subjectItemFrames = [temps copy];
    
    CGFloat bgH  = startPoint.height + itemH;
    CGFloat bgX  = XMARGIN;
    CGFloat bgY  = CGRectGetMaxY(self.keyFrame) + XMARGIN;
    CGFloat bgW  = MAXWidth;
    self.subjectBgFrame = CGRectMake(bgX, bgY, bgW, bgH);
  
    
    
}





@end
