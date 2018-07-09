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
    SectionGroupTypeB,
    SectionGroupTypeC,
    SectionGroupTypeD,
    SectionGroupTypeE,
    SectionGroupTypeCreateOrderContact,//合同信息
    SectionGroupTypeCreateOrderMassage,
    SectionGroupTypeCreateOrderActive,
    SectionGroupTypeCreateOrderEnjoy,
    SectionGroupTypeHotCommodities,
    SectionGroupTypePopularActivity,
    SectionGroupTypeHotVideo,
    SectionGroupTypeArticleColumn,
    SectionGroupTypeApplyUniversity,
    SectionGroupTypeApplyDestination,
    SectionGroupTypeApplySubject,
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
