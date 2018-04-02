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
@property(nonatomic,strong)UniversitydetailNew *uni;
@property(nonatomic,assign)CGRect logo_Frame;// 1、logo图片
@property(nonatomic,assign)CGRect name_Frame;//2、学校名称
@property(nonatomic,assign)CGRect official_nameFrame;//3、英文名称
@property(nonatomic,assign)CGRect website_Frame;//4、网站名称
@property(nonatomic,assign)CGRect address_detailFrame;//5、地址名称
@property(nonatomic,assign)CGRect dataView_Frame;//雅思、学费、就业、本地View 容器
@property(nonatomic,strong)NSArray *data_item_Frames;//雅思、学费、就业、本地View
@property(nonatomic,strong)NSArray *data_items_Frames;//雅思、学费、就业、本地View  子项
@property(nonatomic,assign)CGRect data_item_iconFrame;
@property(nonatomic,assign)CGRect data_item_titleFrame;
@property(nonatomic,assign)CGRect data_item_subFrame;
@property(nonatomic,assign)CGRect data_item_countFrame;


@property(nonatomic,assign)CGRect introduction_Frame;//7、简介
@property(nonatomic,assign)CGRect more_Frame;//显示更多
@property(nonatomic,assign)CGRect gradient_Frame;//颜色映射
@property(nonatomic,assign)CGFloat centerHeigh;//中间View的高度
@property(nonatomic,assign)CGRect upViewFrame;//显示排名、标签容器
@property(nonatomic,assign)CGRect header_Frame;//UITableViewHeaderView 高度
@property(nonatomic,assign)CGRect centerView_Frame;//中间View
//XXXXXView
@property(nonatomic,assign)CGRect downViewFrame;
@property(nonatomic,assign)CGRect rightView_Frame;//右侧分享、收藏
@property(nonatomic,assign)CGRect QS_Frame;//世界排名
@property(nonatomic,assign)CGRect TIMES_Frame;//本国排名
@property(nonatomic,strong)NSArray *tag_Frames;//大学标签
@property(nonatomic,assign)BOOL   showMore;//是否展开


//第一分区Frame
@property(nonatomic,assign)CGRect fenguan_Frame;//1、校园风光
@property(nonatomic,assign)CGRect collectionView_Frame;//2、校园风光图片容器
@property(nonatomic,assign)CGRect fg_line_Frame;//校园风光分隔线
@property(nonatomic,assign)CGRect key_Frame; //王牌领域
@property(nonatomic,assign)CGRect subject_Bg_Frame; //专业Array容器
@property(nonatomic,strong)NSArray *subjectItemFrames; //专业Array
@property(nonatomic,assign)CGRect key_line_Frame;//王牌领域分隔线
@property(nonatomic,assign)CGRect rank_Frame;//历史排名
@property(nonatomic,assign)CGRect selection_Frame; //历史排名选择项容器
@property(nonatomic,assign)CGRect qs_Frame;//世界排名按钮
@property(nonatomic,assign)CGRect times_Frame;//本国排名按钮
@property(nonatomic,assign)CGRect history_Line_Frame;//历史排名分隔线
@property(nonatomic,assign)CGRect chart_Bg_Frame;//图表
@property(nonatomic,assign)CGFloat group_One_Height;//第一分区高度

+ (instancetype)frameWithUniversity:(UniversitydetailNew *)university;

@end
