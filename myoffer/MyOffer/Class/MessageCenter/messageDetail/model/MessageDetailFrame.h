//
//  MessageTitleObj.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageArticle.h"

@interface MessageDetailFrame : NSObject
@property(nonatomic,strong)MessageArticle *article;
@property(nonatomic,assign)CGRect tag_title_Frame;//标签名称
@property(nonatomic,assign)CGRect tagBg_Frame;//小标签背景
@property(nonatomic,assign)CGRect first_line_frame;//分隔线1
@property(nonatomic,assign)CGRect second_line_frame;//分隔线2
@property(nonatomic,assign)CGRect title_Frame;//文章标题
@property(nonatomic,assign)CGRect icon_Frame;//作者头像
@property(nonatomic,assign)CGRect arthor_Frame;//作者名称
@property(nonatomic,assign)CGRect time_Frame;//发表时间
@property(nonatomic,assign)CGRect cover_Frame;//第一张大图
@property(nonatomic,assign)CGRect summary_frame;//文章摘要
@property(nonatomic,assign)CGRect third_line_frame;//分隔线3
@property(nonatomic,assign)CGRect header_frame;
@property(nonatomic,strong)NSArray *tag_frames;

+ (instancetype)frameWithArticle:(MessageArticle *)article;

@end
