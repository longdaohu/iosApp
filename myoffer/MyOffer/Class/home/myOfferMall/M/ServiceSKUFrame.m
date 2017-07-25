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

+ (instancetype)frameWithSKU:(ServiceSKU *)sku{
    
    ServiceSKUFrame *skuFrame = [[ServiceSKUFrame alloc] init];
    
    skuFrame.SKU = sku;
    
    return skuFrame;
}


- (void)setSKU:(ServiceSKU *)SKU{

    _SKU = SKU;
  
    CGFloat Margin = 10;
    
    //顶部top_line分隔线
    CGFloat    top_X = 0;
    CGFloat    top_Y = 0;
    CGFloat    top_W = XSCREEN_WIDTH;
    CGFloat    top_H = LINE_HEIGHT;
    self.top_line_Frame = CGRectMake(top_X, top_Y, top_W, top_H);
    
    //cover图片
    CGFloat    coverX = Margin;
    CGFloat    coverY = Margin;
    CGFloat    coverW = 90 * SCREEN_SCALE;
    CGFloat    coverH = coverW * 184 / 270.0;
    self.cover_Frame = CGRectMake(coverX, coverY, coverW, coverH);
    
    //折扣图片
    CGFloat    zheX = coverX;
    CGFloat    zheW = 29;
    CGFloat    zheY = coverY;
    CGFloat    zheH = zheW;
    self.zhe_Frame = CGRectMake(zheX, zheY, zheW, zheH);
    
    //名称
    CGFloat    nameX = CGRectGetMaxX(self.cover_Frame) + Margin;
    CGFloat    nameW = XSCREEN_WIDTH - nameX - Margin;
    CGFloat    nameY = coverY;
    CGSize     nameSize = [SKU.name KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16]];
    CGFloat    nameH = nameSize.width > nameW ?  44 : 20;
    self.name_Frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    //价格
    CGFloat    priceX = nameX;
    CGSize     priceSize = [SKU.price_str KD_sizeWithAttributeFont:[UIFont systemFontOfSize:18]];
    CGFloat    priceW = priceSize.width  > 100 ? priceSize.width: 100;
    CGFloat    priceH = 18;
    CGFloat    priceY = CGRectGetMaxY(self.cover_Frame) - priceH;
    self.price_Frame = CGRectMake(priceX, priceY, priceW, priceH);
    
    //原价格
    CGFloat    display_priceX = CGRectGetMaxX(self.price_Frame);
    CGFloat    display_priceW = 100;
    CGFloat    display_priceH = 13;
    CGFloat    display_priceY =  CGRectGetMaxY(self.cover_Frame) - display_priceH;
    self.display_price_Frame = CGRectMake(display_priceX, display_priceY, display_priceW, display_priceH);
    
    //分隔线
    CGFloat    lineX = nameX;
    CGFloat    lineY = CGRectGetMaxY(self.cover_Frame) + Margin;
    CGFloat    lineW = XSCREEN_WIDTH - lineX;
    CGFloat    lineH = LINE_HEIGHT;
    
    
    if (SKU.comment_present) {
        
        //赠送图片
        CGFloat    present_KeyX = coverX;
        CGFloat    present_KeyW = 30;
        CGFloat    present_KeyH = present_KeyW;
        CGFloat    present_KeyY = CGRectGetMaxY(self.cover_Frame) + Margin;
        self.present_Key_Frame = CGRectMake(present_KeyX, present_KeyY, present_KeyW, present_KeyH);
 
        //赠送描述
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
    
    //底部分隔线
    self.line_Frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    //cell高度
    self.cell_Height = CGRectGetMaxY(self.line_Frame);
    
}

    

@end
