//
//  ServiceItemFrame.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/29.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemFrame.h"

@implementation ServiceItemFrame
- (void)setItem:(ServiceItem *)item{
    
    _item = item;
    
    CGFloat margin_small  = 10;
    CGFloat margin_big  = 15;
    
    CGFloat headerX = margin_small;
    CGFloat headerY = 0;
    CGFloat headerW = XSCREEN_WIDTH;
    CGFloat headerH = 0;
    
    CGFloat header_conentent_X = margin_small;
    CGFloat header_conentent_Y = 0;
    CGFloat header_conentent_W = headerW - header_conentent_X * 2;
    
    //1、服务名称
    CGFloat nameX = margin_small;
    CGFloat nameY = margin_small * 2;
    CGFloat nameW = header_conentent_W - nameX * 2;
    CGSize  nameSize = [self contentSizeWithString:item.name MaxWidth:nameW fontSize:18];
    CGFloat nameH = nameSize.height;
    self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    //2、价格名称
    CGFloat priceX = nameX;
    CGFloat priceY = margin_small + CGRectGetMaxY(self.nameFrame);
    NSString *price  =  [NSString stringWithFormat:@"￥ %@",item.price];
    CGSize  priceSize = [price KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16]];
    CGFloat priceW = priceSize.width + margin_small;
    CGFloat priceH = priceSize.height;
    self.priceFrame = CGRectMake(priceX, priceY, priceW, priceH);
    
    // 3原价
    CGFloat display_priceH = 13;
    CGFloat display_priceX = CGRectGetMaxX(self.priceFrame);
    CGFloat display_priceY = priceY + priceH - display_priceH;
    CGFloat display_priceW = 100;
    self.display_priceFrame = CGRectMake(display_priceX, display_priceY, display_priceW, display_priceH);
    
    // 4 分隔线1
    CGFloat first_lineX = nameX;
    CGFloat first_lineY = margin_small + CGRectGetMaxY(self.priceFrame);
    CGFloat first_lineW = nameW;
    CGFloat first_lineH = 1;
    self.firstlineFrame= CGRectMake(first_lineX, first_lineY, first_lineW, first_lineH);
    
    
    //计算数组子项Frame
    CGFloat cellTitleHeight = 20;
    NSArray *country_Options = item.country_Attibute ?  item.country_Attibute[@"options"] : @[];
    //4、国家
    CGFloat countryX = nameX;
    CGFloat countryY = CGRectGetMaxY(self.firstlineFrame);
    CGFloat countryW = nameW;
    CGFloat countryH = 0;
    if (country_Options.count > 0) {
        
        countryY += margin_big;
        countryH = cellTitleHeight;
    }
    self.countryFrame = CGRectMake(countryX, countryY, countryW, countryH);
   //5、国家子项
    CGFloat countrybgX = nameX;
    CGFloat countrybgY = CGRectGetMaxY(self.countryFrame);
    CGFloat countrybgW = nameW;
    CGFloat countrybgH = 0;
    
    //计算数组子项Frame
    if (country_Options.count > 0) {
        
        countrybgY += margin_big;
        
        self.countryItemFrames = [self frameWithOptions: country_Options];
        NSValue *lastValue =  self.countryItemFrames.lastObject;
        countrybgH =  CGRectGetMaxY([lastValue CGRectValue]);
        
    }
    self.countryBgFrame= CGRectMake(countrybgX, countrybgY, countrybgW, countrybgH);

    
    
    NSArray *serviceType_Options = item.serviceType_Attibute ?  item.serviceType_Attibute[@"options"] : @[];
   //6、类型
    CGFloat serviceTypeX = nameX;
    CGFloat serviceTypeY = CGRectGetMaxY(self.countryBgFrame);
    CGFloat serviceTypeW = nameW;
    CGFloat serviceTypeH = 0;
    if (serviceType_Options.count > 0) {
        
        serviceTypeY += margin_big;
        serviceTypeH = cellTitleHeight;
    }
    self.serviceTypeFrame= CGRectMake(serviceTypeX, serviceTypeY, serviceTypeW, serviceTypeH);
    
    //7、类型子项
    CGFloat serviceTypeBgX = nameX;
    CGFloat serviceTypeBgY = CGRectGetMaxY(self.serviceTypeFrame);
    CGFloat serviceTypeBgW = nameW;
    CGFloat serviceTypeBgH = 0;
    
    //计算数组子项Frame
    if (serviceType_Options.count > 0) {
        
        serviceTypeBgY += margin_big;
        self.serviceItemFrames = [self frameWithOptions: serviceType_Options];
        NSValue *lastValue =  self.serviceItemFrames.lastObject;
        serviceTypeBgH =  CGRectGetMaxY([lastValue CGRectValue]);
    }
    self.serviceTypeBgFrame= CGRectMake(serviceTypeBgX, serviceTypeBgY, serviceTypeBgW, serviceTypeBgH);
    
    //8、分隔线
    CGFloat sec_lineX = nameX;
    CGFloat sec_lineY = CGRectGetMaxY(self.serviceTypeBgFrame);
    CGFloat sec_lineW = first_lineW;
    CGFloat sec_lineH = 0;
    if (item.peopleDisc.length > 0  && item.presentDisc.length > 0) {
        sec_lineY += margin_big;
        sec_lineH  = first_lineH;
    }
    self.secondFrame= CGRectMake(sec_lineX, sec_lineY, sec_lineW, sec_lineH);
    
   //  9、适合人群
    CGFloat peopleX = nameX;
    CGFloat peopleY = CGRectGetMaxY(self.secondFrame);
    CGFloat peopleW = nameW;
    CGFloat peopleH = 0;
    if (item.presentDisc.length > 0) {
        peopleY += margin_big;
        peopleH = cellTitleHeight;
    }
    
    self.peopleFrame= CGRectMake(peopleX, peopleY, peopleW, peopleH);
    
    //  9、适合人群描述
    CGFloat people_d_X = nameX;
    CGFloat people_d_Y = CGRectGetMaxY(self.peopleFrame);
    CGFloat people_d_W = nameW;
    CGFloat people_d_H = 0;
    
    if (item.presentDisc.length > 0) {
        people_d_Y += margin_big;
        
        CGSize present_Size = [self contentSizeWithString:item.peopleDisc MaxWidth:nameW fontSize:12];
        people_d_H = present_Size.height;
    }
    self.personDisc_Frame = CGRectMake(people_d_X, people_d_Y, people_d_W, people_d_H);
      //10、分隔线
    CGFloat third_line_X = nameX;
    CGFloat third_line_Y = CGRectGetMaxY(self.personDisc_Frame);
    CGFloat third_line_W = first_lineW;
    CGFloat sthird_line_H = 0;
    if (item.presentDisc.length > 0) {
        
        third_line_Y += margin_big;
        sthird_line_H = first_lineH;
    }
    self.thirdFrame= CGRectMake(third_line_X, third_line_Y, third_line_W, sthird_line_H);
    
    
    //  11、买赠
    CGFloat present_X = nameX;
    CGFloat present_Y = CGRectGetMaxY(self.thirdFrame);
    CGFloat present_W = nameW;
    CGFloat present_H = 0;
    if (item.presentDisc.length > 0) {
       
        present_Y += margin_big;
        present_H = cellTitleHeight;
    }
    self.presentFrame= CGRectMake(present_X, present_Y, present_W, present_H);
    
    //  12、买赠描述
    CGFloat present_disc_X = nameX;
    CGFloat present_disc_Y = CGRectGetMaxY(self.presentFrame);
    CGFloat present_disc_W = nameW;
    CGFloat present_disc_H = 0;
    if (item.presentDisc.length > 0) {
        
        present_disc_Y += margin_big;
        
        CGSize  present_disc_Size = [self contentSizeWithString:item.presentDisc MaxWidth:nameW fontSize:12];
        present_disc_H = present_disc_Size.height;
    }
    self.presentDisc_Frame= CGRectMake(present_disc_X, present_disc_Y, present_disc_W, present_disc_H);
    
 
    
    //header中间显示内容区域
    CGFloat header_conentent_H = CGRectGetMaxY(self.presentDisc_Frame) + margin_small * 2;
    self.header_BgViewFrame =  CGRectMake( header_conentent_X, header_conentent_Y, header_conentent_W, header_conentent_H);
    
    
    //headerFrame
    headerH =  CGRectGetMaxY(self.header_BgViewFrame) + margin_small;
    self.headerViewFrame = CGRectMake( headerX, headerY, headerW, headerH);
    
    
    //底部View用于显示底色
    CGFloat header_bottom_X = 0;
    CGFloat header_bottom_Y = 60;
    CGFloat header_bottom_W = headerW;
    CGFloat header_bottom_H = headerH - header_bottom_Y;
    self.header_bottomView_Frame = CGRectMake(header_bottom_X, header_bottom_Y, header_bottom_W, header_bottom_H);
    
    
}


