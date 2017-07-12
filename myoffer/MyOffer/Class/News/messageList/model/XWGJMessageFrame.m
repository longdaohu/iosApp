//
//  XWGJMessage.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageFrame.h"
#import "MyOfferArticle.h"

@implementation XWGJMessageFrame

-(void)setNews:(MyOfferArticle *)News{

    _News = News;
    
    [self messageWithTitle:News.title];
}

- (void)messageWithTitle:(NSString *)title{
    
    CGFloat Margin = 10;
    
    CGFloat  logox = Margin;
    CGFloat  logow = 90 * SCREEN_SCALE;
    CGFloat  logoy = Margin;
    CGFloat  logoh = Uni_Cell_Height - 2 * logoy;
    self.LogoFrame = CGRectMake(logox,logoy,logow,logoh);
    
    
    CGFloat  titlex =  CGRectGetMaxX(self.LogoFrame) + 10;
    CGFloat  titley =  10;
    CGFloat  titlew =  XSCREEN_WIDTH - titlex;
    CGFloat  TitleWidth = [title KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(16))].width;
    CGFloat  titleh = TitleWidth - (XSCREEN_WIDTH - CGRectGetMaxX(self.LogoFrame) - 10) > 0 ? 50 : 25;
    self.TitleFrame = CGRectMake(titlex, titley, titlew, titleh);
    
    
    CGFloat  timew = 110 ;
    CGFloat  timeh = 15 ;
    CGFloat  timey = CGRectGetMaxY(self.LogoFrame) - timeh;
    CGFloat  timex = XSCREEN_WIDTH - timew;
    self.TimeFrame = CGRectMake(timex,timey, timew, timeh);
    
    CGFloat  focusw = 100;
    CGFloat  focush = 15;
    CGFloat  focusx = titlex;
    CGFloat  focusy = timey;
    self.FocusFrame = CGRectMake(focusx,focusy, focusw, focush);
    
    
    CGFloat  line_X = titlex;
    CGFloat  line_H = 0.5;
    CGFloat  line_Y = Uni_Cell_Height - line_H;
    CGFloat  line_W = XSCREEN_WIDTH;
    self.lineFrame= CGRectMake(line_X,line_Y, line_W, line_H);
    
    self.cell_Height = CGRectGetMaxY(self.lineFrame);

}


+(instancetype)messageFrameWithMessage:(MyOfferArticle *)message
{
    XWGJMessageFrame *messageFrame = [[XWGJMessageFrame alloc] init];
    messageFrame.News              = message;
    
    return messageFrame;
}

//+(instancetype)messageFrameWithNewMessage:(messgeNewModel *)message{
//
//    XWGJMessageFrame *messageFrame = [[XWGJMessageFrame alloc] init];
//    
//    messageFrame.message   = message;
//    
//    return messageFrame;
//}


//- (void)setMessage:(messgeNewModel *)message{
//
//    _message = message;
//    
//    [self messageWithTitle:message.title];
//    
//}



@end
