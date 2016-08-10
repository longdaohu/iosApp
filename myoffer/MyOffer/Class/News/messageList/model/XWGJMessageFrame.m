//
//  XWGJMessage.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJMessageFrame.h"
#import "XWGJMessage.h"

@implementation XWGJMessageFrame

 -(void)setMessage:(XWGJMessage *)Message
{
    _Message = Message;
    
    
    CGFloat Margin = 10;
    
    CGFloat  LGx = Margin;
    CGFloat  LGw = 90 * SCREEN_SCALE;
    CGFloat  LGh = 70 + KDUtilSize(0)*2;
    CGFloat  LGy = (100 + KDUtilSize(0)*2 -LGh) * 0.5;
    self.LogoFrame = CGRectMake(LGx, LGy, LGw, LGh);
    
    
    CGFloat  TTx =  CGRectGetMaxX(self.LogoFrame) + 10;
    CGFloat  TTy =  10;
    CGFloat  TTw =  APPSIZE.width - TTx;
    CGFloat TitleWidth = [Message.messageTitle KD_sizeWithAttributeFont:FontWithSize(KDUtilSize(16))].width;
    CGFloat TTh = TitleWidth - (APPSIZE.width - CGRectGetMaxX(self.LogoFrame) - 10) > 0 ? 50 : 25;
    self.TitleFrame = CGRectMake(TTx, TTy, TTw, TTh);
    
    
    CGFloat  TMw = 110 ;
    CGFloat  TMh = 15 ;
    CGFloat  TMy = CGRectGetMaxY(self.LogoFrame) - TMh;
    CGFloat  TMx=  APPSIZE.width - TMw;
    self.TimeFrame = CGRectMake(TMx,TMy, TMw, TMh);
    
    
    CGFloat  Fw = 80;
    CGFloat  Fh = 15;
    CGFloat  Fy = TMy;
    CGFloat  Fx=  TMx - Fw;
    self.FocusFrame = CGRectMake(Fx,Fy, Fw, Fh);

}
@end
