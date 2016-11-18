//
//  PipeiGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//


#import <Foundation/Foundation.h>
typedef enum {
    PipeiGroupTypeCountry = 0, // 字典的key
    PipeiGroupTypeUniversity,
    PipeiGroupTypeSubject,
   PipeiGroupTypeScorce
} PipeiGroupType;

@interface PipeiGroup : NSObject
@property(nonatomic,copy)NSString *header;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)PipeiGroupType groupType;
+ (instancetype)groupWithHeader:(NSString *)header groupType:(PipeiGroupType)type;
@end
