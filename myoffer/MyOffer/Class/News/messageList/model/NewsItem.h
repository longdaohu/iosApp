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
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *view_count;
@property(nonatomic,copy)NSString *update_at;
@property(nonatomic,copy)NSString *message_id;

@end
