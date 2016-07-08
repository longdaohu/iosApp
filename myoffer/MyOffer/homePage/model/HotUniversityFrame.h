//
//  HotUniversityFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityObj;
@interface HotUniversityFrame : NSObject
//背景
@property(nonatomic,assign)CGRect  bgViewFrame;
//LOGO图片
@property(nonatomic,assign)CGRect  LogoFrame;
//学校名称
@property(nonatomic,assign)CGRect  TitleFrame;
//主要显示英文学校名称
@property(nonatomic,assign)CGRect  SubTitleFrame;
//分隔线
@property(nonatomic,assign)CGRect  LineFrame;
//地理位置
@property(nonatomic,assign)CGRect  LocalFrame;
//地理图标
@property(nonatomic,assign)CGRect  LocalMVFrame;
//用于显示 星号图标
@property(nonatomic,assign)CGRect  starBgFrame;
//星星数组
@property(nonatomic,strong)NSArray *starFrames;
//标签背景
@property(nonatomic,assign)CGRect tapBgViewFrame;
//标签数组
@property(nonatomic,strong)NSArray *tapFrames;
//cell高度
@property(nonatomic,assign)CGFloat  cellHeight;
@property(nonatomic,strong)UniversityObj  *university;
@property(nonatomic,strong)NSDictionary *universityDic;



@end
