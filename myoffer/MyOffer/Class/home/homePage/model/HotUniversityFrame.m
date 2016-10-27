//
//  HotUniversityFrame.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HotUniversityFrame.h"
#import "UniversityNew.h"

@implementation HotUniversityFrame

+ (instancetype)frameWithUniversity:(NSDictionary *)uni_Info{

    HotUniversityFrame *uniFrame = [[HotUniversityFrame alloc] init];
    
    UniversityNew *uni = [UniversityNew mj_objectWithKeyValues:uni_Info];
    
    uniFrame.uni = uni;
    
    return uniFrame;
}


-(void)setUni:(UniversityNew *)uni{

    _uni = uni;
    
    CGFloat Cellwidth = XScreenWidth * 0.6;
    
    CGFloat bgx = 0;
    CGFloat bgy = ITEM_MARGIN;
    CGFloat bgw = Cellwidth - ITEM_MARGIN;
    
    CGFloat iconw  = bgw * 0.4;
    CGFloat iconh  = iconw;
    CGFloat iconx  = 0.5 *(bgw - iconw);
    CGFloat icony  = 20;
    self.LogoFrame = CGRectMake(iconx, icony, iconw,iconh);
    
    
    CGFloat unix    = 10;
    CGFloat uniy    = CGRectGetMaxY(self.LogoFrame) +KDUtilSize(ITEM_MARGIN);
    CGFloat uniw    = bgw - 15;
    CGFloat unih    = USER_EN ? KDUtilSize(40):KDUtilSize(18);
    self.TitleFrame = CGRectMake(unix, uniy,uniw, unih);
    
    CGFloat engx       = unix;
    CGFloat engy       = CGRectGetMaxY(self.TitleFrame) + KDUtilSize(5);;
    CGFloat engw       = uniw;
    CGFloat engh       =  KDUtilSize(14);
    self.SubTitleFrame = CGRectMake(engx, engy, engw, engh);
    
    CGFloat lineh = 0.5;
    CGFloat linew = bgw;
    CGFloat linex = 0;
    CGFloat liney = CGRectGetMaxY(self.SubTitleFrame) + KDUtilSize(ITEM_MARGIN);
    if (USER_EN) {
        
        liney = CGRectGetMaxY(self.TitleFrame) + KDUtilSize(ITEM_MARGIN);
    }
    self.LineFrame = CGRectMake(linex, liney, linew,lineh);
    
    
    CGFloat localViewX = ITEM_MARGIN;
    CGFloat localViewY = CGRectGetMaxY(self.LineFrame) + KDUtilSize(ITEM_MARGIN );
    CGFloat localViewH = KDUtilSize(15);
    CGFloat localViewW = localViewH;
    self.LocalMVFrame  = CGRectMake(localViewX, localViewY, localViewW,localViewH);
    
    CGFloat localX  = CGRectGetMaxX(self.LocalMVFrame) + 5;
    CGFloat localY  = localViewY;
    CGFloat localW  = uniw - localX;
    CGFloat localH  = localViewH;
    self.LocalFrame = CGRectMake(localX, localY, localW, localH);
    
    
    
    NSMutableArray *temps =[NSMutableArray array];
    
    CGFloat itemW = 0.5 * (bgw - 30);
    CGFloat itemH = 25.0;
    for (int i = 0; i < 4; i ++) {
        
        CGFloat itemX    = i%2 * (itemW + ITEM_MARGIN) + ITEM_MARGIN;
        CGFloat itemY    = i/2 * 30;
        
        CGRect itemRect  = CGRectMake(itemX, itemY, itemW, itemH);
        
        [temps addObject:[NSValue valueWithCGRect:itemRect]];
    }
    
    self.tapFrames = [temps copy];
    
    CGFloat tapViewx    = 0;
    CGFloat tapViewy    = CGRectGetMaxY(self.LocalFrame) + KDUtilSize(ITEM_MARGIN);
    CGFloat tapVieww    = bgw;
    CGFloat tapViewh    = 55;
    self.tapBgViewFrame = CGRectMake(tapViewx, tapViewy, tapVieww, tapViewh);
    
    CGFloat bgh         =  USER_EN ? (CGRectGetMaxY(self.LocalFrame) + ITEM_MARGIN) :(CGRectGetMaxY(self.tapBgViewFrame) + ITEM_MARGIN);
    
    self.bgViewFrame    = CGRectMake(bgx,bgy,bgw,bgh);
    
    self.cellHeight     = CGRectGetMaxY(self.bgViewFrame) + 20;

}

@end