- (CGSize)contentSizeWithString:(NSString *)str MaxWidth:(CGFloat)maxWidth fontSize:(CGFloat)fontSize{
    
    return [str boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}




- (NSArray *)frameWithOptions:(NSArray *)options{

    NSMutableArray *temp_Arr = [NSMutableArray array];
    
    //第一个 label的起点
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat itemW = 0;
    CGFloat itemH = 40;
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = self.nameFrame.size.width;
    
    CGFloat MinWidth =  self.nameFrame.size.width * 0.25;
    
    for (int i = 0; i < options.count; i ++) {
        
       
        NSDictionary *option = options[i];
        
        itemW = [option[@"value"]  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:16]].width + padding;
        
        itemW = itemW <  MinWidth ? MinWidth : itemW;
        
        itemW = itemW > MAXWidth ? MAXWidth : itemW;
        
        if (MAXWidth - itemX < itemW) {
            
            itemY += (itemH + padding);
            
            itemX = 0;
        }
        
 
        CGRect  optionFrame =  CGRectMake(itemX, itemY, itemW, itemH);
        
        [temp_Arr addObject:[NSValue valueWithCGRect:optionFrame]];
        
        itemX += (itemW + padding);   //起点 增加
 
    }
    
    
    return  [temp_Arr copy];
}


@end
