//
//  MessageArticle.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageArticle : NSObject
@property(nonatomic,copy)NSString *article_id;
@property(nonatomic,copy)NSString *short_id;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,copy)NSString *cover_url_thumbnail;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *summary;
@property(nonatomic,copy)NSString *category;
@property(nonatomic,copy)NSString *related_university_country;
@property(nonatomic,copy)NSString *source_url;
@property(nonatomic,copy)NSString *update_at;
@property(nonatomic,copy)NSString *right_str;
@property(nonatomic,strong)NSArray *related_universities;
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,copy)NSString *view_count;
@property(nonatomic,copy)NSString *author_portrait_url;
@property(nonatomic,copy)NSString *like_count;
@property(nonatomic,strong)NSArray *hot_articles;
@property(nonatomic,strong)NSArray *recommendations;



@end
 
