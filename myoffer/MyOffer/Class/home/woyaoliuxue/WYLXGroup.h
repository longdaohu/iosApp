//
//  WYLXGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2016/12/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYLXGroup : NSObject
@property(nonatomic,copy)NSString *headerTitle;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *cellKey;

+(instancetype)groupWithHeader:(NSString *)headerTitle content:(NSString *)content cellKey:(NSString *)key;

@end
