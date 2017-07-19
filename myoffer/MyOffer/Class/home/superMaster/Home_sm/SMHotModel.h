//
//  SMHotModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMHotModel : NSObject
@property(nonatomic,copy)NSString *ad_post_mc;
@property(nonatomic,copy)NSString *ad_post_pc;
@property(nonatomic,copy)NSString *guest_name;
@property(nonatomic,copy)NSString *guest_subject;
@property(nonatomic,copy)NSString *guest_university;
@property(nonatomic,copy)NSString *main_title;
@property(nonatomic,copy)NSString *offline_url;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,copy)NSString *hot_id;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,assign)BOOL has_audio;
@property(nonatomic,assign)BOOL has_video;
@property(nonatomic,strong)NSArray *tags;


@end
