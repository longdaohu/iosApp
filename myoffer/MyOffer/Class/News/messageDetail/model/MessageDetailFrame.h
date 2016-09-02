//
//  MessageTitleObj.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDetailFrame : NSObject
@property(nonatomic,strong)NSDictionary *MessageDetail;
@property(nonatomic,assign)CGRect TagFrame;        //标签图片
@property(nonatomic,assign)CGRect TagLabFrame;     //标签名称
@property(nonatomic,assign)CGRect TagBgFrame;      //小标签背景
@property(nonatomic,assign)CGRect FirstLineFrame;  //分隔线1
@property(nonatomic,assign)CGRect SecondLineFrame; //分隔线2
@property(nonatomic,assign)CGRect TitleFrame;      //文章标题
@property(nonatomic,assign)CGRect LogoFrame;       //作者头像
@property(nonatomic,assign)CGRect ArthorFrame;     //作者名称
@property(nonatomic,assign)CGRect FocusFrame;      //关注数量
@property(nonatomic,assign)CGRect TimeFrame;       //发表时间
@property(nonatomic,assign)CGRect ArticleMVFrame;  //第一张大图
@property(nonatomic,assign)CGRect SummaryFrame;    //文章摘要
@property(nonatomic,assign)CGRect ThreeLineFrame;   //分隔线3
@property(nonatomic,assign)CGFloat MessageDetailHeight;   //detail高
@property(nonatomic,copy)NSString *TagImageName;

+ (instancetype)frameWithDictionary:(NSDictionary *)messageInfo;

@end
