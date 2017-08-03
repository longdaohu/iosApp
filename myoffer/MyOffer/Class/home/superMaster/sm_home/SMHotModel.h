//
//  SMHotModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/18.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SMMessageType){
    
    SMMessageTypeAudio = 0,
    SMMessageTypeVedio,
    SMMessageTypeAudioVedio,
    SMMessageTypeOffLine
};

@interface SMHotModel : NSObject
@property(nonatomic,copy)NSString *ad_post_mc;
@property(nonatomic,copy)NSString *ad_icon;
@property(nonatomic,copy)NSString *guest_name;
@property(nonatomic,copy)NSString *guest_subject;
@property(nonatomic,copy)NSString *guest_university;
@property(nonatomic,copy)NSString *main_title;
@property(nonatomic,copy)NSString *offline_url;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,copy)NSString *message_id;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *type_name;
@property(nonatomic,assign)BOOL has_audio;
@property(nonatomic,assign)BOOL has_video;
@property(nonatomic,assign)SMMessageType messageType;
@property(nonatomic,strong)NSArray *tags;


@end
