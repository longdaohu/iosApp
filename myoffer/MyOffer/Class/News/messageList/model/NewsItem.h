//
//  NewsItem.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject
@property(nonatomic,copy)NSString *cover_url_thumbnail;
@property(nonatomic,copy)NSString *LogoName;
@property(nonatomic,copy)NSString *messageTitle;
@property(nonatomic,copy)NSString *FocusCount;
@property(nonatomic,copy)NSString *Update_time;
@property(nonatomic,copy)NSString *messageID;

@end
