//
//  myofferGroupModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SectionGroupType){
    SectionGroupTypeA = 0,
    SectionGroupTypeArticalRecommendations,//相关文章数组
    SectionGroupTypeRelativeUniversity,//相关院校
    SectionGroupTypeMallDestination,//留学购 - 目的地
    SectionGroupTypeMallHotProduct,//留学购 -  热门商品
    SectionGroupTypeCreateOrderContact,//合同信息
    SectionGroupTypeCreateOrderMassage,
    SectionGroupTypeCreateOrderActive,//创建订单 - 活动通道
    SectionGroupTypeCreateOrderEnjoy,//创建订单 - 尊享通道
    SectionGroupTypeHotCommodities,//推荐 - 热门商品
    SectionGroupTypePopularActivity, //推荐 - 热门活动
    SectionGroupTypeHotVideo,//推荐 - 热门视频
    SectionGroupTypeBannerTheme,//推荐 - 专题攻略
    SectionGroupTypeArticleColumn, //留学申请 - 热门阅读
    SectionGroupTypeApplyUniversity, //留学申请 - 院校宝典
    SectionGroupTypeApplyDestination,//留学申请 - 目的地
    SectionGroupTypeApplySubject,   //留学申请 - 热门专业
    SectionGroupTypeRoomHotActivity,//推荐 - 热门活动
    SectionGroupTypeRoomHotCity,//海外租房 - 热门城市
    SectionGroupTypeRoomApartmentRecommendation, // 海外租房 - 公寓推荐
    SectionGroupTypeRoomHomestay,  // 海外租房 - 精选民宿
    SectionGroupTypeRoomCustomerPraise, // 海外租房 - 客户好评
    SectionGroupTypeRoomDetailPromotion, //房源详情:优惠活动
    SectionGroupTypeRoomDetailRoomType,//房源详情:房间类型
    SectionGroupTypeRoomDetailTypeIntroduction,//房源详情:公寓介绍
    SectionGroupTypeRoomDetailTypeFacility,//房源详情:公寓设施
    SectionGroupTypeRoomDetailTypeProcess //房源详情:须知

};

@interface myofferGroupModel : NSObject
@property(nonatomic,copy)NSString *header_title;
@property(nonatomic,copy)NSString *sub;
@property(nonatomic,copy)NSString *accesory_title;
@property(nonatomic,copy)NSString *footer_title;
@property(nonatomic,assign)CGFloat  section_footer_height;
@property(nonatomic,assign)CGFloat  section_header_height;
@property(nonatomic,assign)CGFloat  cell_offset_x;
//区分组信息
@property(nonatomic,assign)SectionGroupType type;
//分组是否有 >箭头
@property(nonatomic,assign)BOOL head_accesory_arrow;
//设置该group中的cell高度
@property(nonatomic,assign)CGFloat  cell_height_set;
//分组数据
@property(nonatomic,strong)NSArray *items;

+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header;
+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header footer:(NSString *)footer;
+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header footer:(NSString *)footer  accessory:(NSString *)accessory_title;


@end
