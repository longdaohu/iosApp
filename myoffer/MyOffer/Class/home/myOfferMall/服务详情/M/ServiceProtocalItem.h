//
//  ServiceProtocalItem.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ServiceProtocalItem : NSObject

@property(nonatomic,copy)NSString *detail;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)BOOL isClose;
@property(nonatomic,strong)WKWebView *web;
@end
