//
//  YasiCatigoryItemModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YasiCatigoryItemModel : NSObject

@property(nonatomic,copy)NSString *_id ;
@property(nonatomic,copy)NSString *name ;
@property(nonatomic,copy)NSString *category_id ;
@property(nonatomic,copy)NSString *old_price ;
@property(nonatomic,copy)NSString *price ;

@property(nonatomic,strong)NSArray *notes_application;
@property(nonatomic,strong)NSArray *asken_questions;
@property(nonatomic,strong)NSArray *course_description;
@property(nonatomic,strong)NSArray *course_outline;

@property(nonatomic,strong)NSArray *items;

@property(nonatomic,assign)NSInteger current_selected;

@end

