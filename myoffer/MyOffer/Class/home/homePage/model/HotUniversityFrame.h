//
//  HotUniversityFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyOfferUniversityModel;
@interface HotUniversityFrame : NSObject
//背景
@property(nonatomic,assign)CGRect  bgViewFrame;
//LOGO图片
@property(nonatomic,assign)CGRect  LogoFrame;
//学校名称
@property(nonatomic,assign)CGRect  nameFrame;
//主要显示英文学校名称
@property(nonatomic,assign)CGRect  official_nameFrame;
//分隔线
@property(nonatomic,assign)CGRect  LineFrame;
//地理位置
@property(nonatomic,assign)CGRect  addressFrame;
//地理图标
@property(nonatomic,assign)CGRect  anthorFrame;
//用于显示 星号图标
@property(nonatomic,assign)CGRect  starBgFrame;
//星星数组
@property(nonatomic,strong)NSArray *starFrames;
//标签背景
@property(nonatomic,assign)CGRect tagsBgViewFrame;
//标签数组
@property(nonatomic,strong)NSArray *tagFrames;
//cell高度
@property(nonatomic,assign)CGFloat  cellHeight;
@property(nonatomic,strong)MyOfferUniversityModel  *universtiy;

+ (instancetype)frameWithUniversity:(NSDictionary *)uni_Info;

@end
