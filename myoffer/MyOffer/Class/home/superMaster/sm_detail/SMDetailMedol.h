//
//  SMDetailMedol.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAudioModel.h"

@interface SMDetailMedol : NSObject

@property(nonatomic,copy)NSString *trial_video_url;
@property(nonatomic,copy)NSString *video_url;
@property(nonatomic,copy)NSString *offline_url;
@property(nonatomic,copy)NSString *message_id;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,copy)NSString *ad_post_pc;
@property(nonatomic,copy)NSString *ad_post_mc;
@property(nonatomic,assign)BOOL has_video;
@property(nonatomic,assign)BOOL has_audio;
@property(nonatomic,strong)SMAudioModel *audio;
@property(nonatomic,copy)NSString *type; // audio-视频音频, offline-线下活动
@property(nonatomic,strong)NSArray *sku;
@property(nonatomic,strong)NSArray *related;
@property(nonatomic,copy)NSString *main_title;
@property(nonatomic,copy)NSString *sub_title;
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,copy)NSString *introduction; // 活动介绍
@property(nonatomic,copy)NSString *guest_introduction; // 嘉宾介绍
@property(nonatomic,copy)NSString *guest_name;
@property(nonatomic,copy)NSString *guest_head_portrait;
@property(nonatomic,copy)NSString *guest_university;
@property(nonatomic,copy)NSString *guest_subject;
@property(nonatomic,copy)NSString *guest_subject_uni;
@property(nonatomic,copy)NSString *type_name;

@property(nonatomic,assign)BOOL islogin;


@end


