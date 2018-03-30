//
//  UniversityNew.h
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniversitydetailNew : NSObject
@property(nonatomic,copy)NSString     *NO_id;
@property(nonatomic,copy)NSString     *name;
@property(nonatomic,copy)NSString     *official_name;
@property(nonatomic,copy)NSString     *country;
@property(nonatomic,copy)NSString     *state;
@property(nonatomic,copy)NSString     *city;
@property(nonatomic,copy)NSString     *address_long;
@property(nonatomic,copy)NSString     *address_short;
@property(nonatomic,strong)NSNumber   *found; //建校年份
@property(nonatomic,copy)NSString     *logo;
@property(nonatomic,copy)NSString     *address;
@property(nonatomic,copy)NSString     *postcode;
@property(nonatomic,copy)NSString     *introduction;
@property(nonatomic,copy)NSString     *website;
@property(nonatomic,copy)NSString     *webpath;
@property(nonatomic,copy)NSString     *history_introduction; //学校历史
@property(nonatomic,copy)NSString     *geo_introduction;      //学校位置
@property(nonatomic,copy)NSString     *feature_introduction;  //学校特色
@property(nonatomic,copy)NSString     *apartment_introduction;  //学校公寓
@property(nonatomic,strong)NSArray    *apartment_images;       //公寓图片
@property(nonatomic,copy)NSString     *short_id;
@property(nonatomic,strong)NSArray    *relate_articles;        //关联文章
@property(nonatomic,strong)NSArray    *tags;              //标签
@property(nonatomic,strong)NSArray    *key_subjectArea;     //王牌领域
@property(nonatomic,strong)NSNumber   *pageViews;        //浏览量
@property(nonatomic,strong)NSArray    *m_images;
@property(nonatomic,strong)NSArray    *images;
@property(nonatomic,assign)BOOL       favorited;        //收藏标志
@property(nonatomic,strong)NSNumber   *map_longitude;   //经度
@property(nonatomic,strong)NSNumber   *map_latitude;    //纬度
@property(nonatomic,copy)NSString     *student_organization;    //学生组织
@property(nonatomic,copy)NSString     *airport_information;      //接机信息
@property(nonatomic,copy)NSString     *school_level;            //本科, 专科...
@property(nonatomic,assign)BOOL        private_flag; //0 false, 1 true, 私立学校标志
@property(nonatomic,assign)BOOL        cn_flag; //0 false, 1 true, 中国教育部认可
@property(nonatomic,assign)BOOL        hot; //0 false, 1 true, 热门院校
@property(nonatomic,copy)NSString     *category;  //院校类型：综合类, 理工类, 语言类...
@property(nonatomic,copy)NSString     *degree_level; //学位类型, 硕士, 博士...
@property(nonatomic,strong)NSDictionary  *rank; //排名信息
@property(nonatomic,strong)NSArray       *rankType; // 排名类别
@property(nonatomic,strong)NSArray       *languageRequirement; //  语言要求原始数据
@property(nonatomic,strong)NSNumber  *ranking_qs; //世界排名qs
@property(nonatomic,copy)NSString  *ranking_qs_str; //世界排名qs
@property(nonatomic,strong)NSNumber  *ranking_ti; //当地排名times
@property(nonatomic,copy)NSString  *ranking_ti_str; //当地排名times
@property(nonatomic,strong)NSArray       *global_rank_history; //世界排名qs历史
@property(nonatomic,strong)NSArray       *local_rank_history; //当地排名times历史
@property(nonatomic,strong)NSArray       *rankNeighbour; //排名相近学校
@property(nonatomic,strong)NSNumber      *school_fee_floor; // 学费下限
@property(nonatomic,strong)NSNumber      *school_fee_limit; // 学费上线
@property(nonatomic,strong)NSDictionary  *IELTSRequirement; //本科，硕士雅思要求
@property(nonatomic,strong)NSDictionary  *TOEFLRequirement; //本科，硕士托福要求
@property(nonatomic,strong)NSNumber      *employment_rate; //  就业率
@property(nonatomic,strong)NSNumber      *foreign_student_rate; // 外国学生比例 0.xx
@property(nonatomic,assign)BOOL login;

@end



