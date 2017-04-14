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
@property(nonatomic,assign)CGRect catigory_logo_Frame;        //标签图片
@property(nonatomic,assign)CGRect tag_title_Frame;     //标签名称
@property(nonatomic,assign)CGRect tagBg_Frame;      //小标签背景
@property(nonatomic,assign)CGRect FirstLineFrame;  //分隔线1
@property(nonatomic,assign)CGRect SecondLineFrame; //分隔线2
@property(nonatomic,assign)CGRect title_Frame;      //文章标题
@property(nonatomic,assign)CGRect icon_Frame;       //作者头像
@property(nonatomic,assign)CGRect Arthor_Frame;     //作者名称
@property(nonatomic,assign)CGRect focus_Frame;      //关注数量
@property(nonatomic,assign)CGRect time_Frame;       //发表时间
@property(nonatomic,assign)CGRect cover_Frame;  //第一张大图
@property(nonatomic,assign)CGRect Summary_Frame;    //文章摘要
@property(nonatomic,assign)CGRect ThreeLineFrame;   //分隔线3
@property(nonatomic,assign)CGFloat MessageDetailHeight;   //detail高
@property(nonatomic,copy)NSString *TagImageName;

+ (instancetype)frameWithArticle:(MessageArticle *)article;

@end
