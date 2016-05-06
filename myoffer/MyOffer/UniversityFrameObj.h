//
//  UniversityFrameObj.h
//  myOffer
//
//  Created by sara on 16/4/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UniversityObj;

@interface UniversityFrameObj : NSObject
@property(nonatomic,strong)UniversityObj *uniObj;
//LOGO图片
@property(nonatomic,assign)CGRect  LogoFrame;
//学校名称
@property(nonatomic,assign)CGRect  TitleFrame;
//主要显示英文学校名称
@property(nonatomic,assign)CGRect  SubTitleFrame;
//地理位置
@property(nonatomic,assign)CGRect  LocalFrame;
@property(nonatomic,assign)CGRect  LocalMVFrame;
//排名
@property(nonatomic,assign)CGRect  RankFrame;
//用于显示 星号图标
@property(nonatomic,assign)CGRect  starBgFrame;
//推荐图标
@property(nonatomic,assign)CGRect  RecomandFrame;
@property(nonatomic,strong)NSArray *starFrames;


@end
