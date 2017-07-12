//
//  MessgeTopicModel.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessgeTopicModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,strong)NSArray *articles;

@end
