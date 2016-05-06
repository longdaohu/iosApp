//
//  FilterItem.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/16.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterItem : NSObject
@property(nonatomic,copy)NSString *courseName;
@property(nonatomic,copy)NSString *courseID;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)FilterItemWithDictionary:(NSDictionary *)dict;
@end
