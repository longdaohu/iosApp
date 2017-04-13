//
//  UniversityNewFrame.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversitydetailNew.h"

@interface UniversityNewFrame : NSObject
@property(nonatomic,strong)UniversitydetailNew *item;
// 1、logo图片
@property(nonatomic,assign)CGRect logo_Frame;
//2、学校名称
@property(nonatomic,assign)CGRect name_Frame;
//3、英文名称
@property(nonatomic,assign)CGRect official_nameFrame;
//5、地址名称
@property(nonatomic,assign)CGRect address_detailFrame;
//4、网站名称
@property(nonatomic,assign)CGRect website_Frame;
//雅思、学费、就业、本地View 容器
@property(nonatomic,assign)CGRect dataView_Frame;
//雅思、学费、就业、本地View
@property(nonatomic,strong)NSArray *data_item_Frames;
//雅思、学费、就业、本地View  子项
@property(nonatomic,strong)NSArray *data_items_Frames;
@property(nonatomic,assign)CGRect data_item_iconFrame;
@property(nonatomic,assign)CGRect data_item_titleFrame;
@property(nonatomic,assign)CGRect data_item_subFrame;
@property(nonatomic,assign)CGRect data_item_countFrame;


//7、简介
@property(nonatomic,assign)CGRect introduction_Frame;
//显示更多
@property(nonatomic,assign)CGRect more_Frame;
//颜色映射
@property(nonatomic,assign)CGRect gradient_Frame;
//中间View的高度
@property(nonatomic,assign)CGFloat centerHeigh;
//显示排名、标签容器
@property(nonatomic,assign)CGRect upViewFrame;
//UITableViewHeaderView 高度
@property(nonatomic,assign)CGRect header_Frame;
//中间View
@property(nonatomic,assign)CGRect centerView_Frame;
//XXXXXView
@property(nonatomic,assign)CGRect downViewFrame;
//右侧分享、收藏
@property(nonatomic,assign)CGRect rightView_Frame;
//世界排名
@property(nonatomic,assign)CGRect QS_Frame;
//本国排名
@property(nonatomic,assign)CGRect TIMES_Frame;
//大学标签
@property(nonatomic,assign)CGRect tagsOneFrame;
@property(nonatomic,assign)CGRect tagsTwoFrame;
//是否展开
@property(nonatomic,assign)BOOL   showMore;


//第一分区Frame
@property(nonatomic,assign)CGRect fenguanFrame;
@property(nonatomic,assign)CGRect collectionViewFrame;
@property(nonatomic,assign)CGRect lineOneFrame;
@property(nonatomic,assign)CGRect keyFrame;
@property(nonatomic,assign)CGRect subjectBgFrame;
@property(nonatomic,strong)NSArray *subjectItemFrames;
@property(nonatomic,assign)CGRect lineTwoFrame;
@property(nonatomic,assign)CGRect rankFrame;
@property(nonatomic,assign)CGRect selectionFrame;
@property(nonatomic,assign)CGRect qsFrame;
@property(nonatomic,assign)CGRect timesFrame;
@property(nonatomic,assign)CGRect historyLineFrame;
@property(nonatomic,assign)CGRect chartViewBgFrame;
@property(nonatomic,assign)CGFloat contentHeight;

+ (instancetype)frameWithUniversity:(UniversitydetailNew *)university;
@end
