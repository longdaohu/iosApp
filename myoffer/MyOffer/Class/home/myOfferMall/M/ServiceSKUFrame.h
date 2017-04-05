//
//  ServiceSKUFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServiceSKU;
@interface ServiceSKUFrame : NSObject
@property(nonatomic,strong)ServiceSKU *SKU;
@property(nonatomic,assign)CGRect   top_line_Frame;
@property(nonatomic,assign)CGRect   name_Frame;
@property(nonatomic,assign)CGRect   zhe_Frame;
@property(nonatomic,assign)CGRect   cover_Frame;
@property(nonatomic,assign)CGRect   price_Frame;
@property(nonatomic,assign)CGRect   display_price_Frame;
@property(nonatomic,assign)CGRect   present_Value_Frame;
@property(nonatomic,assign)CGRect   present_Key_Frame;
@property(nonatomic,assign)CGRect   line_Frame;
@property(nonatomic,assign)CGFloat   cell_Height;

@end
