//
//  ServiceSKUFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceSKUFrame.h"
#import "ServiceSKU.h"

@implementation ServiceSKUFrame

- (void)setSKU:(ServiceSKU *)SKU{

    _SKU = SKU;
  
    CGFloat Margin = 10;
    
    CGFloat    coverX = Margin;
    CGFloat    coverY = Margin;
    CGFloat    coverW = 90 * SCREEN_SCALE;
    CGFloat    coverH = coverW * 210 / 282.0;
    self.cover_Frame = CGRectMake(coverX, coverY, coverW, coverH);
    
    
    CGFloat    zheX = coverX;
    CGFloat    zheW = 29;
    CGFloat    zheY = coverY;
    CGFloat    zheH = zheW;
    self.zhe_Frame = CGRectMake(zheX, zheY, zheW, zheH);
    
    
    CGFloat    nameX = CGRectGetMaxX(self.cover_Frame) + Margin;
    CGFloat    nameW = XSCREEN_WIDTH - nameX - Margin;
    CGFloat    nameY = coverY;
    CGSize     nameSize = [SKU.name KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16]];
    CGFloat    nameH = nameSize.width > nameW ?  44 : 20;
    self.name_Frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat    priceX = nameX;
    CGFloat    priceW = 100;
    CGFloat    priceH = 18;
    CGFloat    priceY = CGRectGetMaxY(self.cover_Frame) - priceH;
    self.price_Frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    CGFloat    display_priceX = CGRectGetMaxX(self.price_Frame);
    CGFloat    display_priceW = 100;
    CGFloat    display_priceH = 13;
    CGFloat    display_priceY =  CGRectGetMaxY(self.cover_Frame) - display_priceH;
    self.display_price_Frame = CGRectMake(display_priceX, display_priceY, display_priceW, display_priceH);
    
    CGFloat    lineX = nameX;
    CGFloat    lineY = CGRectGetMaxY(self.cover_Frame) + Margin;
    CGFloat    lineW = XSCREEN_WIDTH - lineX;
    CGFloat    lineH = 1;
    
    
    if (SKU.comment_present) {
        
        CGFloat    present_KeyX = coverX;
        CGFloat    present_KeyW = 30;
        CGFloat    present_KeyH = present_KeyW;
        CGFloat    present_KeyY = CGRectGetMaxY(self.cover_Frame) + Margin;
        self.present_Key_Frame = CGRectMake(present_KeyX, present_KeyY, present_KeyW, present_KeyH);
 
        
        CGFloat    present_ValueX = CGRectGetMaxX(self.present_Key_Frame) + Margin;
        CGFloat    present_ValueW = XSCREEN_WIDTH - present_ValueX -Margin;
        NSString *value = SKU.comment_present[@"value"];
        CGSize     present_ValueSize =   [value boundingRectWithSize:CGSizeMake(present_ValueW, CGFLOAT_MAX)  options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil].size;
        CGFloat    present_ValueH = present_ValueSize.height < present_KeyH ? present_KeyH : present_ValueSize.height;
        CGFloat    present_ValueY = present_KeyY;
        self.present_Value_Frame = CGRectMake(present_ValueX, present_ValueY, present_ValueW, present_ValueH);
 
        lineX =  coverX;
        lineY =  CGRectGetMaxY(self.present_Value_Frame) + Margin;
        lineW =  XSCREEN_WIDTH - lineX;
     }
    
    self.line_Frame = CGRectMake(lineX, lineY, lineW, lineH);
    self.cell_Height = CGRectGetMaxY(self.line_Frame);
    
}

    

@end
