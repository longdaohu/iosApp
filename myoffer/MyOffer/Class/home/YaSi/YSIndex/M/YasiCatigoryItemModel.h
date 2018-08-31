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
@property(nonatomic,copy)NSString *course_description ;
@property(nonatomic,copy)NSString *course_outline ;
@property(nonatomic,copy)NSString *old_price ;
@property(nonatomic,copy)NSString *price ;

@property(nonatomic,assign)NSInteger current_selected;

@end
