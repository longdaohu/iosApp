//
//  SMAudioItem.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAudioItem : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *file_url;
@property(nonatomic,copy)NSString *seconds_duration;
@property(nonatomic,assign)BOOL isPlay;
@property(nonatomic,assign)BOOL inPlaying;

@end
