//
//  HotUniversityFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HotUniversityFrame.h"
#import "MyOfferUniversityModel.h"

@implementation HotUniversityFrame

+ (instancetype)frameWithUniversity:(NSDictionary *)uni_Info{

    HotUniversityFrame *uniFrame = [[HotUniversityFrame alloc] init];
    
    uniFrame.universtiy = [MyOfferUniversityModel mj_objectWithKeyValues:uni_Info];
    
    return uniFrame;
}

-(void)setUniverstiy:(MyOfferUniversityModel *)universtiy{

    _universtiy = universtiy;
    
    CGFloat Cellwidth = XSCREEN_WIDTH * 0.6;
    
    CGFloat bgx = 0;
    CGFloat bgy = 1;
    CGFloat bgw = Cellwidth - ITEM_MARGIN;
    
    CGFloat iconw  = bgw * 0.4;
    CGFloat iconh  = iconw;
    CGFloat iconx  = 0.5 *(bgw - iconw);
    CGFloat icony  = 20;
    self.LogoFrame = CGRectMake(iconx, icony, iconw,iconh);
    
    
    CGFloat namex    = 10;
    CGFloat namey    = CGRectGetMaxY(self.LogoFrame) +KDUtilSize(ITEM_MARGIN);
    CGFloat namew    = bgw - 15;
//    CGFloat nameh    = USER_EN ? KDUtilSize(40):KDUtilSize(18);
    CGFloat nameh    = KDUtilSize(18);
    self.nameFrame = CGRectMake(namex, namey,namew, nameh);
    
    CGFloat official_namex       = namex;
    CGFloat official_namey       = CGRectGetMaxY(self.nameFrame) + KDUtilSize(5);;
    CGFloat official_namew       = namew;
    CGFloat official_nameh       =  KDUtilSize(14);
    self.official_nameFrame = CGRectMake(official_namex, official_namey, official_namew, official_nameh);
    
    CGFloat lineh = 0.5;
    CGFloat linew = bgw;
    CGFloat linex = 0;
    CGFloat liney = CGRectGetMaxY(self.official_nameFrame) + KDUtilSize(ITEM_MARGIN);
    self.LineFrame = CGRectMake(linex, liney, linew,lineh);
    
    
    CGFloat anthorX = ITEM_MARGIN;
    CGFloat anthorY = CGRectGetMaxY(self.LineFrame) + KDUtilSize(ITEM_MARGIN );
    CGFloat anthorH = KDUtilSize(15);
    CGFloat anthorW = anthorH;
    self.anthorFrame  = CGRectMake(anthorX, anthorY, anthorW,anthorH);
    
    CGFloat addressX  = CGRectGetMaxX(self.anthorFrame) + 5;
    CGFloat addressY  = anthorY;
    CGFloat addressW  = namew - addressX;
    CGFloat addressH  = anthorH;
    self.addressFrame = CGRectMake(addressX, addressY, addressW, addressH);
    
    
    NSMutableArray *temps =[NSMutableArray array];
    
    CGFloat itemW = 0.5 * (bgw - 30);
    CGFloat itemH = 25.0;
    for (int i = 0; i < 4; i ++) {
        
        CGFloat itemX    = i%2 * (itemW + ITEM_MARGIN) + ITEM_MARGIN;
        CGFloat itemY    = i/2 * 30;
        CGRect itemRect  = CGRectMake(itemX, itemY, itemW, itemH);
        
        [temps addObject:[NSValue valueWithCGRect:itemRect]];
    }
    
    self.tagFrames = [temps copy];
    
    CGFloat tagViewx    = 0;
    CGFloat tagViewy    = CGRectGetMaxY(self.addressFrame) + KDUtilSize(ITEM_MARGIN);
    CGFloat tagVieww    = bgw;
    CGFloat tagViewh    = 55;
    self.tagsBgViewFrame = CGRectMake(tagViewx, tagViewy, tagVieww, tagViewh);
    
//    CGFloat bgh         =  USER_EN ? (CGRectGetMaxY(self.addressFrame) + ITEM_MARGIN) :(CGRectGetMaxY(self.tagsBgViewFrame) + ITEM_MARGIN);
    CGFloat bgh         =   (CGRectGetMaxY(self.tagsBgViewFrame) + ITEM_MARGIN);
    
    self.bgViewFrame    = CGRectMake(bgx,bgy,bgw,bgh);
    
    self.cellHeight     = CGRectGetMaxY(self.bgViewFrame) + 20;

}



@end
