//
//  XWGJMessage.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageFrame.h"
#import "NewsItem.h"

@implementation XWGJMessageFrame

-(void)setNews:(NewsItem *)News{

    _News = News;
    
    CGFloat Margin = 10;
    
    CGFloat  logox = Margin;
    CGFloat  logow = 90 * SCREEN_SCALE;
    CGFloat  logoy = Margin;
    CGFloat  logoh = University_HEIGHT - 2 * logoy;
    self.LogoFrame = CGRectMake(logox,logoy,logow,logoh);
    
    
    CGFloat  titlex =  CGRectGetMaxX(self.LogoFrame) + 10;
    CGFloat  titley =  10;
    CGFloat  titlew =  XScreenWidth - titlex;
    CGFloat  TitleWidth = [News.messageTitle KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(16))].width;
    CGFloat  titleh = TitleWidth - (XScreenWidth - CGRectGetMaxX(self.LogoFrame) - 10) > 0 ? 50 : 25;
    self.TitleFrame = CGRectMake(titlex, titley, titlew, titleh);
    
    
    
    CGFloat  timew = 110 ;
    CGFloat  timeh = 15 ;
    CGFloat  timey = CGRectGetMaxY(self.LogoFrame) - timeh;
    CGFloat  timex = XScreenWidth - timew;
    self.TimeFrame = CGRectMake(timex,timey, timew, timeh);
    
    CGFloat  focusw = 100;
    CGFloat  focush = 15;
    CGFloat  focusx = titlex;
    CGFloat  focusy = timey;
    self.FocusFrame = CGRectMake(focusx,focusy, focusw, focush);


    
}
+(instancetype)messageFrameWithMessage:(NewsItem *)message
{
    XWGJMessageFrame *messageFrame = [[XWGJMessageFrame alloc] init];
    messageFrame.News              = message;
    
    return messageFrame;
}


@end
