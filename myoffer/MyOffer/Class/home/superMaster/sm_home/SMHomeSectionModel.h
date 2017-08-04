//
//  SMHomeItem.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTagModel.h"

typedef NS_ENUM(NSInteger,SMGroupType){
    SMGroupTypeDefault = 0,
    SMGroupTypeNews,
    SMGroupTypeTags,
    SMGroupTypeAudios,
    SMGroupTypeSKUs,
    SMGroupTypeHot
};

@interface SMHomeSectionModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *accessory_title;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSArray *item_all;
@property(nonatomic,assign)SMGroupType groupType;
//是否显示全部
@property(nonatomic,assign)BOOL show_All_data;
//未显示全部时，限制展示几条数据
@property(nonatomic,assign)NSInteger limit_count;

+ (instancetype)sectionInitWithTitle:(NSString *)title Items:(NSArray *)items  groupType:(SMGroupType)groupType;

@end
